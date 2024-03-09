import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trivago/constants/colour.dart';
import 'package:trivago/features/auth/repository/auth_repository.dart';
import 'package:trivago/routes/app_router.gr.dart';

class GeneralDrawer extends ConsumerWidget {
  const GeneralDrawer({super.key, required height, required width});
  final height = 600.0;
  final width = 300.0;
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
            title: const Text('Analytics'),
            leading: const Icon(Icons.analytics),
            onTap: () {
              navigateToAnalytics(context);
            },
          ),
          const Spacer(),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.logout),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Center(
                      child: Container(
                        width: width * 3 / 4,
                        height: height * 1 / 4,
                        decoration: BoxDecoration(
                            color: Pallete.peachColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Confirm Log Out?',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.black),
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent),
                                  onPressed: () {
                                    ref.read(authRepositoryProvider).logout();
                                  },
                                  child: const Text(
                                    'Confirm',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  });
            },
          ),
        ],
      )),
    );
  }
}
