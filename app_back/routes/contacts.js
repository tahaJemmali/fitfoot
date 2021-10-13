var express = require('express');
var router = express.Router();
const contactSchema = require('../modules/contact_schema');

var bodyParser = require("body-parser");
router.use(bodyParser.json({ limit: '50mb' }));
router.use(bodyParser.urlencoded({ limit: "50mb", parameterLimit: 5000000, extended: true }));

router.get('/', function (req, res, next) {
  res.send('contacts.js');
});


router.get('/getcontacts/:userid', (req, res, next) => {
  try {
    var callMyPromise = async () => {
      return result = await (contactSchema.find({"userid":req.params.userid}));
    };
    callMyPromise().then(function (result) {
      res.json(result);
    });
  } catch (e) {
    next(e);
  }
});

router.get('/getdoctors/:userid', (req, res, next) => {
  try {
    var contacttype='doctor';
    var callMyPromise = async () => {
      return result = await (contactSchema.find({ "contacttype" : contacttype, "userid": req.params.userid }));
    };
    callMyPromise().then(function (result) {
      res.json(result);
    });
  } catch (e) {
    next(e);
  }
});

router.put('/updateContact', async (req, res) => {
  const request_data = req.body;
  const contact = request_data;
  try {
    await contactschema.findOne({ 'phone': contact.phone }).then(async (contactdb) => {
      if (contactdb != null) {
        contactdb.birthDate = contact.birthDate;
        await contactschema.findByIdAndUpdate({ _id: contactdb.id }, contactdb).then(async (result) => {
        });
        res.status(200).json({ message: "contact updated" });
      }
    });
  } catch (e) {
    console.log(e);
    return res.status(404).json({ msg: e });
  }

});

router.post('/addcontact/:firstName/:phone/:contactype/:userid', async (req, res) => {
  const request_data = req.body;
  console.log(req.params.phone+" here");
  const newContact = new contactSchema({
    firstName: req.params.firstName,
    userid: req.params.userid,
    phone: req.params.phone,
    contacttype:req.params.contacttype
  });

  try {
    await newContact.save().then(async (result) => {
    });
    res.status(200).json({ message: "Registration success" });

  } catch (e) {
    console.log(e);
    res.status(404).json({ msg: e });
  }
});

router.post('/adddoc/:firstName/:phone/:type/:specialty/:userid', async (req, res) => {
  const request_data = req.body;
  console.log(req.params.phone+" here");
  const newContact = new contactSchema({
    firstName: req.params.firstName,
    phone: req.params.phone,
    contacttype: req.params.type,
    specialty: req.params.specialty,
    userid: req.params.userid,
  });

  try {
    await newContact.save().then(async (result) => {
    });
    res.status(200).json({ message: "Registration success" });
  } catch (e) {
    console.log(e);
    res.status(404).json({ msg: e });
  }
});

router.get('/deletecontact/:id', async (req, res, next) => {
  try {
    //const contact = new contactSchema
    $: contact = await contactSchema.findByIdAndDelete({ _id: req.params.id });
    if (contact)
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
