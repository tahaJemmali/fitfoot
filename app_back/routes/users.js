var express = require('express');
var router = express.Router();
const userSchema = require('../modules/user_schema');
var crypto = require('crypto');
var nodemailer = require('nodemailer');

var bodyParser = require("body-parser");
router.use(bodyParser.json({ limit: '50mb' }));
router.use(bodyParser.urlencoded({ limit: "50mb", parameterLimit: 5000000, extended: true }));

//const { spawn } = require('child_process');
'use strict';

const { networkInterfaces } = require('os');

const nets = networkInterfaces();
const results = {};
var url;
var exit=false;
var i=0;
for (const name of Object.keys(nets)) {
  if(!exit){
    for (const net of nets[name]) {
      // Skip over non-IPv4 and internal (i.e. 127.0.0.1) addresses
      if (net.family === 'IPv4' && !net.internal) {
         url=net.address;
          exit=true;
          break;

      }
  }
  }
  //url = "192.168.1.10";
}

console.log(url);

/* GET users listing. */
router.get('/', function (req, res, next) {
  res.send('users.js');
});


router.put('/resetPassword', async (req, res) => {
  try {
    const request_data = req.body;
    var email = request_data.email;
    var plaint_password = request_data.password;

    await userSchema.findOne({ 'email': email }).then(async (userdb) => {
      if (userdb != null) {

        var hash_data = saltHashPassword(plaint_password);
        var password = hash_data.passwordHash;
        var salt = hash_data.salt;

        userdb.password = password;
        userdb.salt = salt;

        await userSchema.findByIdAndUpdate({ _id: userdb.id }, userdb).then(async (result) => {
          res.status(200).json({ message: "Password has been reset" });
        });

      } else {
        res.status(200).json({ message: "An error has occured." });
      }
    });

  } catch (e) {
    console.log(e);
    return res.status(404).json({ msg: e });
  }
});

router.post('/getPasswordRecoveryCode', async (req, res) => {
  try {
    const request_data = req.body;
    const email = request_data.email;
    var code = gfg();

    await userSchema.findOne({ 'email': email }).then(async (userdb) => {
      if (userdb != null) {

        var mailOptions = {
          from: 'setOutLlife.assistance@gmail.com',
          to: email,
          subject: 'FitFoot! Validation de votre adresse Email',
          text: '',
          html: '<!DOCTYPE html>' +
            '<html><head><title>Validation de votre adresse Email</title>' +
            '</head><body><div>' +
            '<p>Cher(e) ' + userdb.firstName + ' ' + userdb.lastName +
            ', Il y a eu une demande de réinitialisation du mot de passe ou de déverrouillage du compte pour votre FitFoot ID (' + email + ').</p>' +
            '<p>Pour continuer ce processus, entrez le code ci-dessous sur la page de validation:</p>' +
            '<p>' + code + '</p>' +
            '</br>' +
            '</br>' +
            '<p>FitFoot - Support</p>' +
            '<img src="cid:image_fflogo" width="13%" alt="FitFoot Logo">' +
            '</div></body></html>',
          attachments: [{
            filename: 'fflogo.png',
            path: './public/images/fflogo.png',
            cid: 'image_fflogo'
          },]
        };

        transporter.sendMail(mailOptions, function (error, info) {
          if (error) {
            console.log(error);
          } else {
            console.log('Email sent: ' + info.response);
          }
        });

        res.status(200).json({ message: "Verification code", code: code, email: email });

      } else {
        res.status(200).json({ message: "Email does not exist" });
      }
    });

  } catch (e) {
    console.log(e);
    return res.status(404).json({ msg: e });
  }
});

router.post('/feet', async (req, res) => {
  try {
    const request_data = req.body;
    const email = request_data.email;
    const image = request_data.image;

    //const python = spawn('python',['--version']); 
    const spawn = require("child_process").spawn;
    //const python = spawn('python', [`${process.cwd()}\\routes\\feet_detection_script.py`]); // windows
    const python = spawn('python', [`${process.cwd()}/routes/feet_detection_script.py`]); //mac ou bien linux

    python.stdin.write(JSON.stringify(request_data));
    python.stdin.end();

    var buffers = [];

    python.stdout.on('data', (data) => {
      buffers.push(data);
      //console.log(`stdout: ${data}`);
      //pyRespData = data.toString();
      //pyJsonRespData = JSON.parse(pyRespData);
      //console.log('Tf2v:'+pyJsonRespData.Tf2v);
      //console.log('Detection:'+pyJsonRespData.Detection);
      //console.log('RednessPerc:'+pyJsonRespData.RednessPerc);
      //console.log('Image1:'+pyJsonRespData.Image1);
      //console.log('Image2:'+pyJsonRespData.Image2);
      //res.status(200).json({ message: "All Done", Detection: pyJsonRespData.Detection, RednessPerc: pyJsonRespData.RednessPerc, Image1: pyJsonRespData.Image1 });
    }).on('end', function () {
      pyJsonRespData = JSON.parse(Buffer.concat(buffers).toString());
      //pyRespData = data.toString();
      //pyJsonRespData = JSON.parse(buffers.toString());
      //console.log(buffers.toString());
      res.status(200).json({ message: "All Done", Detection: pyJsonRespData.Detection, RednessPerc: pyJsonRespData.RednessPerc, Image1: pyJsonRespData.Image1 });
    });

    python.stderr.on('data', (data) => {
      console.log(`stderr: ${data}`);
    });

    /*python.on('close', (code) => {
      console.log(`child process exited with code: ${code}`);
    });*/

  } catch (e) {
    console.log(e);
    return res.status(404).json({ msg: e });
  }
});

