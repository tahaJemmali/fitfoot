import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/Login/utils/constants.dart';
import 'package:workspace/deviceModule/Activites/secoundLegActivity.dart';
import 'package:workspace/deviceModule/classes/cote.dart';
import 'package:workspace/deviceModule/classes/pied.dart';
import 'package:workspace/deviceModule/widgets/Dialog.dart';

class PiedSuivantActivity extends StatefulWidget {
  PiedSuivantActivity(this.pied);
  final Pied pied;
  @override
  _PiedSuivantActivityState createState() => _PiedSuivantActivityState(pied);
}

class _PiedSuivantActivityState extends State<PiedSuivantActivity> {
  _PiedSuivantActivityState(this.leg);
  final Pied leg;
  BluetoothConnection connection;
  String result = "";
  bool connectionStatus = false;
  String autreCote;
  String cote;
  PickedFile _imageFile;
  Image _image1;
  File imageFile;
  String networkUrl;
  String _redness = "";
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    
   

    WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(getTranslated(context, 'mmpied') + autreCote),
              content: Text(getTranslated(context, "mettreApp")),
              actions: <Widget>[
                new FlatButton(
                  child: new Text(getTranslated(context, "daccord")),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        ));
        super.initState();
  }

  Future<void> connect() async {
    print("########################################" + Home.device.address);
    await BluetoothConnection.toAddress(Home.device.address)
        .then((_connection) {
      print('Connected to the device');
      setState(() {
        connection = _connection;
        connectionStatus = true;
      });
    });
  }

  void disconnect() {
    //print('Disconnected');
    // connection.finish();
    connection.close();
    //connection.dispose();
    setState(() {
      this.connectionStatus = false;
    });
  }

  @override
  void dispose() {
    this.connectionStatus = false;
    if (connection != null) {
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  @override
  Widget build(BuildContext context) {

     cote = leg.cote != Cote.gauche
        ? getTranslated(context, "droit")
        : getTranslated(context, "gauche");

    autreCote = leg.cote == Cote.gauche
        ? getTranslated(context, "droit")
        : getTranslated(context, "gauche");
        
    return WillPopScope(
      onWillPop: () {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(getTranslated(context, 'vulez')),
              content: Text(getTranslated(context, "toutledon")),
              actions: <Widget>[
                new FlatButton(
                  child: new Text(getTranslated(context, "wi")),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => Home()));
                  },
                ),
                new FlatButton(
                  child: new Text(getTranslated(context, "nn")),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            getTranslated(context, "prepA") + Home.device.name,
            style: TextStyle(fontSize: 15),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    getTranslated(context, "vmetrre") +
                        autreCote +
                        getTranslated(context, "assurer") +
                        cote,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: _image1 == null
                          ? SizedBox.shrink()
                          : Text(
                              _redness,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                    ),
                    Container(
                      child: _image1 == null ? SizedBox.shrink() : _image1,
                    ),
                    _image1 == null
                        ? RaisedButton(
                            onPressed: () {
                              showModalBottomSheet<dynamic>(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: ((builder) => bottomSheet(context)));
                            },
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0))),
                            child: Text(getTranslated(context, "pImage") + cote,
                                style: TextStyle(color: Colors.white)),
                          )
                        : RaisedButton(
                            onPressed: () async {
                              Dialogs.showLoadingDialog(context, _keyLoader);
                              if (!connectionStatus) {
                                connect().then((value) => recieveData());
                              } else {
                                recieveData();
                              }
                            },
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0))),
                            child: Text(
                                getTranslated(context, "demmA") + autreCote,
                                style: TextStyle(color: Colors.white)),
                          )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void recieveData() {
    connection.output.add(utf8.encode("1"));
    connection.output.allSent;
    connection.input.listen((Uint8List data) {
      result += ascii.decode(data);
      print("///////////////////");
      print(result);
      if (result.contains("!")) {
        disconnect();
      }
    }).onDone(() {
      result = result.substring(0, result.length - 2);
      Pied pied2 = new Pied();
      int separator = result.indexOf(",");
      pied2.dimention = double.parse(result.substring(0, separator));
      print(result.substring(separator + 1, result.length));
      pied2.temperature =
          double.parse(result.substring(separator + 1, result.length));
      pied2.cote = leg.cote == Cote.gauche ? Cote.droit : Cote.gauche;
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      print(leg.rougeur);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SecoundLegActivity(leg, pied2)));
    });
  }

  Widget bottomSheet(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(15.0),
            topRight: const Radius.circular(15.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(
                child: Divider(
                  height: 1,
                  color: Colors.black87,
                  indent: 180.0,
                  endIndent: 180.0,
                  thickness: .6,
                ),
              ),
              SizedBox(height: 5),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  getTranslated(context, "ouvAvec"),
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(height: 15),
              Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      SizedBox.fromSize(
                        size: Size(56, 56), // button width and height
                        child: ClipOval(
                          child: Material(
                            color: kPrimaryColor, // button color
                            child: InkWell(
                              splashColor: Colors.white54, // splash color
                              onTap: () => pickImageFrom(
                                  ImageSource.camera), // button pressed
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.camera,
                                    size: 30,
                                    color: Colors.white,
                                  ), // icon
                                  //Text("Camera"), // text
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(getTranslated(context, "camera")),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox.fromSize(
                        size: Size(56, 56), // button width and height
                        child: ClipOval(
                          child: Material(
                            color: kPrimaryColor, // button color
                            child: InkWell(
                              splashColor: Colors.white54, // splash color
                              onTap: () => pickImageFrom(
                                  ImageSource.gallery), // button pressed
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.image,
                                      size: 30,
                                      color: Colors.white), // icon // text
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(getTranslated(context, "gall")),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void pickImageFrom(ImageSource source) async {
    final pickedFile = await _imagePicker.getImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
      uploadFeetImage();
    }
    Navigator.of(context).pop();
    //print(pickedFile.path);
  }

  Future<String> uploadFeetImage() async {
    _image1 = null;
    var test;
    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black);
    SVProgressHUD.setRingNoTextRadius(20); // default is 24 pt
    SVProgressHUD.show(status: 'Traitement en cours...');

    /* encode image */
    final bytes = File(_imageFile.path).readAsBytesSync();
    String img64 = base64Encode(bytes);
    //print(img64);

    String currentUserEmail = Home.currentUser.email;

    String objText =
        '{"email": "' + currentUserEmail + '", "image": "' + img64 + '" }';

    //print(convert.jsonDecode(objText));

    try {
      final response = await http.post(Uri.http(Url, "/user/feet"),
          body: convert.jsonDecode(objText));
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        test = jsonResponse['Detection'];
        //print(jsonResponse['message']);
        //print(jsonResponse['Detection']);
        if (jsonResponse['Detection'] == 'true') {
          SVProgressHUD.dismiss();
          //print(jsonResponse['RednessPerc']);
          //print(jsonResponse['Image1']);
          //imageFromBase64String(jsonResponse['Image1']);
          setState(() {
            _redness = jsonResponse['RednessPerc'].toString() + " %";
            _image1 = imageFromBase64String(jsonResponse['Image1']);
            leg.rougeur = double.parse(jsonResponse['RednessPerc'].toString());
            leg.image = jsonResponse['Image1'];
          });
          //return jsonResponse['message'];
        }
      }
    } on HttpException catch (err) {
      print("Network exception error: $err");
      return null;
    } finally {
      if (test == 'true') {
      } else {
        SVProgressHUD.showInfo(
            status: "Aucun pied n'a été détecté lors de l'analyse");
        SVProgressHUD.dismiss(delay: Duration(milliseconds: 3000));
      }
    }
  }

  Widget bottomSheetRes(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width,
      //margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(20.0),
          topRight: const Radius.circular(20.0),
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0),
              ),
            ),
            centerTitle: true,
            pinned: true,
            expandedHeight: 30.0,
            flexibleSpace: FlexibleSpaceBar(
              title: _image1 == null
                  ? Text(
                      getTranslated(context, 'nof'),
                      style: TextStyle(color: Colors.black),
                    )
                  : Text(
                      getTranslated(context, 'scanCom') + _redness + ' %',
                      style: TextStyle(fontSize: 11, fontFamily: 'Montserrat'),
                    ),
            ),
            leading: Text(""),
            elevation: 0,
            backgroundColor: Colors.white,
          ),
          SliverFixedExtentList(
            itemExtent: 275,
            delegate: SliverChildListDelegate([
              //equivalent to Listview
              Container(
                child: _imageFile == null
                    ? Text(getTranslated(context, "pasImage"))
                    : Image.file(File(
                        _imageFile.path)), //FileImage(File(_imageFile.path))
              ),

              Container(
                child: _image1 == null ? SizedBox.shrink() : _image1,
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }
}
