/// Dart import
import 'dart:async';
import 'dart:io';
import 'dart:ui' as dart_ui;

/// Package imports
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Pdf import
import 'package:syncfusion_flutter_pdf/pdf.dart';

/// Local imports
import 'sample_view.dart';
import 'save_file_mobile.dart';
import 'bar_with_track.dart';

///Renders default column chart sample
class Frequence extends StatefulWidget {
  ///Renders default column chart sample
  Frequence({Key key}) : super(key: key);

  @override
  _FrequenceState createState() => _FrequenceState();
}

class _FrequenceState extends State<Frequence> {
  _FrequenceState();
  final GlobalKey<SfCartesianChartState> _chartKey = GlobalKey();
  // ScaffoldState _scaffoldState;
  void initState() {
    super.initState();
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        body: Column(children: [
          Expanded(
            child: BarTracker(),
          ),
          Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Spacer(),
                  Container(
                      decoration: BoxDecoration(boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.grey,
                          offset: const Offset(0, 4.0),
                          blurRadius: 4.0,
                        ),
                      ], shape: BoxShape.circle, color: new Color(0xFF00A19A)),
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
                          _renderImage();
                        },
                        icon: Icon(Icons.image, color: Colors.white),
                      )),
                  Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.grey,
                          offset: const Offset(0, 4.0),
                          blurRadius: 4.0,
                        ),
                      ], shape: BoxShape.circle, color: new Color(0xFF00A19A)),
                      alignment: Alignment.center,
                      child: IconButton(
                        onPressed: () {
                          scaffoldKey.currentState.showSnackBar(SnackBar(
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(milliseconds: 2000),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            content:
                                Text("Chart is being exported as PDF document"),
                          ));
                          _renderPdf();
                        },
                        icon: Icon(Icons.picture_as_pdf, color: Colors.white),
                      )),
                ],
              ))
        ]));
  }

  Future<void> _renderImage() async {
    final bytes = await _readImageData();
    if (bytes != null) {
      final Directory documentDirectory =
          await getApplicationDocumentsDirectory();
      final String path = documentDirectory.path;
      final String imageName = 'cartesianchart.png';
      imageCache.clear();
      File file = new File('$path/$imageName');
      file.writeAsBytesSync(bytes);

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
    final PdfDocument document = PdfDocument();
    final PdfBitmap bitmap = PdfBitmap(await _readImageData());
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

  Future<List<int>> _readImageData() async {
    dart_ui.Image data = await _chartKey.currentState.toImage(pixelRatio: 3.0);
    final bytes = await data.toByteData(format: dart_ui.ImageByteFormat.png);
    return bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }
}
