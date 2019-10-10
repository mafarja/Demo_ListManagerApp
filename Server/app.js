var express = require('express');
var mongoose = require('mongoose');
var bodyParser = require('body-parser');
var async = require('async');
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

var postTasks = function(taskArr, callback) {

	 async.eachSeries(taskArr, function(obj, cb) {

  	Task.update({ "_id": obj._id },
  		{ "$set": 
  			{
  				"description": obj.description,
  				"posted": obj.posted,
  				"status": obj.status,
  				"list_id": obj.list_id,
  				"date_modified": obj.date_modified

  			}
  		}, 
  		{ "upsert": true,
  		  "multi": true },
  	function(err, results) {
  		if (err) {
  			console.log(err)
  			return
  		}
  		console.log("here we are")
  		console.log(results)
  		cb()
  	});
  }, function(err) {
  	
  	if (err) {
  		console.log(err)
  		callback(err)
  		return
  	}
  	callback()
  	
  });  
}

var postLists = function(listArr, callback) {

	 async.eachSeries(listArr, function(obj, cb) {

  	List.update({ "_id": obj._id },
  		{ "$set": 
  			{ "name": obj.name,
  				"description": obj.description,
  				"created": obj.created,
  				"status": obj.status,
  				"date_modified": obj.date_modified
  			}
  		}, 
  		{ "upsert": true,
  		  "multi": true },
  	function(err, results) {
  		if (err) {
  			console.log(err)
  			return
  		}
  		console.log("here we are")
  		console.log(results)
  		cb()
  	});
  }, function(err) {
  	
  	if (err) {
  		console.log(err)
  		callback(err)
  		return
  	}
  	callback()
  });
}

var getLists = function(callback) {
	List.find({}, function(err, results) {
		console.log("getLists" + results);
  	callback(results);
  });
}

var getTasks = function(callback) {
	Task.find({}, function(err, results) {
		console.log("getTasks" + results);
  	callback(results);
  });
}

app.post('/sync', function(req, res, next) {
	var listArr = req.body["lists"];
	var taskArr = req.body["tasks"];

	console.log(listArr)
	console.log("help")
	console.log(taskArr)

	async.series([
		function(callback) {
			console.log("Posting lists...")
			postLists(listArr, function() {

				callback();
			})
		},
		function(callback) {
			console.log("Posting tasks...")
			postTasks(taskArr, function() {
				callback()
			})
		},
		function(callback) {
			console.log("Getting lists...");
			getLists(function(lists) {
				console.log("in getLists callback..." + lists);
				callback(null, lists);
			})
		},
		function(callback) {
			console.log("Getting tasks...");
			getTasks(function(tasks) {
				console.log("in getTasks callback..." + tasks);
				callback(null, tasks);
			})
		}


	], function(err, results) {
		console.log("async results " + results[2])

		var lists = results[2]
		var tasks = results[3]

		var response = {
			"lists": lists,
			"tasks": tasks
		};
	
		res.status(200).json(response).end();
	});

})

app.post('/lists/:id/tasks', function(req, res, next) {
  console.log('post tasks')
  var taskArr = req.body["tasks"];
  console.log(taskArr);

  postTasks(taskArr, function() {
    console.log("ALL DONE with Tasks")
    res.status(200).json({}).end();
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
  
  var listArr = req.body["lists"];

  console.log(listArr);

  postLists(listArr, function() {
    console.log("ALL DONE with lists")
  	res.status(200).json({}).end();
  });
});

app.get('/lists/', function(req, res, next) {
  console.log('get lists')

  getLists(function(lists) {
  	res.status(200).json(lists).end();
  });	
});

var server = app.listen(process.env.PORT || 8080, function () {
    console.log('[' + new Date().toISOString() + ']', 'MASD Server app listening on port ', process.env.PORT || 8080);
});
