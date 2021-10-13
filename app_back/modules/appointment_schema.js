const mongoose =require('mongoose')
const Schema = mongoose.Schema

var appointmentSchema = Schema({
    doctorname : {
        type:String,
        required:true,
    },
    doctorphone : {
        type:String,
        required:true,
    },
    date : {
        type:Date,
        required:true,
    },
    specialty : {
        type:String,
        required:true,
    },
    checked : {
        type:Boolean,
        required:true,
        default:"false",
    },
    rappel : {
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

module.exports = mongoose.model('appointments',appointmentSchema ,'appointment')