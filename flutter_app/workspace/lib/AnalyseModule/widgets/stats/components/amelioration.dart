/// Dart import
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'dart:ui' as dart_ui;

/// Package imports
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Pdf import
import 'package:syncfusion_flutter_pdf/pdf.dart';

/// Local imports
import 'save_file_mobile.dart';
import 'default_data_labels.dart';

///Renders default column chart sample
class Amelioration extends StatefulWidget {
  ///Renders default column chart sample
  Amelioration({Key key}) : super(key: key);
  @override
  _AmeliorationState createState() => _AmeliorationState();
}

class _AmeliorationState extends State<Amelioration> {
  _AmeliorationState();
  //final GlobalKey<SfCartesianChartState> _chartKey = GlobalKey();
  GlobalKey _chartKey = new GlobalKey<SfCartesianChartState>();
  void initState() {
    super.initState();
  }
  // ScaffoldState _scaffoldState;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _chartKey,
      child: Scaffold(
          key: scaffoldKey,
          body: Column(children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 20, bottom: 20, right: 2),
                      child: DataLabelDefault(),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 60, right: 50, bottom: 20),
                      child: Row(
                        children: [
                          Container(
                            width: 15,
                            height: 15,
                            color: const Color.fromRGBO(203, 164, 199, 1),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text("Pied Gauche"),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: 15,
                            height: 15,
                            color: const Color.fromRGBO(140, 198, 64, 1),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text("Pied Droite"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Spacer(),
                    Container(
                        decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.grey,
                                offset: const Offset(0, 4.0),
                                blurRadius: 4.0,
                              ),
                            ],
                            shape: BoxShape.circle,
                            color: new Color(0xFF00A19A)),
                        alignment: Alignment.center,
                        child: IconButton(
                          onPressed: () {
                            scaffoldKey.currentState.showSnackBar(SnackBar(
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              duration: Duration(milliseconds: 100),
                              content:
                                  Text("Chart has been exported as PNG image"),
                            ));
                            _capturePng();
                          },
                          icon: Icon(Icons.image, color: Colors.white),
                        )),
                    Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.grey,
                                offset: const Offset(0, 4.0),
                                blurRadius: 4.0,
                              ),
                            ],
                            shape: BoxShape.circle,
                            color: new Color(0xFF00A19A)),
                        alignment: Alignment.center,
                        child: IconButton(
                          onPressed: () {
                            scaffoldKey.currentState.showSnackBar(SnackBar(
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(milliseconds: 2000),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              content: Text(
                                  "Chart is being exported as PDF document"),
                            ));
                            _renderPdf();
                          },
                          icon: Icon(Icons.picture_as_pdf, color: Colors.white),
                        )),
                  ],
                ))
          ])),
    );
  }

  Future<void> _renderImage() async {
    final bytes = await _capturePng();
    print("bytes:" + bytes.toString());
    if (bytes != null) {
      final Directory documentDirectory =
          await getApplicationDocumentsDirectory();
      final String path = documentDirectory.path;
      final String imageName = 'cartesianchart.png';
      imageCache.clear();
      File file = new File('$path/$imageName');
      file.writeAsBytesSync(bytes);
      file.watch();
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Container(
                  color: Colors.white,
                  child: Image.file(file),
                ),
              ),
            );
          },
        ),
      );
    }
  }

  Future<void> _renderPdf() async {
    dart_ui.Image image;
    Uint8List pngBytes;
    bool catched = false;
    RenderRepaintBoundary boundary =
        _chartKey.currentContext.findRenderObject();
    try {
      image = await boundary.toImage(pixelRatio: 3.0);
      catched = true;
    } catch (exception) {
      catched = false;
      Timer(Duration(milliseconds: 2), () {
        _renderPdf();
      });
    }
    if (catched) {
      final PdfDocument document = PdfDocument();
      pngBytes = await _readImageData2();
      print(pngBytes);
      final PdfBitmap bitmap = PdfBitmap(pngBytes);
      document.pageSettings.orientation =
          MediaQuery.of(context).orientation == Orientation.landscape
              ? PdfPageOrientation.landscape
              : PdfPageOrientation.portrait;
      document.pageSettings.margins.all = 0;
      document.pageSettings.size =
          Size(bitmap.width.toDouble(), bitmap.height.toDouble());
      final PdfPage page = document.pages.add();
      final Size pageSize = page.getClientSize();
      page.graphics.drawImage(
          bitmap, Rect.fromLTWH(0, 0, pageSize.width, pageSize.height));

      scaffoldKey.currentState.hideCurrentSnackBar();
      scaffoldKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        duration: Duration(milliseconds: 200),
        content: Text("Chart has been exported as PDF document."),
      ));
      final List<int> bytes = document.save();
      document.dispose();
      await FileSaveHelper.saveAndLaunchFile(bytes, 'cartesian_chart.pdf');
    }
  }

  Future<Uint8List> _readImageData() async {
    RenderRepaintBoundary boundary =
        _chartKey.currentContext.findRenderObject();
    dart_ui.Image data = await boundary.toImage(pixelRatio: 3.0);

    final bytes = await data.toByteData(format: dart_ui.ImageByteFormat.png);
    return bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }

  Future<List<int>> _readImageData2() async {
    RenderRepaintBoundary boundary =
        _chartKey.currentContext.findRenderObject();
    dart_ui.Image data = await boundary.toImage(pixelRatio: 3.0);

    final bytes = await data.toByteData(format: dart_ui.ImageByteFormat.png);
    return bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }

  // ignore: missing_return
  Future<Uint8List> _capturePng() async {
    dart_ui.Image image;

    bool catched = false;
    RenderRepaintBoundary boundary =
        _chartKey.currentContext.findRenderObject();
    try {
      image = await boundary.toImage();
      catched = true;
    } catch (exception) {
      catched = false;
      Timer(Duration(milliseconds: 1), () {
        _capturePng();
      });
    }
    if (catched) {
      ByteData byteData =
          await image.toByteData(format: dart_ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
      print("png:" + pngBytes.toString());
      final Directory documentDirectory =
          await getApplicationDocumentsDirectory();
      final String path = documentDirectory.path;
      final String imageName = 'cartesianchart.png';
      imageCache.clear();
      File file = new File('$path/$imageName');
      file.writeAsBytesSync(pngBytes);

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Container(
                  color: Colors.white,
                  child: Image.file(file),
                ),
              ),
            );
          },
        ),
      );
      //return pngBytes;
    }
  }
}
