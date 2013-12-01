var express = require('express');
var mysql = require('mysql');

var app = express();
var db;

var connection;

function handleDisconnect(cb) {
  db = mysql.createConnection(process.env.DOKKU_MARIADB_URL);

  db.connect(function(err) {
    if(err) {
      console.log('error when connecting to db:', err);
      setTimeout(handleDisconnect, 2000);
    }
    else {
      cb();
    }
  });

  db.on('error', function(err) {
    console.log('db error', err);
    if(err.code === 'PROTOCOL_CONNECTION_LOST') {
      handleDisconnect(cb);
    } else {
      throw err;
    }
  });
}

handleDisconnect(function() {
  db.query('CREATE TABLE IF NOT EXISTS map (name varchar(64), value varchar(64))');
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
  db.query('SELECT value FROM map WHERE name = ?', [request.params.key], function(err, results) {
    if (err) {
      response.status(500).end();
    }
    else if (results.length == 0) {
      response.status(404).end();
    }
    else {
      response.send(results[0].value);
    }
  });
});

app.put('/:key', function(request, response) {
  db.query('INSERT INTO map(name, value) VALUES(?, ?)', [request.params.key, request.rawBody], function(err, result) {
    if (err) {
      response.status(500).send(err);
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
