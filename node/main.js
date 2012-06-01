// Copyright 2011 Numerotron, Inc. / Patrick Crosby
//
// StatHat API node.js module
//
(function() {

        var https = require('https');

        var StatHat = {
                trackValue: function(user_key, stat_key, value, callback) {
                        this._postRequest('/v', {key: stat_key, ukey: user_key, value: value}, callback);
                },

                trackCount: function(user_key, stat_key, count, callback) {
                        this._postRequest('/c', {key: stat_key, ukey: user_key, count: count}, callback);
                },

                trackEZValue: function(ezkey, stat_name, value, callback) {
                        this._postRequest('/ez', {ezkey: ezkey, stat: stat_name, value: value}, callback);
                },

                trackEZCount: function(ezkey, stat_name, count, callback) {
                        this._postRequest('/ez', {ezkey: ezkey, stat: stat_name, count: count}, callback);
                },

                _postRequest: function(path, params, callback) {
                        var qs = Object.keys(params)
                        .map( function(k) { return k + '=' + params[k] } )
                        .join('&');

                        var options = {
                                hostname: 'api.stathat.com',
                                port: 443,
                                path: path,
                                method: 'POST',
                                headers: {
                                        'Content-Type'   : 'application/x-www-form-urlencoded',
                                        'Content-Length' : qs.length
                                }
                        };

                        var request = https.request(options, function(res) {
                                res.on('data', function(chunk) {
                                        callback(res.statusCode, chunk);
                                });
                        });

                        request.on('error', function(e) {
                                if (!e) e = {};
                                //console.error("StatHat HTTP error: "+e.message);
                                callback(600,e.message);
                        });

                        request.write(qs);

                        request.end();
                },
        };

        module.exports = StatHat;

}())
