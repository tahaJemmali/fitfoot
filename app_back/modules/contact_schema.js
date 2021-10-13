const mongoose =require('mongoose')
const Schema = mongoose.Schema

var contactSchema = Schema({
    firstName : {
        type:String,
        required:true,
    },

    phone : { "type": String, },
    contacttype : {
        type:String,
        required:true,
        default:'friend',
    },
    specialty : {
        type:String,
        required:false,
    },
    userid : {
        type:String,
        required:true,
        default:"1",
    },
    completedInformation : { "type": Boolean, "default": false }

})

module.exports = mongoose.model('contacts',contactSchema ,'contact')