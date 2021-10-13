import 'dart:io';

import 'package:flutter/cupertino.dart';

/// Package import
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:workspace/AnalyseModule/classes/Static2.dart';
import 'package:workspace/AnalyseModule/classes/mesure.dart';
import 'package:workspace/AnalyseModule/classes/Static.dart';

import 'package:workspace/AnalyseModule/classes/statsA.dart';
import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/Login/utils/constants.dart';

/// Local imports
import 'sample_view.dart';

/// Renders the chart with default data labels sample.
class DataLabelDefault extends SampleView {
  /// Creates the chart with default data labels sample.

  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ENGLISH', 'en'),
        const Locale('FRENcH', 'fr'),
        const Locale('ARABIC', 'ar'),
        // ... other locales the app supports
      ],
      locale: const Locale('ar'),
      home: DataLabelDefault(),
    );
  }

  @override
  _DataLabelDefaultState createState() => _DataLabelDefaultState();
}

/// State class of the chart with default data labels.
class _DataLabelDefaultState extends SampleViewState {
  List<ChartSampleData> chartData = <ChartSampleData>[];
  List<ChartSampleData> freeData = <ChartSampleData>[];
  _DataLabelDefaultState();
  double x = 1;
  bool isArab = false;
  SharedPreferences sharedPreferences;

  Future<void> getShared() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

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

    _getDataLabelDefaultSeries().then((value) => setState(() {
          Statis.m = value;
          if (Statis.m != null) {
            if (Statis.m.first.dataSource.length == 1) {
              setState(() {
                x = 7;
              });
            } else if (Statis.m.first.dataSource.length == 2) {
              if (Statis.m.first.dataSource.first.x !=
                  Statis.m.first.dataSource.elementAt(1).x) {
                setState(() {
                  x = 1;
                });
              } else {
                setState(() {
                  x = 10;
                });
              }
            } else {
              setState(() {
                x = 1;
              });
            }
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    if (Statix.m.isEmpty || Statix.m.first.dataSource.length == 0) {
      return Center(
          child: Container(
        child: Center(
            child: Text(getTranslated(context, "aucunanalyse"),
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
    } else if (Statix.m.first.dataSource.length == 1) {
      return Center(
          child: Container(
        child: Center(
            child: Column(
          children: [
            Text(getTranslated(context, "initanadone"),
                style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500)),
            SizedBox(
              height: 3,
            ),
            Divider(
              color: kPrimaryColor,
              height: 2,
              thickness: 1,
            ),
            Text(getTranslated(context, "msginitana"),
                style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w400)),
          ],
        )),
        height: 80.0,
        width: 350.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0.0),
          border: Border.all(
              color: kPrimaryColor, style: BorderStyle.solid, width: 2.0),
        ),
      ));
    } else {
      return pad(isArab);
    }
  }

  Padding pad(bool a) {
    if (!a) {
      return Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20, right: 2),
        child: _getDataLabelDefaultChart(),
      );
    } else
      return Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: _getDataLabelDefaultChart());
  }

