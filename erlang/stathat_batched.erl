%%
%% @author Sam Elliott <sam@lenary.co.uk>
%% @version 0.1
%% @doc Gen Server for sending data to stathat.com stat tracking service, in batches.
%%
%% Requires https://github.com/bjnortier/mochijson2
%%
%% <h4>Example:</h4>
%% <pre><code>
%% 1&gt; {ok, Pid} = stathat_batched:start("erlang@stathat.com", 10).
%% 2&gt; stathat_batched:ez_count("messages sent", 1).
%% ok.
%% 3&gt; stathat_batched:ez_value("request time", 92.194).
%% ok.
%%

-module(stathat_batched).

-author("Sam Elliott <sam@lenary.co.uk>").
-version("0.1").

-behaviour(gen_server).

-export([start/2
        ,start_link/2
        ,child_definition/2
        ,ez_count/2
        ,ez_count/3
        ,ez_value/2
        ,ez_value/3
        ]).

-export([init/1
        ,handle_call/3
        ,handle_cast/2
        ,handle_info/2
        ,terminate/2
        ,code_change/3
        ]).

-record(sh_batched_state,
        {ezkey      :: binary()     % User-specified (RO): EzKey to send each batch with
        ,timer_ref  :: timer:tref() % Internal (RO): Timer Ref (so we send every <timeout> seconds)
        ,next_batch = []            % Internal (RW): Stats to send next
        ,in_flight  = dict:new()    % Internal (RW): Stats that have been sent that we're waiting for a HTTP Response for
        }).

-define(SH_TIMEOUT_MESSAGE, sh_timeout).

%%
% Public API
%%

-spec start(string(), pos_integer()) -> term().
start(Ezkey, Timeout) ->
  gen_server:start({local, ?MODULE}, ?MODULE, [Ezkey, Timeout], []).

-spec start_link(string(), pos_integer()) -> term().
start_link(Ezkey, Timeout) ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [Ezkey, Timeout], []).

% Use this to get a child definition for a supervisor
-spec child_definition(string(), pos_integer()) -> tuple().
child_definition(Ezkey, Timeout) ->
  {?MODULE, {?MODULE, start_link, [Ezkey, Timeout]}, permanent, infinity, worker, [?MODULE]}.

-spec ez_count(string(), integer()) -> ok.
ez_count(Stat, Count) ->
  ez_count(Stat, Count, unix_ts()).

-spec ez_count(string(), integer(), integer()) -> ok.
ez_count(Stat, Count, Ts) ->
  gen_server:cast(?MODULE, {ez_count, Stat, Count, Ts}).

-spec ez_value(string(), number()) -> ok.
ez_value(Stat, Value) ->
  ez_value(Stat, Value, unix_ts()).

-spec ez_value(string(), number(), integer()) -> ok.
ez_value(Stat, Value, Ts) ->
  gen_server:cast(?MODULE, {ez_value, Stat, Value, Ts}).

%%
% gen_server callbacks
%%
init([Ezkey, Timeout]) ->
  {ok, TRef} = timer:send_interval(timer:seconds(Timeout), ?SH_TIMEOUT_MESSAGE),
  NewState = #sh_batched_state{ezkey=list_to_binary(Ezkey)
                              ,timer_ref=TRef},
  case inets:start() of
    ok -> {ok, NewState};
    {error, {already_started, inets}} -> {ok, NewState};
    {error, Err} -> {stop, Err}
  end.


handle_call(_Request, _From, State) ->
  {reply, {error, unknown_request}, State}.


handle_cast({ez_count, Stat, Count, Ts}, State) ->
  EzCount = {struct, [{stat, list_to_binary(Stat)}, {count, Count}, {t, Ts}]},
  State1 = add_stat(State, EzCount),
  {noreply, State1};

handle_cast({ez_value, Stat, Value, Ts}, State) ->
  EzValue = {struct, [{stat, list_to_binary(Stat)}, {value, Value}, {t, Ts}]},
  State1 = add_stat(State, EzValue),
  {noreply, State1};

