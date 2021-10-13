const mongoose = require('mongoose')
const Schema = mongoose.Schema

var mesureSchema = Schema({
        pied1 : {
                type:Schema.Types.ObjectId,
                ref:"pied"
        },
        pied2 : {
                type:Schema.Types.ObjectId,
                ref:"pied"
        },
        date :  { "type": Date, "default": Date.now },
        emailUser : String
    
})

module.exports = mongoose.model('mesure', mesureSchema, 'mesure')