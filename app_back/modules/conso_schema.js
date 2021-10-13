const mongoose =require('mongoose')
const Schema = mongoose.Schema

var consoSchema = Schema({
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
    date : {
        type:Date,
        required:true,
    },

})

module.exports = mongoose.model('consos',consoSchema ,'conso')