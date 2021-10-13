var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');

//hné
var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');
var mesureRouter = require('./routes/mesures');
var piedRouter = require('./routes/pied');
var contactsRouter = require('./routes/contacts');
var medsRouter = require('./routes/meds');
var intakesRouter = require('./routes/intakes');
var routinesRouter = require('./routes/routines');
var consosRouter = require('./routes/consos');
var activitiesRouter = require('./routes/activities');
var expendituresRouter = require('./routes/expenditures');
var appointmentsRouter = require('./routes/appointments');
//

const mongooseurl = require('./config/databaseUrl.json').DataBaseUrl;
const localDataBaseUrl = require('./config/databaseUrl.json').LocalDataBase;

var app = express();
const mongoose = require('mongoose');
mongoose.set('useNewUrlParser', true);
mongoose.set('useFindAndModify', false);
mongoose.set('useUnifiedTopology',true);
mongoose.set('useCreateIndex', true);

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

app.use(logger('dev'));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', indexRouter);
app.use('/user', usersRouter);
app.use('/mesure',mesureRouter);
app.use('/pied',piedRouter);
app.use('/contacts', contactsRouter);
app.use('/meds', medsRouter);
app.use('/intakes', intakesRouter);
app.use('/routines', routinesRouter);
app.use('/consos', consosRouter);
app.use('/activities', activitiesRouter);
app.use('/expenditures', expendituresRouter);
app.use('/appointments', appointmentsRouter);
app.use(express.json({limit: '50mb'}));
app.use(express.urlencoded({limit: "50mb",extended:true, parameterLimit:50000}));



// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});


//Connection to mongoDB
mongoose.connect(localDataBaseUrl)
.then((data) => console.log("database connected"))
.catch((err) => console.log(err))


module.exports = app;
