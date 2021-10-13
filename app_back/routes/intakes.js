var express = require('express');
var router = express.Router();
const intakeSchema = require('../modules/intake_schema');
var moment = require('moment'); // require
moment().format();

var bodyParser = require("body-parser");
router.use(bodyParser.json({ limit: '50mb' }));
router.use(bodyParser.urlencoded({ limit: "50mb", parameterLimit: 5000000, extended: true }));

router.get('/', function (req, res, next) {
  res.send('intakes.js');
});

//missing id
router.get('/getintakes/:userid', (req, res, next) => {
  try {
    var callMyPromise = async () => {
      return result = await (intakeSchema.find({"userid":req.params.userid}));
    };
    callMyPromise().then(function (result) {
      res.json(result);
    });
  } catch (e) {
    next(e);
  }
});

router.put('/updateintake/:id', async (req, res) => {
  const request_data = req.body;
  const intake = request_data;
  try {
    await intakeSchema.findOne({ '_id': req.params.id }).then(async (intakedb) => {
      if (intakedb != null) {
        intakedb.checked = !intakedb.checked;
        await intakeSchema.findByIdAndUpdate({ _id: intakedb.id }, intakedb).then(async (result) => {
        });
        res.status(200).json({ message: "intake updated" });
      }
    });
  } catch (e) {
    console.log(e);
    return res.status(404).json({ msg: e });
  }

});

//missing id
router.post('/addintake/:medid/:medname/:userid', async (req, res) => {
  const request_data = req.body;

  var datetime = new Date();
  const newintake = new intakeSchema({
    medid: req.params.medid,
    medname: req.params.medname,
    date: datetime,
    userid : req.params.userid,
  });

  try {
    await newintake.save().then(async (result) => {
    });
    res.status(200).json({ message: "Registration success" });
  } catch (e) {
    console.log(e);
    res.status(404).json({ msg: e });
  }
});

router.get('/deleteintake/:id', async (req, res, next) => {
  try {
    //const contact = new contactSchema
    $: intake = await intakeSchema.findByIdAndDelete({ _id: req.params.id });
    if (intake)
    {
      return res.status(201).json({
        result: true,
        message: "done",
      });
    } else {
      return res.status(400).json({
        result: false,
        message: "not done",
      });
    }
  } catch (error) {
    next(error);
  }
});

//missing id
router.get('/todayintakes/:userid', (req, res, next) => {
  try {
    var now = new Date();
    var year1=now.getFullYear();
    var month1= now.getMonth();
    var day1= now.getDate();
var beg = new Date(year1, month1, day1);

var end = new Date(year1, month1, day1+1);

    var callMyPromise = async () => {
      return result = await (intakeSchema.find({"userid":req.params.userid,"date":{$gte:new Date(beg),$lte:new Date(end)}}));

    };
    callMyPromise().then(function (result) {
      res.json(result);
    });
  } catch (e) {
    next(e);
  }
});

//missing id
router.get('/dayintakes/:date/:userid', (req, res, next) => {
  try {
    var callMyPromise = async () => {
      var date2 =new Date(req.params.date);
      var date3 = new Date(date2.getFullYear(), date2.getMonth(), date2.getDate()+1);
      return result = await (intakeSchema.find({"userid":req.params.userid,"date":{$gte:new Date(req.params.date),$lte:new Date(date3)}}));

    };
    callMyPromise().then(function (result) {
      res.json(result);
    });
  } catch (e) {
    next(e);
  }
});

//missing id
router.get('/countintakes/:userid', (req, res, next) => {
  var date = moment().subtract(14, 'days');
  try {
    var callMyPromise = async () => {
      return result = await (intakeSchema.find({"userid":req.params.userid,"date":{$gte:new Date(date)}}).count());
    };
    callMyPromise().then(function (result) {
      res.json(result);
    });
  } catch (e) {
    next(e);
  }
});

//missing id
router.get('/countcheckedintakes/:userid', (req, res, next) => {
  var date = moment().subtract(14, 'days');
  try {
    var callMyPromise = async () => {
      return result = await (intakeSchema.find({"userid":req.params.userid,"checked": true, "date":{$gte:new Date(date)}}).count());

    };
    callMyPromise().then(function (result) {
      res.json(result);
    });
  } catch (e) {
    next(e);
  }
});

//missing id
router.get('/lastintakes/:userid', (req, res, next) => {
  var date = moment().subtract(14, 'days');
  try {
    var callMyPromise = async () => {
      return result = await (intakeSchema.find({ "userid":req.params.userid, "date":{$gte:new Date(date)}}));

    };
    callMyPromise().then(function (result) {
      res.json(result);
    });
  } catch (e) {
    next(e);
  }
});

module.exports = router;
