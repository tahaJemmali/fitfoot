const mongoose = require('mongoose')
const Schema = mongoose.Schema

var mesurementSchema = Schema({
    user : {
        type:Schema.Types.ObjectId,
        ref:"user"
    },
    image : String,
    rednessPercentage : String,
    mesurementDate : { "type": Date, "default": Date.now },
    cote:String,
})

module.exports = mongoose.model('mesurement', mesurementSchema, 'mesurement')