  /// Returns the chart with default data labels.
  Widget _getDataLabelDefaultChart() {
    return SfCartesianChart(
      //title: ChartTitle(text: 'etat du pied'),
      plotAreaBorderWidth: 0,
      legend: Legend(
        isVisible: !isCardView,
      ),

      primaryXAxis: DateTimeAxis(
          intervalType: DateTimeIntervalType.days,
          majorGridLines: MajorGridLines(width: 0),
          labelPosition: ChartDataLabelPosition.outside,
          labelAlignment: LabelAlignment.start,
          labelRotation: -50,
          interval: x,
          labelIntersectAction: AxisLabelIntersectAction.rotate90,
          dateFormat: DateFormat.yMd()),
      primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: 300,
          labelFormat: '{value}%',
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0)),
      series: Statis.m,
      tooltipBehavior: TooltipBehavior(
        enable: true,
      ),
    );
  }

  /// Returns the list of chart series which need to
  /// render on the chart with default data labels.

  Future<List<Mesure>> _getStatA() async {
    String objText = '{"email": "' + Home.currentUser.email + '" }';
    try {
      final response = await http.post(Uri.http(Url, "/mesure/getStatA"),
          body: convert.jsonDecode(objText));

      if (response.statusCode == 200) {
        final stats = statsAFromJson(response.body);

        if (stats.lastMesure.isNotEmpty) {
          return stats.lastMesure;
        } else {
          return null;
        }
      } else
        return null;
    } on HttpException {
      return null;
    } finally {}
  }

  Future<void> getChartData() async {
    int i, j, n, k = 0;
    double x, y = 0;
    var tab = [];
    bool add = true;
    int day, month, year = 0;
    await _getStatA().then((value) => {
          if (value != null)
            {
              for (i = 0; i < value.length; i++)
                {
                  add = true,
                  if (value.elementAt(i).pied1.etat != -500 &&
                      value.elementAt(i).pied2.etat != -500)
                    {
                      if (value.elementAt(i).pied1.cote.toString() ==
                          "Cote.droit")
                        x = value.elementAt(i).pied1.etat * 100
                      else
                        {x = value.elementAt(i).pied2.etat * 100},
                      if (value.elementAt(i).pied1.cote.toString() ==
                          "Cote.gauche")
                        y = value.elementAt(i).pied1.etat * 100
                      else
                        {y = value.elementAt(i).pied2.etat * 100},
                      day = int.parse(
                          value.elementAt(i).date.toString().substring(8, 10)),
                      month = int.parse(
                          value.elementAt(i).date.toString().substring(5, 7)),
                      year = int.parse(
                          value.elementAt(i).date.toString().substring(0, 4)),
                      for (j = 0; j < value.length; j++)
                        {
                          if (value
                                      .elementAt(i)
                                      .date
                                      .toString()
                                      .substring(8, 10) ==
                                  value
                                      .elementAt(j)
                                      .date
                                      .toString()
                                      .substring(8, 10) &&
                              value
                                      .elementAt(i)
                                      .date
                                      .toString()
                                      .substring(5, 7) ==
                                  value
                                      .elementAt(j)
                                      .date
                                      .toString()
                                      .substring(5, 7) &&
                              value
                                      .elementAt(i)
                                      .date
                                      .toString()
                                      .substring(0, 4) ==
                                  value
                                      .elementAt(j)
                                      .date
                                      .toString()
                                      .substring(0, 4))
                            {
                              if (value.elementAt(i).pied1.etat ==
                                      value.elementAt(j).pied1.etat &&
                                  value.elementAt(i).pied2.etat ==
                                      value.elementAt(j).pied2.etat &&
                                  i != j)
                                {tab.add(j), k++}
                            }
                        },
                      for (n = 0; n < tab.length; n++)
                        {
                          if (tab[n] == i) {add = false}
                        },
                      if (add)
                        {
                          chartData.add(ChartSampleData(
                              x: DateTime(year, month, day),
                              y: x.toInt(),
                              yValue: y.toInt(),
                              temperature: "20",
                              rougeur: "50",
                              dimension: "11"))
                        },
                    }
                },
            }
          else
            {chartData = freeData}
        });
  }

  Future<List<SplineSeries<ChartSampleData, DateTime>>>
      _getDataLabelDefaultSeries() async {
    await getChartData();

    return <SplineSeries<ChartSampleData, DateTime>>[
      SplineSeries<ChartSampleData, DateTime>(
          legendIconType: LegendIconType.rectangle,
          dataSource: chartData,
          color: const Color.fromRGBO(140, 198, 64, 1),
          width: 2,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          markerSettings: MarkerSettings(isVisible: true),
          name: getTranslated(context, "piedd"),
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            useSeriesColor: true,
            alignment: ChartAlignment.center,
            labelAlignment: ChartDataLabelAlignment.outer,
            offset: Offset(0, 0),
          )),
      SplineSeries<ChartSampleData, DateTime>(
          legendIconType: LegendIconType.rectangle,
          color: const Color.fromRGBO(203, 164, 199, 1),
          dataSource: chartData,
          width: 2,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue,
          markerSettings: MarkerSettings(isVisible: true),
          name: getTranslated(context, "piedg"),

          /// To enable the data label for cartesian chart.
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            useSeriesColor: true,
            alignment: ChartAlignment.center,
            labelAlignment: ChartDataLabelAlignment.outer,
            offset: Offset(0, 0),
          ))
    ];
  }
}
