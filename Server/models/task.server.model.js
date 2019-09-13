var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var Task = new Schema({
  description: String,
  status: String,
  posted: {
  	type: Date,
  	default: Date.now
  },
  list: {
  	type: mongoose.Schema.Types.ObjectId,
  	ref: 'List'
  }
});

mongoose.model('Task', Task);