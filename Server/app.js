var express = require('express');
var mongoose = require('mongoose');
var bodyParser = require('body-parser');
var app = express();

mongoose.connect('mongodb://localhost/famHub');
require('./models/list.server.model');
require('./models/task.server.model');

var List = require('mongoose').model('List');
var Task = require('mongoose').model('Task');
var ObjectId = require('mongoose').Types.ObjectId;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
 
app.get('/', function(req, res, next) {
  res.send('Hello MASD Server!');
});

app.post('/lists/:id/tasks', function(req, res, next) {
  console.log('post task')
  console.log(req.body);

  var description = req.body["description"];
  var list_id = req.params.id;

  var taskObj = {
    "description": description,
    "list_id": list_id
  }

  var task = new Task(taskObj);

  task.save(function(err, result) {
    if (err) { 
	  console.log(err) 
	  return 
	}
	console.log(result)
	res.status(200).json(result).end();
  }); 
});

app.get('/lists/:id/tasks', function(req, res, next) {
  console.log('get tasks')
  console.log(req.params.id)

  var list_id = req.params.id

  Task.find({"list_id": ObjectId(list_id)}, function(err, result) {
  	res.status(200).json(result).end();
  });
});

app.post('/lists/', function(req, res, next) {
  console.log('post a list')
  console.log(req.body);

  var name = req.body["name"];
  var description = req.body["description"];

  var listObj = {
  	"name": name,
    "description": description
  }

  var list = new List(listObj);

  list.save(function(err, result) {
    if (err) { 
	  console.log(err) 
	  return 
	}
	res.status(200).json(result).end();
  }); 
});

app.get('/lists/', function(req, res, next) {
  console.log('get lists')

  List.find({}, function(err, result) {
  	res.status(200).json(result).end();
  });
});

var server = app.listen(process.env.PORT || 8080, function () {
    console.log('[' + new Date().toISOString() + ']', 'MASD Server app listening on port ', process.env.PORT || 8080);
});
