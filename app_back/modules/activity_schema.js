const mongoose =require('mongoose')
const Schema = mongoose.Schema

var activitySchema = Schema({
    name : {
        type:String,
        required:true,
    },

    met : {
        type:Number,
        required:true,
    },


})

module.exports = mongoose.model('activities',activitySchema ,'activity')