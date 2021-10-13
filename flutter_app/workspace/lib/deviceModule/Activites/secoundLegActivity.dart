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
import 'package:workspace/deviceModule/classes/cote.dart';
import 'package:workspace/deviceModule/classes/pied.dart';
import 'package:workspace/deviceModule/widgets/Dialog.dart';
import 'package:workspace/deviceModule/widgets/loading.dart';

class SecoundLegActivity extends StatefulWidget {
  SecoundLegActivity(this.pied1, this.pied2);
  final Pied pied1;
  final Pied pied2;
  @override
  _SecoundLegActivityState createState() =>
      _SecoundLegActivityState(pied1, pied2);
}

class _SecoundLegActivityState extends State<SecoundLegActivity> {
  _SecoundLegActivityState(this.pied1, this.pied2);
  final Pied pied1;
  final Pied pied2;
  String cote;
  int _selectedLeg;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  PickedFile _imageFile;
  Image _image1;
  File imageFile;
  String networkUrl;
  String _redness = "";
  final ImagePicker _imagePicker = ImagePicker();
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
        _selectedLeg = pied2.cote == Cote.gauche ? 0 : 1;
    cote = pied2.cote != Cote.gauche
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
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Home()));
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
              getTranslated(context, "annpied") + cote,
              style: TextStyle(fontSize: 15),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    getTranslated(context, "enlever") + cote,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, fontFamily: 'Montserrat'),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _selectedLeg == 0
                        ? GestureDetector(
                            onTap: null,
                            child: Container(
                              height: 240,
                              width: 150,
                              color: _selectedLeg == 0
                                  ? Colors.greenAccent
                                  : Colors.blueGrey,
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  Image.asset(
                                    'assets/left.png',
                                    height: 200,
                                    width: 150,
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    getTranslated(context, "piedg"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 18,
                                        color: _selectedLeg == 0
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: null,
                            child: Container(
                              height: 240,
                              width: 150,
                              color: _selectedLeg == 1
                                  ? Colors.greenAccent
                                  : Colors.blueGrey,
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  Image.asset(
                                    'assets/right.png',
                                    height: 200,
                                    width: 150,
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    getTranslated(context, "piedd"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Montserrat',
                                        color: _selectedLeg == 1
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
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
            pied2.rougeur =
                double.parse(jsonResponse['RednessPerc'].toString());
            pied2.image = jsonResponse['Image1'];
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Loading(pied1, pied2)));
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
                      'No feet detected',
                      style: TextStyle(color: Colors.black),
                    )
                  : Text(
                      'Scan complet, la rougeur de votre pied est de : ' +
                          _redness +
                          ' %',
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
                    ? Text("No image found")
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
