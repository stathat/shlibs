module(..., package.seeall);

-- can download this package at http://w3.impa.br/~diego/software/luasocket/home.html#download
local http = require("socket.http")

function ez_count(ezkey, stat_name, count)
        return http.request("http://api.stathat.com/ez", "ezkey=" .. ezkey .. "&stat=" .. stat_name .. "&count=" .. count)
end

function ez_value(ezkey, stat_name, value)
        return http.request("http://api.stathat.com/ez", "ezkey=" .. ezkey .. "&stat=" .. stat_name .. "&value=" .. value)
end

function count(stat_key, user_key, count)
        return http.request("http://api.stathat.com/c", "key=" .. stat_key .. "&ukey=" .. user_key .. "&count=" .. count)
end

function value(stat_key, user_key, value)
        return http.request("http://api.stathat.com/v", "key=" .. stat_key .. "&ukey=" .. user_key .. "&value=" .. value)
end
