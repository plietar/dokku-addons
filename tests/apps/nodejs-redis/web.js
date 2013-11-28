var express = require('express');
var redis = require('redis');
var url = require('url');

var redisURL = url.parse(process.env.DOKKU_REDIS_URL)

var app = express();
var client = redis.createClient(redisURL.port, redisURL.hostname, {auth_pass: redisURL.auth});

app.use(express.logger());

// Raw body
app.use(function(req, res, next) {
    var data = '';
    req.setEncoding('utf8');
    req.on('data', function(chunk) { 
        data += chunk;
    });
    req.on('end', function() {
        req.rawBody = data;
        next();
    });
});

app.get('/:key', function(request, response) {
  client.get(request.params.key, function(err, result) {
    if (err) {
      response.status(500).end();
    }
    else if (result == null) {
      response.status(404).end();
    }
    else {
      response.send(result);
    }
  });
});

app.put('/:key', function(request, response) {
  client.set(request.params.key, request.rawBody);
  response.end()
});

var port = process.env.PORT || 5000;
app.listen(port, function() {
  console.log("Listening on " + port);
});
