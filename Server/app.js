var express = require('express');
var mongoose = require('mongoose');
var bodyParser = require('body-parser');
var async = require('async');
var app = express();

mongoose.connect('mongodb://localhost/famHub');
require('./models/task.server.model');
require('./models/list.server.model');

var Task = require('mongoose').model('Task');
var List = require('mongoose').model('List');

var ObjectId = require('mongoose').Types.ObjectId;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
 
app.get('/', function(req, res, next) {
  res.send('Hello MASD Server!');
});

var postTasks = function(taskArr, callback) {

  console.log("tasksToPost");
  console.log(taskArr);

	 async.eachSeries(taskArr, function(obj, cb) {

  	Task.update({ "_id": obj._id },
  		{ "$set": 
  			{
  				"description": obj.description,
  				"posted": obj.posted,
  				"status": obj.status,
          "completed": obj.completed,
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

  console.log("in postLists")
  console.log(listArr)

	 async.eachSeries(listArr, function(obj, cb) {

  	List.update({ "_id": obj._id },
  		{ "$set": 
  			{ "name": obj.name,
  				"description": obj.description,
  				"created": new Date(obj.created),
  				"status": obj.status,
  				"date_modified": new Date(obj.date_modified),
          "user_id": obj.user_id,
          "isArchived": obj.isArchived,
          "tasks": obj.tasks
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

var getLists = function(user_id, lastSync, callback) {

  if (lastSync != null) {
    List.find({"user_id": user_id, "date_modified": { $gt: lastSync }}, function(err, results) {
      callback(results)
    });
  } else {

    console.log("in getLists with lastSync null")
     List.find({"user_id": user_id}, function(err, results) {
      
      callback(results);
    });
  }
}

var getTasks = function(lastSync, callback) {

  if (lastSync != null) {
    Task.find({"date_modified": { $gt: lastSync }}, function(err, results) {
      console.log("getTasks" + results);
      callback(results);
    });
  } else {
    Task.find({}, function(err, results) {
      console.log("getTasks" + results);
      callback(results);
    });
  }

	
}

app.post('/sync', function(req, res, next) {
	
  var user_id = req.body["user_id"];
  var lastSync = req.body["lastSync"];

	console.log("syncing...")
  console.log(req.body)



  // 1. Get server lists with date_modified gt lastSync
  // 2. Get server 

	async.series([
    function(callback) {
      console.log("Getting lists...");
      getLists(user_id, lastSync, function(lists) {
        console.log("in getLists callback..." + lists);
        return callback(null, lists);
      })
    }
		
	], function(err, results) {
		
		var lists_Server = results[0];

    var lists_Client = req.body["lists"];

    var listsToPost = [];
    var listsToReturn = [];

    clientList: for (var i = 0; i < lists_Client.length; i++) {
      var listC = lists_Client[i];
      
      serverList: for (var j = lists_Server.length - 1; j >= 0; j--) {
        var listS = lists_Server[j];
        
        if (listC["_id"] == listS._id) {
          if (listC["date_modified"] > listS.date_modified) {
            listsToPost.push(listC);
          }
          lists_Server.splice(j, 1);
          continue clientList;
         
        }
      }
     
      listsToPost.push(listC);
    }

    
    if (listsToReturn.length == 0) {
      listsToReturn = lists_Server
    } else {
      listsToReturn.concat(lists_Server);
    }
    


    if (lastSync == null) {
      listsToReturn = lists_Server;
    }

		var response = {
			"lists": listsToReturn
		};

    postLists(listsToPost, function() {
      
    });

    console.log("responseooooo")
    console.log(response)

    res.status(200).json(response).end();
	
		
	});

})

// function(callback) {
//       console.log("Posting lists...")
//       postLists(lists_Client, function() {

//         callback();
//       })
//     },
//     function(callback) {
//       console.log("Posting tasks...")
//       postTasks(tasks_Client, function() {
//         callback()
//       })
//     }

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

var server = app.listen(process.env.PORT || 3001, function () {
    console.log('[' + new Date().toISOString() + ']', 'MASD Server app listening on port', process.env.PORT || 3001);
});
