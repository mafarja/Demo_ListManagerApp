var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    Task = mongoose.model('Task').schema;

var List = new Schema({
  name: String,
  description: String,
  created: {
  	type: Date,
  	default: Date.now
  },
  date_modified: {
  	type: Date
  },
  user_id: String,
  isArchived: Boolean,
  tasks: [Task]
});

mongoose.model('List', List);