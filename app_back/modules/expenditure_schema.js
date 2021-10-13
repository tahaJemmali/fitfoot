const mongoose =require('mongoose')
const Schema = mongoose.Schema

var expenditureSchema = Schema({
    activityid : {
        type:String,
        required:true,
    },

    activityname : {
        type:String,
        required:true,
    },

    caloriesburned : {
        type:Number,
        required:true,
    },

    duration : {
        type:Number,
        required:true,
    },

    date : {
        type:Date,
        required:true,
    },
    userid : {
        type:String,
        required:true,
        default:"1",
    },

})

module.exports = mongoose.model('expenditures',expenditureSchema ,'expenditure')