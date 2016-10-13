-- can download this package at https://github.com/diegonehab/luasocket
-- or via luarocks: luarocks install luasocket
local http = require("socket.http")

local stathat = {}

function stathat.ez_count(ezkey, stat_name, count)
        return http.request("http://api.stathat.com/ez", ("ezkey=%s&stat=%s&count=%s"):format(ezkey, stat_name, count)
end

function stathat.ez_value(ezkey, stat_name, value)
        return http.request("http://api.stathat.com/ez", ("ezkey=%s&stat=%s&value=%s"):format(ezkey, stat_name, value)
end

function stathat.count(stat_key, user_key, count)
        return http.request("http://api.stathat.com/c", ("key=%s&ukey=%s&count=%s"):format(stat_key, user_key, count)
end

function stathat.value(stat_key, user_key, value)
        return http.request("http://api.stathat.com/v", ("key=%s&ukey=%s&value=%s"):format(stat_key, user_key, value)
end

return stathat
