const mongoose = require('mongoose')
const Schema = mongoose.Schema
var piedSchema = Schema({
    cote: String,
    temperature: Number,
    dimention: Number,
    rougeur : Number,
    etat : Number,
    image : String,
    amelioration : Number
})
module.exports = mongoose.model('pied', piedSchema, 'pied')