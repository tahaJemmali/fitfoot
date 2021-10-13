const mongoose = require('mongoose')
const Schema = mongoose.Schema

var userSchema = Schema({
    firstName: String,
    lastName: String,
    email: {
        type: String,
        required: true
    },
    emailDoctor: {
        type: String,
    },
    emailVerification: { "type": Boolean, "default": false },
    password: {
        type: String,
        required: true
    },
    salt: String,
    birthDate: Date,

    weight: { "type": Number },
    height: { "type": Number },
    gender: {
        "type": String, enum: ['Homme', 'Femme'],
        default: 'Homme'
    },

    phone: { "type": String },
    photo: { "type": String },
    phoneDoctor: { "type": String },
    address: { "type": String },
    signUpDate: { "type": Date, "default": Date.now },
    lastLoginDate: Date,
})

module.exports = mongoose.model('user', userSchema,'user')
