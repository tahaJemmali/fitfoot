var express = require('express');
var router = express.Router();
const userSchema = require('../modules/user_schema');
var crypto = require('crypto');
var nodemailer = require('nodemailer');

/* GET users listing. */
router.get('/', function (req, res, next) {
  res.send('users.js');
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
  var mailFound=false;
  try {
    await userSchema.find({}).then(async (result) => {
      if (result.length != 0) {
        result.forEach(async (user) => {
          if (user.email == email) {
            mailFound=true;
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
        if (!mailFound){
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
            text: 'That was easy!',
            html: '<!DOCTYPE html>' +
              '<html><head><title>Validation de votre adresse Email</title>' +
              '</head><body><div>' +
              '<p>Votre nouveau compte FitFoot doit être activé avant de pouvoir être utilisé:<br/>' +
              'Votre Nom:       ' + request_data.lastName + '<br/>' +
              'Votre Prenom:       ' + request_data.firstName + '<br/>' +
              'Votre Adress Email:       ' + request_data.email.toLowerCase() + '<br/>' +
              '</p>' +
              '<p>Cliquez <a href="http://localhost:34000/user/emailActivation/' + request_data.email.toLowerCase() + '">ici</a> pour activer votre nouveau compte:</p>' +
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
              '<img src="fflogo.png" alt="FitFoot Logo">'+
              '</div></body></html>'
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

