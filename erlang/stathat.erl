%%
%% @author Patrick Crosby <patrick@stathat.com>
%% @version 0.1
%% @doc Module for sending data to stathat.com stat tracking service.
%%
%% <h4>Example:</h4>
%% <pre><code>
%% 1&gt; inets:start().
%% 2&gt; {ok, RequestId} = stathat:ez_count("erlang@stathat.com", "messages sent - female to male", 1).
%% 3&gt; receive {http, {RequestId, Result}} -> ok after 500 -> error end.
%% 4&gt; {ok, RequestIdNext} = stathat:ez_value("erlang@stathat.com", "request time", 92.194).
%% 5&gt; receive {http, {RequestIdNext, ResultNext}} -> ok after 500 -> error end.
%%

-module(stathat).

-author("Patrick Crosby <patrick@stathat.com>").
-version("0.1").

-export([
                ez_count/3,
                ez_value/3,
                cl_count/3,
                cl_value/3
        ]).


%-define(BASE_URL(X), "http://www.stathat.com/" ++ X).
-define(BASE_URL(X), "http://localhost:8080/" ++ X).

ez_count(Ezkey, Stat, Count) ->
        Url = build_url("ez", [{"ezkey", Ezkey}, {"stat", Stat}, {"count", ntoa(Count)}]),
        httpc:request(get, {?BASE_URL(Url), []}, [], [{sync, false}]).

ez_value(Ezkey, Stat, Value) ->
        Url = build_url("ez", [{"ezkey", Ezkey}, {"stat", Stat}, {"value", ntoa(Value)}]),
        httpc:request(get, {?BASE_URL(Url), []}, [], [{sync, false}]).

cl_count(UserKey, StatKey, Count) ->
        Url = build_url("c", [{"ukey", UserKey}, {"key", StatKey}, {"count", ntoa(Count)}]),
        httpc:request(get, {?BASE_URL(Url), []}, [], [{sync, false}]).

cl_value(UserKey, StatKey, Value) ->
        Url = build_url("v", [{"ukey", UserKey}, {"key", StatKey}, {"value", ntoa(Value)}]),
        httpc:request(get, {?BASE_URL(Url), []}, [], [{sync, false}]).

ntoa(Num) when is_list(Num) ->
        Num;
ntoa(Num) when is_float(Num) ->
        lists:flatten(io_lib:format("~f", [Num]));
ntoa(Num) when is_integer(Num) ->
        integer_to_list(Num).

% url utility functions (borrowed from twitter_client module)

build_url(Url, []) -> Url;
build_url(Url, Args) ->
        Url ++ "?" ++ lists:concat(
                lists:foldl(
                        fun (Rec, []) -> [Rec]; (Rec, Ac) -> [Rec, "&" | Ac] end, [],
                                [K ++ "=" ++ url_encode(V) || {K, V} <- Args]
                )
        ).

url_encode([H|T]) ->
        if
                H >= $a, $z >= H ->
                        [H|url_encode(T)];
                H >= $A, $Z >= H ->
                        [H|url_encode(T)];
                H >= $0, $9 >= H ->
                        [H|url_encode(T)];
                H == $_; H == $.; H == $-; H == $/; H == $: -> % FIXME: more..
        [H|url_encode(T)];
true ->
        case integer_to_hex(H) of
                [X, Y] ->
                        [$%, X, Y | url_encode(T)];
                [X] ->
                        [$%, $0, X | url_encode(T)]
        end
end;

url_encode([]) -> [].

integer_to_hex(I) ->
        case catch erlang:integer_to_list(I, 16) of
                {'EXIT', _} ->
                        old_integer_to_hex(I);
                Int ->
                        Int
        end.

old_integer_to_hex(I) when I<10 ->
        integer_to_list(I);
old_integer_to_hex(I) when I<16 ->
        [I-10+$A];
old_integer_to_hex(I) when I>=16 ->
        N = trunc(I/16),
        old_integer_to_hex(N) ++ old_integer_to_hex(I rem 16).