handle_cast(_Request, State) ->
  {noreply, State}.


handle_info(?SH_TIMEOUT_MESSAGE, State) ->
  State1 = send_and_reset(State),
  {noreply, State1};

handle_info({http, {RequestId, {error, _Reason}}}, State) ->
  State1 = send_failed(State, RequestId),
  {noreply, State1};

handle_info({http, {RequestId, {{_HttpVersion, Code, _Phrase}, _Headers, _Body}}}, State)
    when Code >= 200, Code < 300 ->
  State1 = send_successful(State, RequestId),
  {noreply, State1};
handle_info({http, {RequestId, {{_HttpVersion, _Code, _Phrase}, _Headers, _Body}}}, State) ->
  State1 = send_failed(State, RequestId),
  {noreply, State1};

handle_info(_Request, State) ->
  {noreply, State}.


terminate(_Reason, State = #sh_batched_state{timer_ref = TRef, next_batch = NextBatch}) ->
  % Cancel the Timer
  timer:cancel(TRef),

  % Send any remaining statistics
  send(State#sh_batched_state.ezkey, NextBatch),

  % We should do something with the in-flight keys, but I dunno what,
  % as we can't be sure whether they made it or not. :(
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%
% private methods
%%

% Give a Unix Timestamp (seconds since 1 Jan 1970)
-spec unix_ts() -> integer().
unix_ts() ->
  {MegaSecs, Secs, _} = os:timestamp(),
  MegaSecs*1000000 + Secs.

% Add another stat to the next batch to be sent
-spec add_stat(#sh_batched_state{}, tuple()) -> #sh_batched_state{}.
add_stat(State = #sh_batched_state{next_batch = Stats}, NewStat) ->
  State#sh_batched_state{next_batch = [NewStat|Stats]}.

% Sends the data to SH and resets State
-spec send_and_reset(#sh_batched_state{}) -> #sh_batched_state{}.
send_and_reset(State = #sh_batched_state{next_batch=[]}) ->
  % Nothing to be sent
  State;
send_and_reset(State = #sh_batched_state{next_batch=NextBatch, in_flight=InFlight}) ->
  % Stuff to be sent. YAY
  ReqId = send(State#sh_batched_state.ezkey, NextBatch),
  InFlight1 = dict:store(ReqId, NextBatch, InFlight),
  State#sh_batched_state{next_batch=[], in_flight=InFlight1}.

% Sends the data to stathat.com. Returns a request id for future tracking
-spec send(binary(), [tuple(),...]) -> reference().
send(EzKey, NextBatch) ->
  JsonData = {struct, [{ezkey, EzKey}, {data, NextBatch}]},
  Json = mochijson2:encode(JsonData),
  Request = {"http://api.stathat.com/ez", [], "application/json", iolist_to_binary(Json)},
  {ok, ReqId} = httpc:request(post, Request, [], [{sync, false}]),
  io:format("stathat: ~s ~p~n", [EzKey, NextBatch]),
  ReqId.

% Async callback for when a send has been successful
-spec send_successful(#sh_batched_state{}, reference()) -> #sh_batched_state{}.
send_successful(State = #sh_batched_state{in_flight = InFlight}, ReqId) ->
  InFlight1 = dict:erase(ReqId, InFlight),
  State#sh_batched_state{in_flight = InFlight1}.

% Async callback for when a send has failed. Will retry
-spec send_failed(#sh_batched_state{}, reference()) -> #sh_batched_state{}.
send_failed(State = #sh_batched_state{in_flight = InFlight}, ReqId) ->
  % This will retry forever.
  % An Exponential backoff would be better, but is more complex to code
  {ok, FailedBatch} = dict:find(ReqId, InFlight),
  InFlight1 = dict:erase(ReqId, InFlight),
  NewReqId = send(State#sh_batched_state.ezkey, FailedBatch),
  InFlight2 = dict:store(NewReqId, FailedBatch, InFlight1),
  State#sh_batched_state{in_flight=InFlight2}.
