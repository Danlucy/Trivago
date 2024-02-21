import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import 'package:trivago/routes/app_router.gr.dart';

class GeneralDrawer extends ConsumerWidget {
  const GeneralDrawer({super.key});
  void navigateToGroupBookingOverview(BuildContext context) {
    AutoRouter.of(context).push(const GroupBookingOverviewRoute());
  }

  void navigateToHome(BuildContext context) {
    AutoRouter.of(context).push(HomeRoute());
  }

  void navigateToBookingOverview(BuildContext context) {
    AutoRouter.of(context).push(const BookingOverviewRoute());
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
        ],
      )),
    );
  }
}
