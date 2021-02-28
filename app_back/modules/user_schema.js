const mongoose =require('mongoose')
const Schema = mongoose.Schema

var userSchema = Schema({
    email : {
        type:String,
        required:true
    },
    password : {
        type:String,
        required:true
    },
    salt: String,
    sign_up_date : { "type": Date, "default": Date.now },

    firstName : String,
    lastName: String,
    address: { "type": String, "default": "Not mentioned" },
    phone : { "type": String, "default": "Not mentioned" },
    photo : { "type": String, "default": "Not mentioned" },
    last_login_date : Date,
    score : Number ,
    birth_date : Date,
    signed_up_with : String,
    activation : { "type": Boolean, "default": false },
    completedInformation : { "type": Boolean, "default": false }

})

module.exports = mongoose.model('user',userSchema ,'user')