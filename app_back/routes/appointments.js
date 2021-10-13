var express = require('express');
var router = express.Router();
const appointmentSchema = require('../modules/appointment_schema');

var bodyParser = require("body-parser");
router.use(bodyParser.json({ limit: '50mb' }));
router.use(bodyParser.urlencoded({ limit: "50mb", parameterLimit: 5000000, extended: true }));

router.get('/', function (req, res, next) {
  res.send('appointments.js');
});

router.get('/getappointments/:userid', (req, res, next) => {
  try {
    var callMyPromise = async () => {
      return result = await (appointmentSchema.find({'userid': req.params.userid}));
    };
    callMyPromise().then(function (result) {
      res.json(result);
    });
  } catch (e) {
    next(e);
  }
});

router.put('/updateappointment/:id', async (req, res) => {
  const request_data = req.body;
  const appointment = request_data;
  try {
    await appointmentSchema.findOne({ '_id': req.params.id }).then(async (appointmentdb) => {
      if (appointmentdb != null) {
        appointmentdb.checked = !appointmentdb.checked;
        await appointmentSchema.findByIdAndUpdate({ _id: appointmentdb.id }, appointmentdb).then(async (result) => {
        });
        res.status(200).json({ message: "appointment updated" });
      }
    });
  } catch (e) {
    console.log(e);
    return res.status(404).json({ msg: e });
  }

});

router.post('/addappointment/:doctorname/:doctorphone/:date/:specialty/:userid', async (req, res) => {
  const request_data = req.body;

  var datetime = new Date();
  const newappointment = new appointmentSchema({
    doctorphone: req.params.doctorphone,
    doctorname: req.params.doctorname,
    date: req.params.date,
    specialty: req.params.specialty,
    userid: req.params.userid,
  });

  try {
    await newappointment.save().then(async (result) => {
    });
    res.status(200).json({ message: "Registration success" });
  } catch (e) {
    console.log(e);
    res.status(404).json({ msg: e });
  }
});

router.get('/deleteappointment/:id', async (req, res, next) => {
  try {
    $: appointment = await appointmentSchema.findByIdAndDelete({ _id: req.params.id });
    if (appointment)
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

router.get('/upcommingappointments/:userid', (req, res, next) => {
  try {
    var now = new Date();
    var year1=now.getFullYear();
    var month1= now.getMonth();
    var day1= now.getDate();
var beg = new Date(year1, month1, day1);

var end = new Date(year1, month1, day1+1);

    var callMyPromise = async () => {
      return result = await (appointmentSchema.find({"date":{$gte:now}, "userid": req.params.userid}));

    };
    callMyPromise().then(function (result) {
      res.json(result);
    });
  } catch (e) {
    next(e);
  }
});

router.get('/dayappointments/:date/:userid', (req, res, next) => {
  try {
    var callMyPromise = async () => {
      var date2 =new Date(req.params.date);
      var date3 = new Date(date2.getFullYear(), date2.getMonth(), date2.getDate()+1);
      return result = await (appointmentSchema.find({"userid" : req.params.userid ,"date":{$gte:new Date(req.params.date),$lte:new Date(date3)}}));

    };
    callMyPromise().then(function (result) {
      res.json(result);
    });
  } catch (e) {
    next(e);
  }
});

module.exports = router;
