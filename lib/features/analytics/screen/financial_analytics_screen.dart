import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trivago/constants/colour.dart';
import 'package:trivago/features/analytics/controller/analytics_controller.dart';

class FinancialAnalyticsScreen extends ConsumerStatefulWidget {
  const FinancialAnalyticsScreen({super.key});

  @override
  ConsumerState createState() => _FinancialAnalyticsScreenState();
}

class _FinancialAnalyticsScreenState
    extends ConsumerState<FinancialAnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    List<Color> gradientColors = [
      Pallete.peachColor.withOpacity(0.4),
      Pallete.peachColor.withOpacity(0.7),
      Colors.grey.withOpacity(0.8)
    ];
    Widget bottomTitleWidgets(double value, TitleMeta meta) {
      final style = TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.brown.withOpacity(0.8));
      Widget text;
      switch (value.toInt()) {
        case 3:
          text = Text('Mon', style: style);
          break;
        case 6:
          text = Text('Tue', style: style);
          break;
        case 9:
          text = Text('Wed', style: style);
          break;
        case 12:
          text = Text('Thu', style: style);
          break;
        case 15:
          text = Text('Fri', style: style);
          break;
        case 18:
          text = Text('Sat', style: style);
          break;
        case 21:
          text = Text('Sun', style: style);
          break;
        default:
          text = Text('', style: style);
          break;
      }

      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: text,
      );
    }

    Widget leftTitleWidgets(double value, TitleMeta meta) {
      TextStyle style = TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Colors.brown.withOpacity(0.8));
      String text;
      switch (value.toInt()) {
        case 10:
          text = '10';
          break;
        case 20:
          text = '20';
          break;
        case 30:
          text = '30';
          break;
        case 40:
          text = '40';
          break;
        case 50:
          text = '50';
          break;
        case 60:
          text = '60';
          break;
        case 70:
          text = '70';
        case 80:
          text = '80';
        case 90:
          text = '90';
          break;

        default:
          return Container();
      }

      return Text(text, style: style, textAlign: TextAlign.left);
    }

    return ListView(
      children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 10),
        //   child: Text(
        //     'Room Occupied',
        //     style: TextStyle(
        //         fontSize: 18,
        //         fontWeight: FontWeight.w500,
        //         color: Colors.brown.withOpacity(0.8)),
        //   ),
        // ),
        // Container(
        //     margin: const EdgeInsets.all(16),
        //     height: 350,
        //     child: LineChart(
        //       LineChartData(
        //         maxY: 90,
        //         gridData: FlGridData(
        //           show: true,
        //           drawVerticalLine: true,
        //           horizontalInterval: 5,
        //           verticalInterval: 1,
        //           getDrawingHorizontalLine: (value) {
        //             return FlLine(
        //               color: Colors.grey.withOpacity(0.6),
        //               strokeWidth: 1,
        //             );
        //           },
        //           getDrawingVerticalLine: (value) {
        //             return FlLine(
        //               color: Colors.grey.withOpacity(0.6),
        //               strokeWidth: 1,
        //             );
        //           },
        //         ),
        //         borderData: FlBorderData(
        //           show: true,
        //           border: Border.all(
        //             color: const Color(0xff37434d),
        //           ),
        //         ),
        //         titlesData: FlTitlesData(
        //           show: true,
        //           rightTitles: const AxisTitles(
        //             sideTitles: SideTitles(showTitles: false),
        //           ),
        //           topTitles: const AxisTitles(
        //             sideTitles: SideTitles(showTitles: false),
        //           ),
        //           bottomTitles: AxisTitles(
        //             sideTitles: SideTitles(
        //               showTitles: true,
        //               reservedSize: 30,
        //               interval: 1,
        //               getTitlesWidget: bottomTitleWidgets,
        //             ),
        //           ),
        //           leftTitles: AxisTitles(
        //             sideTitles: SideTitles(
        //               showTitles: true,
        //               interval: 1,
        //               getTitlesWidget: leftTitleWidgets,
        //               reservedSize: 20,
        //             ),
        //           ),
        //         ),
        //         lineBarsData: [
        //           LineChartBarData(
        //             spots: const [
        //               FlSpot(3, 14),
        //               FlSpot(6, 20),
        //               FlSpot(9, 21),
        //               FlSpot(12, 3),
        //               FlSpot(15, 2),
        //               FlSpot(18, 2),
        //               FlSpot(21, 70),
        //             ],
        //             gradient: LinearGradient(
        //               colors: gradientColors,
        //             ),
        //             isCurved: true,
        //             preventCurveOverShooting: true,
        //             barWidth: 2,
        //             isStrokeCapRound: true,
        //             dotData: const FlDotData(
        //               show: true,
        //             ),
        //             belowBarData: BarAreaData(
        //               show: true,
        //               gradient: LinearGradient(
        //                 colors: gradientColors
        //                     .map((color) => color.withOpacity(0.3))
        //                     .toList(),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ))
      ],
    );
  }
}
