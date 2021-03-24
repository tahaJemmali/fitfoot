/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import 'sample_view.dart';

/// Renders the chart with default data labels sample.
class DataLabelDefault extends SampleView {
  /// Creates the chart with default data labels sample.
  const DataLabelDefault();

  @override
  _DataLabelDefaultState createState() => _DataLabelDefaultState();
}

/// State class of the chart with default data labels.
class _DataLabelDefaultState extends SampleViewState {
  _DataLabelDefaultState();

  final List<String> _positionType =
      <String>['outer', 'top', 'bottom', 'middle'].toList();

  /// List the alignment type.
  final List<String> _chartAlign = <String>['near', 'far', 'center'].toList();

  @override
  Widget build(BuildContext context) {
    return _getDataLabelDefaultChart();
  }

  /// Returns the chart with default data labels.
  SfCartesianChart _getDataLabelDefaultChart() {
    return SfCartesianChart(
      //title: ChartTitle(text: 'etat du pied'),
      plotAreaBorderWidth: 0,
      legend: Legend(isVisible: !isCardView),
      primaryXAxis: DateTimeAxis(

          //title: AxisTitle(text: 'Année'),
          labelIntersectAction: AxisLabelIntersectAction.multipleRows,
          majorGridLines: MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          interval: 1),
      primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: 100,
          labelFormat: '{value}%',
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0)),
      series: _getDataLabelDefaultSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of chart series which need to
  /// render on the chart with default data labels.
  List<SplineSeries<ChartSampleData, DateTime>> _getDataLabelDefaultSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: DateTime(2021, 3, 1), y: 1, yValue: 1),
      ChartSampleData(x: DateTime(2021, 3, 2), y: 24.9, yValue: 21.1),
      ChartSampleData(x: DateTime(2021, 3, 3), y: 25.5, yValue: 22.1),
      ChartSampleData(x: DateTime(2021, 3, 4), y: 29.2, yValue: 25.5),
      ChartSampleData(x: DateTime(2021, 3, 5), y: 30.4, yValue: 26.9),
      ChartSampleData(x: DateTime(2021, 3, 6), y: 31.4, yValue: 91.3)
    ];
    return <SplineSeries<ChartSampleData, DateTime>>[
      SplineSeries<ChartSampleData, DateTime>(
          legendIconType: LegendIconType.rectangle,
          dataSource: chartData,
          color: const Color.fromRGBO(140, 198, 64, 1),
          width: 2,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          markerSettings: MarkerSettings(isVisible: true),
          name: 'Pied Droite',
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
          name: 'Pied Gauche',

          /// To enable the data label for cartesian chart.
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            useSeriesColor: true,
            alignment: ChartAlignment.center,
            labelAlignment: ChartDataLabelAlignment.bottom,
            offset: Offset(0, 0),
          ))
    ];
  }
}
