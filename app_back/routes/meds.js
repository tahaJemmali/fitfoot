var express = require('express');
var router = express.Router();
const medSchema = require('../modules/med_schema');

var bodyParser = require("body-parser");
router.use(bodyParser.json({ limit: '50mb' }));
router.use(bodyParser.urlencoded({ limit: "50mb", parameterLimit: 5000000, extended: true }));

router.get('/', function (req, res, next) {
  res.send('meds.js');
});

router.get('/getmeds', (req, res, next) => {
  try {
    var callMyPromise = async () => {
      return result = await (medSchema.find({}));
    };
    callMyPromise().then(function (result) {
      res.json(result);
    });
  } catch (e) {
    next(e);
  }
});

router.get('/getcustommeds/:id', (req, res, next) => {
  //var admin = admin;
  try {
    var callMyPromise = async () => {
      return result = await (medSchema.find({creatorid: req.params.id }));
    };
    callMyPromise().then(function (result) {
      res.json(result);
    });
  } catch (e) {
    next(e);
  }
});

router.get('/getmed/:medid', (req, res, next) => {
  try {
    var callMyPromise = async () => {
      return result = await (medSchema.findOne({_id : req.params.medid}));
    };
    callMyPromise().then(function (result) {
      res.json(result);
    });
  } catch (e) {
    next(e);
  }
});

router.put('/updatemed', async (req, res) => {
  const request_data = req.body;
  const med = request_data;
  try {
    await medschema.findOne({ 'phone': med.phone }).then(async (meddb) => {
      if (meddb != null) {
        meddb.birthDate = med.birthDate;
        await medschema.findByIdAndUpdate({ _id: meddb.id }, meddb).then(async (result) => {
        });
        res.status(200).json({ message: "med updated" });
      }
    });
  } catch (e) {
    console.log(e);
    return res.status(404).json({ msg: e });
  }

});

router.post('/addmed/:name/:type', async (req, res) => {
  const request_data = req.body;
  console.log(req.params.phone+" here");
  const newmed = new medSchema({
    name: req.params.name,
    type: req.params.type,
    //phone: req.params.phone,
  });

  try {
    await newmed.save().then(async (result) => {
    });
    res.status(200).json({ message: "Registration success" });

  } catch (e) {
    console.log(e);
    res.status(404).json({ msg: e });
  }
});

router.post('/custommed/:name/:type/:id', async (req, res) => {
  const request_data = req.body;
  console.log(req.params.phone+" here");
  const newmed = new medSchema({
    name: req.params.name,
    type: req.params.type,
    creatorid: req.params.id,
  });

  try {
    await newmed.save().then(async (result) => {
    });
    res.status(200).json({ message: "Registration success" });

  } catch (e) {
    console.log(e);
    res.status(404).json({ msg: e });
  }
});

router.post('/custommednb/:name/:type/:id/:nb', async (req, res) => {
  const request_data = req.body;
  console.log(req.params.phone+" here");
  const newmed = new medSchema({
    name: req.params.name,
    type: req.params.type,
    creatorid: req.params.id,
    nb: req.params.nb,
  });

  try {
    await newmed.save().then(async (result) => {
    });
    res.status(200).json({ message: "Registration success" });

  } catch (e) {
    console.log(e);
    res.status(404).json({ msg: e });
  }
});

router.get('/deletemed/:id', async (req, res, next) => {
  try {
    //const contact = new contactSchema
    $: med = await medSchema.findByIdAndDelete({ _id: req.params.id });
    if (med)
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
