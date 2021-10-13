var express = require('express');
var router = express.Router();
const routineSchema = require('../modules/routine_schema');

var bodyParser = require("body-parser");
router.use(bodyParser.json({ limit: '50mb' }));
router.use(bodyParser.urlencoded({ limit: "50mb", parameterLimit: 5000000, extended: true }));

router.get('/', function (req, res, next) {
  res.send('routines.js');
});

//missing id
router.get('/getroutines/:userid', (req, res, next) => {
  try {
    var callMyPromise = async () => {
      return result = await (routineSchema.find({userid : req.params.userid}));
    };
    callMyPromise().then(function (result) {
      res.json(result);
    });
  } catch (e) {
    next(e);
  }
});

router.put('/updateroutine', async (req, res) => {
  const request_data = req.body;
  const routine = request_data;
  try {
    await routineschema.findOne({ 'phone': routine.phone }).then(async (routinedb) => {
      if (routinedb != null) {
        routinedb.birthDate = routine.birthDate;
        await routineschema.findByIdAndUpdate({ _id: routinedb.id }, routinedb).then(async (result) => {
        });
        res.status(200).json({ message: "routine updated" });
      }
    });
  } catch (e) {
    console.log(e);
    return res.status(404).json({ msg: e });
  }

});

//missing id
router.post('/addroutine/:medid/:medname/:userid', async (req, res) => {
  const request_data = req.body;
  var datetime = new Date();
  const newroutine = new routineSchema({
    medid: req.params.medid,
    medname: req.params.medname,
    userid: req.params.userid,
    date: datetime,
  });

  try {
    await newroutine.save().then(async (result) => {
    });
    res.status(200).json({ message: "Registration success" });
  } catch (e) {
    console.log(e);
    res.status(404).json({ msg: e });
  }
});

router.get('/deleteroutine/:id', async (req, res, next) => {
  try {
    $: routine = await routineSchema.findByIdAndDelete({ _id: req.params.id });
    if (routine)
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

module.exports = router;
