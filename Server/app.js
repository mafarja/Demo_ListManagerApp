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

app.post('/logEvent/', function(req, res, next) {
  console.log("yo")
  console.log(req.body)
  console.log(req.body["events"])

  var eventsArr = req.body["events"];

  for (i = 0; i < eventsArr.length; i++) {
    var event = new Event(eventsArr[i])
    event.save()
  }

  res.status(200).send("Events logged").end();


});

app.get('/getEvents/', function(req, res, next) {

  var thirtyDaysAgo = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString()

  console.log(thirtyDaysAgo)

// db.events.aggregate([
//   	{$match: { posted: { $gte: '2019-01-15T20:07:33.620Z' } }},
//   	{$group: { _id: "$name", count: { $sum: 1 }}},
//   	{$sort: { count: -1 }}
//   ])

  Event.aggregate([
  	{$match: { posted: { $gte: new Date(thirtyDaysAgo) } }},
  	{$group: { _id: "$name", count: { $sum: 1 }}},
  	{$sort: { count: -1 }}
  ],
  function(err, result) {
  	if (err) {
  	  console.log("error aggregating" + err)
  	  res.status(500).json(err).end()
  	}

  	console.log(result)

  	res.status(200).json(result).end()
  });
});

// app.put('/progressions/:id', function(req, res, next) {
//   console.log('post progressions')

//   Progression.update({ _id: req.params.id }, function(err, result) {
//     if (err) { res.status(500).end; }
//     res.status(200).json().end();
//   });
// });

app.post('/lists/:id/tasks', function(req, res, next) {
  console.log('post task')

  console.log(req.body);

  var description = req.body["description"];
  var list_Id = req.params.id;

  var taskObj = {
    "description": description,
    "list": list_Id
  }

  var task = new Task(taskObj);

  task.save(function(err, result) {
    if (err) { 
	  console.log(err) 
	  return 
	}
	res.status(200).json(result).end();
  }); 
});

app.get('/lists/:id/tasks', function(req, res, next) {
  console.log('get tasks')

  console.log(req.params.id)

  var list_Id = req.params.id

  Task.find({"list": ObjectId(list_Id)}, function(err, result) {
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

app.get('/progressions/', function(req, res, next) {
  
});

var server = app.listen(process.env.PORT || 8080, function () {
    console.log('[' + new Date().toISOString() + ']', 'MASD Server app listening on port ', process.env.PORT || 8080);
});
