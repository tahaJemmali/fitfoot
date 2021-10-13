var express = require('express');
var router = express.Router();
const piedSchema = require('../modules/pied_schema');
var resMsg = {
  message:String
}

var bodyParser = require("body-parser");
router.use(bodyParser.json({ limit: '50mb' }));
router.use(bodyParser.urlencoded({ limit: "50mb", parameterLimit: 5000000, extended: true }));

router.post('/addPied', async (req, res) => {
    try {
      await new piedSchema(req.body).save( function(err, result) {
        if(err) {
          resMsg.message=err
      } else {
          resMsg.message=result._id
      }
      console.log(resMsg.message)
      res.status(201).json(resMsg)
    });
} catch (error) {
  console.log(error.message)
  resMsg.message=error.message
  res.status(404).json(resMsg)
}
});

  module.exports = router;