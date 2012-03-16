// Copyright 2011 Numerotron, Inc. / Patrick Crosby
//
// StatHat API node.js module
//
(function() {

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

                var request = http.request(options, function(res) {
                        res.on('data', function(chunk) {
                                callback(res.statusCode, chunk);
                        });
                });
                request.write(qs);

                request.end();
        },
};

module.exports = StatHat;

}())
