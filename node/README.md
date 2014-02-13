# StatHat API Module for Node.js

This a module to make interacting with the [stathat.com](http://www.stathat.com)
API easy.

## Install

    npm install stathat

## Example

    var stathat = require('stathat');

    stathat.trackEZCount('you@example.com', 'messages sent - female to male', 3,
        function(status, json) {
            console.log("status: " + status);
            console.log("json:   " + json);
        });

## Methods

### stathat.trackEZCount(email, stat_name, count, callback)

Track a counter using the EZ API.  `stat_name` can be a new stat name and
you can create new stats for your account in the middle of your code
without having to create them on the stathat.com site.  The callback is
called with the status of the call and the json response.

### stathat.trackEZValue(email, stat_name, value, callback)

Track a value using the EZ API.  `stat_name` can be a new stat name and
you can create new stats for your account in the middle of your code
without having to create them on the stathat.com site.  The callback is
called with the status of the call and the json response.

### stathat.trackCount(user_key, stat_key, count, callback)

Track a counter using the classic API.  Get `user_key` and `stat_key`
from the details page for a stat on [stathat.com](http://www.stathat.com).
The callback is called with the the status of the call and the json response.

### stathat.trackValue(user_key, stat_key, value, callback)

Track a value using the classic API.  Get `user_key` and `stat_key`
from the details page for a stat on [stathat.com](http://www.stathat.com).
The callback is called with the the status of the call and the json response.

## HTTPS

To submit requests via HTTPS instead of HTTP (the default), do the following
once:

    var stathat = require('stathat');
    stathat.useHTTPS = true;

All subsequent requests will use HTTPS.

## Contact

You can find more examples using this module on [stathat.com/examples](http://www.stathat.com/examples).

Contact the StatHat programmers on twitter: [@stathat](http://twitter.com/stathat).

Written by Patrick Crosby
Email me directly:  patrick at the name of this module dot com

