var express = require('express');
var router = express.Router();
const expenditureSchema = require('../modules/expenditure_schema');
var moment = require('moment'); // require
moment().format();

var bodyParser = require("body-parser");
router.use(bodyParser.json({ limit: '50mb' }));
router.use(bodyParser.urlencoded({ limit: "50mb", parameterLimit: 5000000, extended: true }));

router.get('/', function (req, res, next) {
  res.send('expenditures.js');
});

router.get('/getexpenditures/:userid', (req, res, next) => {
  try {
    var callMyPromise = async () => {
      return result = await (expenditureSchema.find({"userid": req.params.userid}));
    };
    callMyPromise().then(function (result) {
      res.json(result);
    });
  } catch (e) {
    next(e);
  }
});

//missing id
router.get('/countcheckedexpenditures/:userid', (req, res, next) => {
  try {
    var callMyPromise = async () => {
      return result = await (expenditureSchema.find({"checked": true, "userid": req.params.userid}).count());
    };
    callMyPromise().then(function (result) {
      res.json(result);
    });
  } catch (e) {
    next(e);
  }
});
//missing id
router.get('/countexpenditures/userid', (req, res, next) => {
  try {
    var callMyPromise = async () => {
      return result = await (expenditureSchema.find({"userid":req.params.userid}).count());
    };
    callMyPromise().then(function (result) {
      res.json(result);
    });
  } catch (e) {
    next(e);
  }
});

//missing id
router.post('/addexpenditure/:activityid/:activityname/:duration/:met/:weight/:userid', async (req, res) => {
  const request_data = req.body;
var cals = (req.params.met*req.params.weight*req.params.duration*3.5)/200;
  var datetime = new Date();
  var date = new Date(datetime.getFullYear(), datetime.getMonth(), datetime.getDate()+1);
  const newexpenditure = new expenditureSchema({
    activityid: req.params.activityid,
    activityname: req.params.activityname,
    duration: req.params.duration,
    userid: req.params.userid,
    caloriesburned :cals,
    date: date,
  });

  try {
    await newexpenditure.save().then(async (result) => {
    });
    res.status(200).json({ message: "Registration success" });
  } catch (e) {
    console.log(e);
    res.status(404).json({ msg: e });
  }
});

router.get('/deleteexpenditure/:id', async (req, res, next) => {
  try {
    $: expenditure = await expenditureSchema.findByIdAndDelete({ _id: req.params.id });
    if (expenditure)
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
router.get('/todayexpenditures/:userid', (req, res, next) => {
  try {
    var now = new Date();
    var year1=now.getFullYear();
    var month1= now.getMonth();
    var day1= now.getDate();
var beg = new Date(year1, month1, day1);

var end = new Date(year1, month1, day1+1);

    var callMyPromise = async () => {
      return result = await (expenditureSchema.find({"userid": req.params.userid,"date":{$gte:new Date(beg),$lte:new Date(end)}}));

    };
    callMyPromise().then(function (result) {
      res.json(result);
    });
  } catch (e) {
    next(e);
  }
});

//missing id
router.get('/dayexpenditures/:date/:userid', (req, res, next) => {
  try {
    var callMyPromise = async () => {
      var date2 =new Date(req.params.date);
      var date3 = new Date(date2.getFullYear(), date2.getMonth(), date2.getDate()+1);
      return result = await (expenditureSchema.find({"userid":req.params.userid,"date":{$gte:new Date(req.params.date),$lte:new Date(date3)}}));

    };
    callMyPromise().then(function (result) {
      res.json(result);
    });
  } catch (e) {
    next(e);
  }
});

//missing id
//npm install moment
router.get('/lastexpenditures/:userid', (req, res, next) => {
  try {
    var callMyPromise = async () => {
      var date = moment().subtract(14, 'days');
      return result = await (expenditureSchema.find({"userid": req.params.userid, "date":{$gte:new Date(date)}}));

    };
    callMyPromise().then(function (result) {
      res.json(result);
    });
  } catch (e) {
    next(e);
  }
});


//missing id
router.get('/activedays/:userid', (req, res, next) => {
  try {
    var callMyPromise = async () => {
      var date = moment().subtract(14, 'days');
      return result = await (expenditureSchema.find({"userid": req.params.userid,"date":{$gte:new Date(date)}}).distinct("date").count());

    };
    callMyPromise().then(function (result) {
      res.json(result);
    });
  } catch (e) {
    next(e);
  }
});


router.get('/calorieslastexpenditures/:userid', (req, res, next) => {
  try {
    var callMyPromise = async () => {
      var date = moment().subtract(14, 'days');
      return result = await (expenditureSchema.aggregate([{ $match: {
        $and: [
            { userid : req.params.userid, date: { $gte: new Date(date) } },
        ]
    } },
    { $group: { _id : null, sum : { $sum: "$caloriesburned" } } }]));
      
      
      
    };
    callMyPromise().then(function (result) {
      res.json(result);
    });
  } catch (e) {
    next(e);
  }
});

router.get('/calorieslastexpenditures2', (req, res, next) => {
  try {
    var callMyPromise = async () => {
      var date = moment().subtract(14, 'days');
      return result = await (expenditureSchema.aggregate([{ $match: {
        $and: [
            { date: { $gte: new Date(date) } },
        ]
    } },
    { $group: { _id : null, sum : { $sum: "$caloriesburned" } } }]));
      
      
      
    };
    callMyPromise().then(function (result) {
      res.json(result);
    });
  } catch (e) {
    next(e);
  }
});

module.exports = router;
