import 'dart:io';

/// Package import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:workspace/AnalyseModule/classes/Static2.dart';
import 'package:workspace/AnalyseModule/classes/mesure.dart';
import 'package:workspace/AnalyseModule/classes/statsA.dart';
import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/Login/utils/constants.dart';

/// Local imports
import 'sample_view.dart';

/// Renders the bar chart sample with tracker.
class BarTracker extends SampleView {
  /// Creates the bar chart sample with tracker.
  const BarTracker();

  @override
  _BarTrackerState createState() => _BarTrackerState();
}

/// State class of tracker bar chart.
class _BarTrackerState extends SampleViewState {
  List<ChartSampleData> chartData = <ChartSampleData>[];
  List<ChartSampleData> freeData = <ChartSampleData>[];
  bool show = true;
  bool isArab = false;
  SharedPreferences sharedPreferences;

  Future<void> getShared() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  _BarTrackerState();

  @override
  void initState() {
    super.initState();
    getShared().then((value) {
      if (sharedPreferences != null) {
        if (sharedPreferences.containsKey(LANGUAGE_CODE)) {
          if (sharedPreferences.getString(LANGUAGE_CODE) == ARABE) {
            setState(() {
              isArab = true;
            });
          } else {
            setState(() {
              isArab = false;
            });
          }
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _getTrackerBarSeries().then((value) => setState(() {
          Statix.m = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    //print(Statix.m.first.dataSource.length);
    if (Statix.m.isEmpty || Statix.m.first.dataSource.length == 0) {
      show = false;
      return Center(
          child: Container(
        child: Center(
            child: Text(getTranslated(context, "disponotused"),
                style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500))),
        height: 80.0,
        width: 300.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0.0),
          border: Border.all(
              color: kPrimaryColor, style: BorderStyle.solid, width: 2.0),
        ),
      ));
    } else {
      show = true;
      return pad(isArab);
    }
  }

  /// Returns the bar chart with trackers.
  SfCartesianChart _getTrackerBarChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      //title: ChartTitle(text: isCardView ? '' : 'Working hours of employees'),
      primaryXAxis: CategoryAxis(

          //title: AxisTitle(text: 'Année'),
          labelIntersectAction: AxisLabelIntersectAction.multipleRows,
          majorGridLines: MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          interval: 1),
      primaryYAxis: NumericAxis(
          majorGridLines: MajorGridLines(width: 0),
          title: AxisTitle(text: getTranslated(context, "nbrana")),
          minimum: 0,
          maximum: 10,
          majorTickLines: MajorTickLines(size: 0)),
      series: Statix.m,
      tooltipBehavior:
          TooltipBehavior(enable: true, header: '', canShowMarker: true),
    );
  }

  Padding pad(bool a) {
    if (!a)
      return Padding(
        padding: const EdgeInsets.only(right: 0),
        child: _getTrackerBarChart(),
      );
    else
      return Padding(
        padding: const EdgeInsets.only(right: 0),
        child: Container(
            transform: Matrix4.translationValues(
                -MediaQuery.of(context).size.width * 0.97, 0.0, 0.0),
            child: _getTrackerBarChart()),
      );
  }

  Future<List<Mesure>> _getStatA() async {
    String objText = '{"email": "' + Home.currentUser.email + '" }';
    try {
      final response = await http.post(Uri.http(Url, "/mesure/getStatF"),
          body: convert.jsonDecode(objText));
      if (response.statusCode == 200) {
        final stats = statsAFromJson(response.body);

        if (stats.lastMesure.isNotEmpty) {
          return stats.lastMesure;
        } else {
          return null;
        }
      }
    } on HttpException {
      // print("Network exception error: $err");
      return null;
    } finally {}
  }

  Future<void> getChartData() async {
    int i, j, n = 0;
    double y = 0;
    int day, month, year = 0;
    await _getStatA().then((value) => {
          if (value != null)
            {
              for (i = 0; i < value.length; i++)
                {
                  for (j = 0; j < value.length; j++)
                    {
                      if (value.elementAt(j).date.toString().substring(0, 10) ==
                          value.elementAt(i).date.toString().substring(0, 10))
                        {
                          y++,
                        }
                    },
                  day = int.parse(
                      value.elementAt(i).date.toString().substring(8, 10)),
                  month = int.parse(
                      value.elementAt(i).date.toString().substring(5, 7)),
                  year = int.parse(
                      value.elementAt(i).date.toString().substring(0, 4)),
                  chartData.add(ChartSampleData(
                      x: convertDateTimeDisplayDateTime(
                          DateTime(year, month, day).toString()),
                      y: y)),
                  y = 0
                },
              for (n = 0; n < chartData.length; n++)
                {
                  if (chartData.length > 7) {chartData.removeAt(0)}
                },
            }
          else
            {chartData = freeData}
        });
  }

  /// Returns the lsit of chart series
  /// which need to render on the bar chart with trackers.
  Future<List<BarSeries<ChartSampleData, String>>>
      _getTrackerBarSeries() async {
    await getChartData();

    return <BarSeries<ChartSampleData, String>>[
      BarSeries<ChartSampleData, String>(
        dataSource: chartData,
        borderRadius: BorderRadius.circular(15),
        trackColor: const Color.fromRGBO(198, 201, 207, 1),
        color: new Color(0xFF00A19A),

        /// If we enable this property as true,
        /// then we can show the track of series.
        isTrackVisible: true,
        dataLabelSettings: DataLabelSettings(
            isVisible: true, labelAlignment: ChartDataLabelAlignment.top),
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
      ),
    ];
  }

  convertDateTimeDisplayDateTime(String string) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(string);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }
}
