var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var List = new Schema({
  name: String,
  description: String,
  status: String,
  created: {
  	type: Date,
  	default: Date.now
  }
});

mongoose.model('List', List);