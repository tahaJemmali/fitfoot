var express = require('express');
var router = express.Router();
const activitySchema = require('../modules/activity_schema');

var bodyParser = require("body-parser");
router.use(bodyParser.json({ limit: '50mb' }));
router.use(bodyParser.urlencoded({ limit: "50mb", parameterLimit: 5000000, extended: true }));

router.get('/', function (req, res, next) {
  res.send('activities.js');
});

router.get('/getactivities', (req, res, next) => {
  try {
    var callMyPromise = async () => {
      return result = await (activitySchema.find({}));
    };
    callMyPromise().then(function (result) {
      res.json(result);
    });
  } catch (e) {
    next(e);
  }
});

router.get('/getactivity/:activityid', (req, res, next) => {
  try {
    var callMyPromise = async () => {
      return result = await (activitySchema.findOne({_id : req.params.activityid}));
    };
    callMyPromise().then(function (result) {
      res.json(result);
    });
  } catch (e) {
    next(e);
  }
});


router.post('/addactivity/:name/:met', async (req, res) => {
  const request_data = req.body;
  const newact = new activitySchema({
    name: req.params.name,
    met: req.params.met,
    //phone: req.params.phone,
  });

  try {
    await newact.save().then(async (result) => {
    });
    res.status(200).json({ message: "activity added" });

  } catch (e) {
    console.log(e);
    res.status(404).json({ msg: e });
  }
});

module.exports = router;
