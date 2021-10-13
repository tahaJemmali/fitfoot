import 'package:flutter/material.dart';
import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/deviceModule/Activites/analyseDesPiedsActivity.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../../Login/utils/constants.dart';

class DeviceHomeActivity extends StatefulWidget {
  DeviceHomeActivity();

  @override
  _DeviceHomeActivityState createState() => _DeviceHomeActivityState();
}

class _DeviceHomeActivityState extends State<DeviceHomeActivity> {
  int _incriment = 0;
  List<String> images = [];
  String image = 'assets/images/doctor.png';

  void onIndexChanged(int x) {
    setState(() {
      _incriment = x;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocale().then((value) {
      setState(() {
        switch (value.toString()) {
          case "ar_TN":
            images = [
              'assets/ar/doctor.png',
              'assets/ar/first_step.png',
              'assets/ar/secound_step.png',
              'assets/ar/third_step.png'
            ];
            break;
          case "en_US":
            images = [
              'assets/en/doctor.png',
              'assets/en/first_step.png',
              'assets/en/secound_step.png',
              'assets/en/third_step.png'
            ];
            break;
          default:
            images = [
              'assets/fr/doctor.png',
              'assets/fr/first_step.png',
              'assets/fr/secound_step.png',
              'assets/fr/third_step.png'
            ];
            break;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      switch (_incriment) {
        case 0:
          image = 'assets/images/doctor.png';
          break;
        case 1:
          image = 'assets/images/first_step.png';
          break;
        case 2:
          image = 'assets/images/secound_step.png';
          break;
        case 3:
          image = 'assets/images/third_step.png';
          break;
      }
    });
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            //Navigator.of(context).pop();
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
        title: Text(
          getTranslated(context, "jumulage") + Home.device.name,
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Swiper(
                  controller: SwiperController(),
                  control: SwiperControl(),
                  loop: false,
                  pagination: SwiperPagination(
                    margin: EdgeInsets.only(top: .0),
                  ),
                  layout: SwiperLayout.CUSTOM,
                  customLayoutOption: CustomLayoutOption(
                          startIndex: -1, stateCount: 3)
                      .addRotate([-45.0 / 180, 0.0, 45.0 / 180]).addTranslate([
                    Offset(-370.0, -40.0),
                    Offset(0.0, 0.0),
                    Offset(370.0, -40.0)
                  ]),
                  itemWidth: 350.0,
                  itemHeight: 350.0,
                  itemBuilder: (context, index) {
                    return Image.asset(
                      images[index],
                      height: 400,
                      width: 240,
                    );
                  },
                  itemCount: 4),
            ),
            Expanded(
                child: Column(
              children: [
                SizedBox(height: 30),
                Text(
                  getTranslated(context, "piedMatin"),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      color: Colors.red,
                      child: Text(getTranslated(context, "returAcc"),
                          style: TextStyle(color: Colors.white)),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
                      onPressed: () /*async*/ {
                        dispose();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home(),
                          ),
                        );
                      },
                      textColor: Colors.white,
                    ),
                    SizedBox(width: 20),
                    RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnalyseDesPieds(),
                          ),
                        );
                      },
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
                      child: Text(getTranslated(context, "anPieds"),
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                )
              ],
            )),
          ],
        ),
      ),
    );
  }
}
