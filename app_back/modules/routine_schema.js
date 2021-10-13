const mongoose =require('mongoose')
const Schema = mongoose.Schema

var routineSchema = Schema({
    medname : {
        type:String,
        required:false,
    },
    medid : {
        type:String,
        required:true,
    },
    userid : {
        type:String,
        required:true,
        default:"1",
    },

})

module.exports = mongoose.model('routines',routineSchema ,'routine')