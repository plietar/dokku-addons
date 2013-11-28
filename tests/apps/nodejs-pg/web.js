var express = require('express');
var pg = require('pg');

var app = express();
var db  = new pg.Client(process.env.DOKKU_POSTGRESQL_URL);

db.connect(function(err) {
  if(err) {
    return console.error('could not connect to postgres', err);
  }

  db.query('CREATE TABLE IF NOT EXISTS map (key varchar(64), value varchar(64))');
});

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
  db.query('SELECT value FROM map WHERE key = $1', [request.params.key], function(err, result) {
    if (err) {
      response.status(500).end();
    }
    else if (result.rows.length == 0) {
      response.status(404).end();
    }
    else {
      response.send(result.rows[0].value);
    }
  });
});

app.put('/:key', function(request, response) {
  db.query('INSERT INTO map(key, value) VALUES($1, $2)', [request.params.key, request.rawBody], function(err, result) {
    if (err) {
      response.status(500).end();
    }
    else {
      response.status(201).end();
    }
  });
});

var port = process.env.PORT || 5000;
app.listen(port, function() {
  console.log("Listening on " + port);
});