router.get('/getUsers', (req, res, next) => {
  try {
    var callMyPromise = async () => {
      return result = await (userSchema.find({}));
    };
    callMyPromise().then(function (result) {
      res.json(result);
    });
  } catch (e) {
    next(e);
  }
});

router.put('/updateUser', async (req, res) => {
  const request_data = req.body;
  const user = request_data;
  try {
    await userSchema.findOne({ 'email': user.email }).then(async (userdb) => {
      if (userdb != null) {
        //
        //userdb.email = user.email;
        userdb.emailDoctor = user.emailDoctor;
        userdb.firstName = user.firstName;
        userdb.lastName = user.lastName;
        userdb.address = user.address;
        userdb.phone = user.phone;
        userdb.phoneDoctor = user.phoneDoctor;
        //
        userdb.gender = user.gender.toString();
        userdb.birthDate = user.birthDate;
        if (user.height != -1) {
          userdb.height = user.height;
        }
        if (user.weight != -1) {
          userdb.weight = user.weight;
        }
        await userSchema.findByIdAndUpdate({ _id: userdb.id }, userdb).then(async (result) => {
        });
        res.status(200).json({ message: "user updated" });
      } else {
        res.status(200).json({ message: "Email does not exist" });
      }
    });
  } catch (e) {
    console.log(e);
    return res.status(404).json({ msg: e });
  }

});

router.put('/updateProfilePic', async (req, res) => {
  const request_data = req.body;
  const email = request_data.email;
  const photo = request_data.photo;
  var validEmail = false;

  try {
    await userSchema.find({}).then(async (result) => {
      if (result.length != 0) {
        result.forEach(async (user) => {
          if (user.email === email) {
            validEmail = true;
            if (user.emailVerification == true) {
              user.photo = photo;
              await userSchema.findByIdAndUpdate({ _id: user.id }, user).then(async (result) => {
                res.status(200).json({ message: "profile pic updated" });
              });
            } else {
              res.status(200).json({ message: "Adresse E-mail non activé" });
            }
          }
        }); if (!validEmail) {
          res.status(200).json({ message: "Email does not exist" });
        }
      } else {
        res.status(200).json({ message: "Email does not exist" });
      }
    });
  } catch (e) {
    console.log(e);
    return res.status(404).json({ msg: e });
  }

});

router.put('/login', async (req, res) => {
  const request_data = req.body;
  const email = request_data.email;
  const password = request_data.password;
  var pwd, slt, validEmail = false;

  try {
    await userSchema.find({}).then(async (result) => {
      if (result.length != 0) {
        result.forEach(async (user) => {
          if (user.email === email) {
            validEmail = true;
            pwd = user.password;
            slt = user.salt;
            if (user.emailVerification == true) {
              var hashed_password = checkHashPassword(password, slt).passwordHash;
              var encrypted_password = pwd;
              if (hashed_password == encrypted_password) {
                user.lastLoginDate = Date.now();
                await userSchema.findByIdAndUpdate({ _id: user.id }, user).then(async (result) => {
                  //res.status(200).send("Votre compte est activé !");
                });
                //console.log(user.gender);
                res.status(200).json({ message: "Login success", user: user });
              } else {
                res.status(200).json({ message: "Wrong password" });
              }
            } else {
              res.status(200).json({ message: "Email not activated" });
            }
          }
        }); if (!validEmail) {
          res.status(200).json({ message: "Email does not exist" });
        }
      } else {
        res.status(200).json({ message: "Email does not exist" });
      }
    });
  } catch (e) {
    console.log(e);
    return res.status(404).json({ msg: e });
  }

});

