const mongoose =require('mongoose')
const Schema = mongoose.Schema

var medSchema = Schema({
    name : {
        type:String,
        required:true,
    },
    type : {
        type:String,
        required:true,
    },
    nb : {
        type:Number,
        required:true,
        default:1,
    },
    creatorid : {
        type:String,
        required:true,
        default:'admin',
    },
    /*routines : [{
        type:Schema.Types.ObjectId,
        ref:"routine",
    }],*/

})

module.exports = mongoose.model('meds',medSchema ,'med')