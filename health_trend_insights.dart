library health_trend_insights;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';

class HealthTrendInsights {
  /// Build simple bar chart from data points
  static Widget buildBarChart(List<BarChartGroupData> data) {
    return BarChart(BarChartData(barGroups: data));
  }
}