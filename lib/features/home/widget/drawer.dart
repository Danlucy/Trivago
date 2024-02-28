import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trivago/features/auth/repository/auth_repository.dart';
import 'package:trivago/routes/app_router.gr.dart';

class GeneralDrawer extends ConsumerWidget {
  const GeneralDrawer({super.key});
  void navigateToGroupBookingOverview(BuildContext context) {
    AutoRouter.of(context).push(const GroupBookingOverviewRoute());
  }

  void navigateToHome(BuildContext context) {
    AutoRouter.of(context).push(const HomeRoute());
  }

  void navigateToBookingOverview(BuildContext context) {
    AutoRouter.of(context).push(const BookingOverviewRoute());
  }

  void navigateToAnalytics(BuildContext context) {
    AutoRouter.of(context).push(const AnalyticsRoute());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          ListTile(
            title: const Text('Home'),
            leading: const Icon(Icons.house),
            onTap: () {
              navigateToHome(context);
            },
          ),
          ListTile(
              title: const Text('Bookings'),
              leading: const Icon(Icons.person),
              onTap: () {
                navigateToBookingOverview(context);
              }),
          ListTile(
            title: const Text('Group Bookings'),
            leading: const Icon(Icons.group),
            onTap: () {
              navigateToGroupBookingOverview(context);
            },
          ),
          ListTile(
            title: const Text('Log out'),
            leading: const Icon(Icons.logout),
            onTap: () {
              ref.read(authRepositoryProvider).logout();
            },
          ),
          // ListTile(
          //   title: const Text('Analytics'),
          //   leading: const Icon(Icons.analytics),
          //   onTap: () {
          //     navigateToAnalytics(context);
          //   },
          // ),
        ],
      )),
    );
  }
}
