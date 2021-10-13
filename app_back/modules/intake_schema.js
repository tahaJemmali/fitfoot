const mongoose =require('mongoose')
const Schema = mongoose.Schema

var intakeSchema = Schema({
    medname : {
        type:String,
        required:false,
    },
    medid : {
        type:String,
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
    checked : {
        type:Boolean,
        required:true,
        default:"false",
    },
    userid : {
        type:String,
        required:true,
        default:"1",
    },

})

module.exports = mongoose.model('intakes',intakeSchema ,'intake')