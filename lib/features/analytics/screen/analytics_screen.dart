import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trivago/constants/colour.dart';
import 'package:trivago/features/analytics/screen/descriptive_analytics_screen.dart';
import 'package:trivago/features/analytics/screen/financial_analytics_screen.dart';
import 'package:trivago/features/analytics/screen/operational_analytics_screen.dart';
import 'package:trivago/features/analytics/widget/analytics_tab_bar.dart';
import 'package:trivago/features/home/widget/drawer.dart';

@RoutePage()
class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});
  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  ConsumerState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Theme(
      data: Pallete.lightModeAppTheme,
      child: Scaffold(
        drawer: GeneralDrawer(height: height, width: width),
        appBar: AppBar(
          title: const Text('Analytics'),
          centerTitle: false,
          backgroundColor: const Color(0xFFeed9c4),
          leading: Builder(builder: (context) {
            return IconButton(
              onPressed: () => widget.displayDrawer(context),
              icon: const Icon(Icons.menu),
            );
          }),
        ),
        body: DefaultTabController(
          initialIndex: 1,
          length: 3,
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    DescriptiveAnalyticsScreen(),
                    OperationalAnalyticsScreen(),
                    FinancialAnalyticsScreen()
                  ],
                ),
              ),
              AnalyticsTabBar()
            ],
          ),
        ),
      ),
    );
  }
}
