// Copyright 2011-2014 Numerotron, Inc. / Patrick Crosby
//
// StatHat API node.js module
//
(function() {

        var http = require('http');
        var https = require('https');

        var StatHat = {
                useHTTPS: false,
                trackValue: function(user_key, stat_key, value, callback) {
                        this._postRequest('/v', {key: stat_key, ukey: user_key, value: value}, callback);
                },

                trackValueWithTime: function(user_key, stat_key, value, timestamp, callback) {
                        this._postRequest('/v', {key: stat_key, ukey: user_key, value: value, t: timestamp}, callback);
                },

                trackCount: function(user_key, stat_key, count, callback) {
                        this._postRequest('/c', {key: stat_key, ukey: user_key, count: count}, callback);
                },

                trackCountWithTime: function(user_key, stat_key, count, timestamp, callback) {
                        this._postRequest('/c', {key: stat_key, ukey: user_key, count: count, t: timestamp}, callback);
                },

                trackEZValue: function(ezkey, stat_name, value, callback) {
                        this._postRequest('/ez', {ezkey: ezkey, stat: stat_name, value: value}, callback);
                },

                trackEZValueWithTime: function(ezkey, stat_name, value, timestamp, callback) {
                        this._postRequest('/ez', {ezkey: ezkey, stat: stat_name, value: value, t: timestamp}, callback);
                },

                trackEZCount: function(ezkey, stat_name, count, callback) {
                        this._postRequest('/ez', {ezkey: ezkey, stat: stat_name, count: count}, callback);
                },

                trackEZCountWithTime: function(ezkey, stat_name, count, timestamp, callback) {
                        this._postRequest('/ez', {ezkey: ezkey, stat: stat_name, count: count, t: timestamp}, callback);
                },

                _postRequest: function(path, params, callback) {
                        var qs = Object.keys(params)
                        .map( function(k) { return k + '=' + params[k] } )
                        .join('&');

                        var options = {
                                hostname: 'api.stathat.com',
                                path: path,
                                method: 'POST',
                                headers: {
                                        'Content-Type'   : 'application/x-www-form-urlencoded',
                                        'Content-Length' : qs.length
                                }
                        };

                        var hmod = this.useHTTPS ? https : http;
                        var request = hmod.request(options, function(res) {
                                res.on('data', function(chunk) {
                                        callback(res.statusCode, chunk);
                                });
                        });

                        request.on('error', function(e) {
                                if (!e) e = {};
                                callback(600,e.message);
                        });

                        request.write(qs);

                        request.end();
                },
        };

        module.exports = StatHat;

}())
