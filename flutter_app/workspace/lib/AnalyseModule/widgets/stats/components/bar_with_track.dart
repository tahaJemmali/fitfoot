/// Package import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

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
  _BarTrackerState();

  @override
  Widget build(BuildContext context) {
    return _getTrackerBarChart();
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
          title: AxisTitle(text: "Nombre d'analyse par jour"),
          minimum: 0,
          maximum: 8,
          majorTickLines: MajorTickLines(size: 0)),
      series: _getTrackerBarSeries(),
      tooltipBehavior:
          TooltipBehavior(enable: true, header: '', canShowMarker: false),
    );
  }

  /// Returns the lsit of chart series
  /// which need to render on the bar chart with trackers.
  List<BarSeries<ChartSampleData, String>> _getTrackerBarSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: convertDateTimeDisplayDateTime(DateTime(2021, 3, 1).toString()),
          y: 2),
      ChartSampleData(
          x: convertDateTimeDisplayDateTime(DateTime(2021, 3, 2).toString()),
          y: 3),
      ChartSampleData(
          x: convertDateTimeDisplayDateTime(DateTime(2021, 3, 3).toString()),
          y: 1),
      ChartSampleData(
          x: convertDateTimeDisplayDateTime(DateTime(2021, 3, 4).toString()),
          y: 1),
      ChartSampleData(
          x: convertDateTimeDisplayDateTime(DateTime(2021, 3, 5).toString()),
          y: 2),
      ChartSampleData(
          x: convertDateTimeDisplayDateTime(DateTime(2021, 3, 6).toString()),
          y: 1),
      ChartSampleData(
          x: convertDateTimeDisplayDateTime(DateTime(2021, 3, 7).toString()),
          y: 1),
    ];
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
