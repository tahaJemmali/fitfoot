var express = require('express');
var router = express.Router();
const consoSchema = require('../modules/conso_schema');

var bodyParser = require("body-parser");
router.use(bodyParser.json({ limit: '50mb' }));
router.use(bodyParser.urlencoded({ limit: "50mb", parameterLimit: 5000000, extended: true }));

router.get('/', function (req, res, next) {
  res.send('consos.js');
});

router.get('/getconsos', (req, res, next) => {
  try {
    var callMyPromise = async () => {
        var userid =1; // temp .. wil change to the real user Id
      return result = await (consoSchema.find({userid : userid}));
    };
    callMyPromise().then(function (result) {
      res.json(result);
    });
  } catch (e) {
    next(e);
  }
});

router.put('/updateconso', async (req, res) => {
  const request_data = req.body;
  const conso = request_data;
  try {
    await consoschema.findOne({ 'phone': conso.phone }).then(async (consodb) => {
      if (consodb != null) {
        consodb.birthDate = conso.birthDate;
        await consoschema.findByIdAndUpdate({ _id: consodb.id }, consodb).then(async (result) => {
        });
        res.status(200).json({ message: "conso updated" });
      }
    });
  } catch (e) {
    console.log(e);
    return res.status(404).json({ msg: e });
  }

});

router.post('/addconso/:medid/:medname', async (req, res) => {
  const request_data = req.body;
  //console.log(req.params.phone+" here");
  var datetime = new Date();
  const newconso = new consoSchema({
    medid: req.params.medid,
    medname: req.params.medname,
    //userid: req.params.firstName,
    date: datetime,
  });

  try {
    await newconso.save().then(async (result) => {
    });
    res.status(200).json({ message: "Registration success" });
  } catch (e) {
    console.log(e);
    res.status(404).json({ msg: e });
  }
});

router.get('/deleteconso/:id', async (req, res, next) => {
  try {
    //const contact = new contactSchema
    $: conso = await consoSchema.findByIdAndDelete({ _id: req.params.id });
    if (conso)
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
