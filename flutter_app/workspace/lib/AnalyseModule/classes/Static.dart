import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:workspace/AnalyseModule/widgets/stats/components/sample_view.dart';

class Statis {
  static List<SplineSeries<ChartSampleData, DateTime>> m =
      <SplineSeries<ChartSampleData, DateTime>>[];
  static double amel1, amel2;
  static bool notif;
  static DateTime lastAuto;
}
