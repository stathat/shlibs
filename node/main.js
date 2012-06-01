// Copyright 2011 Numerotron, Inc. / Patrick Crosby
//
// StatHat API node.js module
//
(function() {

        var http = require('http');
        var https = require('https');

        var StatHat = {
                trackValue: function(user_key, stat_key, value, callback, secure) {
                        this._postRequest('/v', {key: stat_key, ukey: user_key, value: value}, callback, secure);
                },

                trackCount: function(user_key, stat_key, count, callback, secure) {
                        this._postRequest('/c', {key: stat_key, ukey: user_key, count: count}, callback, secure);
                },

                trackEZValue: function(ezkey, stat_name, value, callback, secure) {
                        this._postRequest('/ez', {ezkey: ezkey, stat: stat_name, value: value}, callback, secure);
                },

                trackEZCount: function(ezkey, stat_name, count, callback, secure) {
                        this._postRequest('/ez', {ezkey: ezkey, stat: stat_name, count: count}, callback, secure);
                },

                _postRequest: function(path, params, callback, secure) {
                        var qs = Object.keys(params)
                        .map( function(k) { return k + '=' + params[k] } )
                        .join('&');

                        var options = {
                                hostname: 'api.stathat.com',
                                port: secure === false ? 80 : 443,
                                path: path,
                                method: 'POST',
                                headers: {
                                        'Content-Type'   : 'application/x-www-form-urlencoded',
                                        'Content-Length' : qs.length
                                }
                        };

                        handleResult = function(res) {
                                res.on('data', function(chunk) {
                                        callback(res.statusCode, chunk);
                                });
                        }

                        var request;
                        if(secure === false) {
                                request = http.request(options, handleResult);
                        } else {
                                request = https.request(options, handleResult);
                        }

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
