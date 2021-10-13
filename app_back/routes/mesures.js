var express = require('express');
var router = express.Router();
const mesureSchema = require('../modules/mesure_schema');

var resMsg = {
  message:String
}
var bodyParser = require("body-parser");
router.use(bodyParser.json({ limit: '50mb' }));
router.use(bodyParser.urlencoded({ limit: "50mb", parameterLimit: 5000000, extended: true }));


router.post('/addMesure', async (req, res) => {
  try {
    await new mesureSchema(req.body).save( function(err, result) {
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

router.post('/getDimension',async (req,res)=>{
  const request_data = req.body;
  var email = request_data.email;
  await mesureSchema.find({'emailUser': email}).sort([['date', 1]]).limit(1).populate('pied1')
  .populate('pied2').then(async (lastMesure) => {
    if (lastMesure.length!= 0) {
      console.log(lastMesure);
      res.status(200).json({ message: "donem" ,firstMesure:lastMesure[0]});

    } else {
      res.status(200).json({ message: "0found" });
    }
  });
})

router.post('/getAmelioration', async (req, res) => {
  const request_data = req.body;
  var email = request_data.email;
  await mesureSchema.find({'emailUser': email}).sort([['date', -1]]).limit(1).populate('pied1')
  .populate('pied2').then(async (lastMesure) => {
    if (lastMesure.length!= 0) {
      console.log(lastMesure);
      res.status(200).json({ message: "donem" ,lastMesure:lastMesure[0]});

    } else {
      res.status(101).json({ message: "0found" });
    }
  });
});

router.post('/getStatA', async (req, res) => {
  const request_data = req.body;
  var email = request_data.email;
  await mesureSchema.find({'emailUser': email}).sort([['date', -1]]).limit(7).populate('pied1')
  .populate('pied2').then(async (lastMesure) => {
    if (lastMesure.length!= 0) {
      console.log(lastMesure);
      res.status(200).json({ message: "donem" ,lastMesure:lastMesure});

    } else {
      res.status(101).json({ message: "0found" });
    }
  });

});

router.post('/getStatF', async (req, res) => {
  const request_data = req.body;
  var email = request_data.email;
  await mesureSchema.find({'emailUser': email}).sort([['date', 1]]).populate('pied1')
  .populate('pied2').then(async (lastMesure) => {
    if (lastMesure.length!= 0) {
      console.log(lastMesure);
      res.status(200).json({ message: "donem" ,lastMesure:lastMesure});

    } else {
      res.status(101).json({ message: "0found" });
    }
  });

});

module.exports = router;