router.get('/emailActivation/:email', async (req, res) => {
  const email = req.params.email;
  var mailFound = false;
  try {
    await userSchema.find({}).then(async (result) => {
      if (result.length != 0) {
        result.forEach(async (user) => {
          if (user.email == email) {
            mailFound = true;
            if (user.emailVerification == false) {
              user.emailVerification = true;
              await userSchema.findByIdAndUpdate({ _id: user.id }, user).then(async (result) => {
                res.status(200).send("Votre compte est activé !");
              });
            } else {
              //account laready activated
              res.status(200).send("Adresse Email déja activé");
            }
          }
        });
        if (!mailFound) {
          // email does not exist
          res.status(404).send("404 Email Not Found");
        }
      } else {
        res.status(404).send("404 Not Found");
      }
    });
  } catch (e) {
    console.log(e);
    res.status(404).json({ msg: e });
  }

});

router.post('/register', async (req, res) => {
  const request_data = req.body;

  //console.log(request_data);

  var hash_data = saltHashPassword(request_data.password);
  var password = hash_data.passwordHash; // Save password hash
  var salt = hash_data.salt; //save salt

  const newUser = new userSchema({
    firstName: request_data.firstName,
    lastName: request_data.lastName,
    email: request_data.email,
    password: password,
    salt: salt
  });

  try {
    await userSchema.find({}).then(async (result) => {
      var allowInsert = true;
      if (result.length != 0) {
        result.forEach(async (user) => {
          console.log(request_data.email.toLowerCase());
          console.log(user.email.toLowerCase());
          if (user.email.toLowerCase() == request_data.email.toLowerCase()) {
            allowInsert = false;
            console.log('Email already exists');
            res.status(200).json({ message: "Email already exists" });
          }
        });
      } if (allowInsert) {
        //  await new userSchema(newUser).save();
        await newUser.save().then(async (result) => {
          var mailOptions = {
            from: 'FitFoot.assistance@gmail.com',
            to: request_data.email,
            subject: 'FitFoot! Validation de votre adresse Email',
            text: '',
            html: '<!DOCTYPE html>' +
              '<html><head><title>Validation de votre adresse Email</title>' +
              '</head><body><div>' +
              '<p>Votre nouveau compte FitFoot doit être activé avant de pouvoir être utilisé:<br/>' +
              'Votre Nom:       ' + request_data.lastName + '<br/>' +
              'Votre Prenom:       ' + request_data.firstName + '<br/>' +
              'Votre Adress Email:       ' + request_data.email.toLowerCase() + '<br/>' +
              '</p>' +
              '<p>Cliquez <a href="http://'+url+':54001/user/emailActivation/' + request_data.email.toLowerCase() + '">ici</a> pour activer votre nouveau compte:</p>' +
              '</br>' +
              '</br>' +
              '</br>' +
              '<p>Vous recevez ce message car cette adresse e-mail<br/>' +
              '(' + request_data.email + ') a été utilisé pour créer un nouveau compte FitFoot.<br/>' +
              'Si vous ne vous êtes pas inscrit à ce compte, vous pouvez ignorer ce message<br/>' +
              'et le compte expirera de lui-même.<br/>' +
              '</p>' +
              '</br>' +
              '</br>' +
              '</br>' +
              '<p>FitFoot - Support</p>' +
              '<img src="cid:image_fflogo" width="13%" alt="FitFoot Logo">' +
              '</div></body></html>',
            attachments: [{
              filename: 'fflogo.png',
              path: './public/images/fflogo.png',
              cid: 'image_fflogo'
            },]
          };

          transporter.sendMail(mailOptions, function (error, info) {
            if (error) {
              console.log(error);
            } else {
              console.log('Email sent: ' + info.response);
            }
          });
        });
        console.log('Registration success');
        res.status(200).json({ message: "Registration success" });
      }
    });
  } catch (e) {
    console.log(e);
    res.status(404).json({ msg: e });
  }

});


var genRandomString = function (length) {
  return crypto.randomBytes(Math.ceil(length / 2)).toString('hex').slice(0, length);
};

var sha512 = function (password, salt) {
  var hash = crypto.createHmac('sha512', salt);
  hash.update(password);
  var value = hash.digest('hex');
  return {
    salt: salt,
    passwordHash: value
  };
};

function saltHashPassword(userPassword) {
  var salt = genRandomString(16); // create 16 random character
  var passwordData = sha512(userPassword, salt);
  return passwordData;
}

function checkHashPassword(userPassword, salt) {
  var passwordData = sha512(userPassword, salt);
  return passwordData;
}

function gfg() {
  var minm = 100000;
  var maxm = 999999;
  return Math.floor(Math.random() * (maxm - minm + 1)) + minm;
}

var transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: 'FitFoot.assistance@gmail.com',
    pass: 'swq!4uJhtEz!4uJhtEz5.i'
  }
});

module.exports = router;
