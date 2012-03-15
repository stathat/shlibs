// Copyright 2011 Numerotron, Inc. / Patrick Crosby
//
// StatHat API node.js module
//

var http = require('http');

var StatHat = {
        trackValue: function(user_key, stat_key, value, callback) {
                this._postRequest('/v', {key: stat_key, ukey: user_key, value: value}, callback);
        },
        
        trackCount: function(user_key, stat_key, count, callback) {
                this._postRequest('/c', {key: stat_key, ukey: user_key, count: count}, callback);
        },
        
        trackEZValue: function(email, stat_name, value, callback) {
                this._postRequest('/ez', {email: email, stat: stat_name, value: value}, callback);
        },

        trackEZCount: function(email, stat_name, count, callback) {
                this._postRequest('/ez', {email: email, stat: stat_name, count: count}, callback);
        },

        _postRequest: function(path, params, callback) {
                var options = {
                        host: 'api.stathat.com',
                        port: 80,
                        path: path,
                        method: 'POST'
                };

                var request = http.request(options, function(res) {
                        res.on('data', function(chunk) {
                                callback(res.statusCode, chunk);
                        });
                });

                var key;
                for (key in params) {
                        request.write(key + "=" + params[key] + "\n");
                }
                request.end();
        },
};

module.exports = StatHat;

