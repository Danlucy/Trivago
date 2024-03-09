import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trivago/constants/colour.dart';
import 'package:trivago/features/analytics/controller/analytics_controller.dart';

class OperationalAnalyticsScreen extends ConsumerStatefulWidget {
  OperationalAnalyticsScreen({super.key});

  @override
  ConsumerState createState() => _OperationalAnalyticsScreenState();
}

class _OperationalAnalyticsScreenState
    extends ConsumerState<OperationalAnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    AnalyticsController analyticsController = AnalyticsController();
    final data = analyticsController.getWeeklyBookings(
      ref,
      DateTime.now(),
    );

    print(DateTime.now().weekday);
    return ListView(
      children: [
        SfCartesianChart(
            palette: [
              Pallete.purpleColor,
            ],
            primaryXAxis: DateTimeAxis(intervalType: DateTimeIntervalType.days),
            title: ChartTitle(text: 'Weekly Bookings'),
            series: <CartesianSeries>[
              // Renders line chart
              LineSeries<WeeklySalesData, DateTime>(
                  dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      textStyle: TextStyle(
                          fontSize: 12,
                          color: Pallete.purpleColor.withOpacity(0.7))),
                  dataSource: data,
                  xValueMapper: (WeeklySalesData sales, _) => sales.days,
                  yValueMapper: (WeeklySalesData sales, _) => sales.sales)
            ])
      ],
    );
  }
}
