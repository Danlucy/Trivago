import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trivago/constants/colour.dart';
import 'package:trivago/core/error_text.dart';
import 'package:trivago/core/loader.dart';
import 'package:intl/intl.dart';
import 'package:trivago/features/home/widget/drawer.dart';
import 'package:trivago/features/group_booking/repository/group_booking_repository.dart';
import 'package:trivago/features/group_booking/screen/group_booking_details_screen.dart';

@RoutePage()
class GroupBookingOverviewScreen extends ConsumerStatefulWidget {
  const GroupBookingOverviewScreen({super.key});
  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  ConsumerState createState() => _GroupBookingOverviewScreenState();
}

class _GroupBookingOverviewScreenState
    extends ConsumerState<GroupBookingOverviewScreen> {
  final List<String> selectedRoomList = [];
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Theme(
      data: Pallete.lightModeAppTheme,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFFeed9c4),
            title: const Text('Group Bookings'),
            centerTitle: false,
            leading: Builder(builder: (context) {
              return IconButton(
                onPressed: () => widget.displayDrawer(context),
                icon: const Icon(Icons.menu),
              );
            }),
            actions: const [],
          ),
          drawer: GeneralDrawer(width: height, height: width),
          body: ref.watch(groupBookingsProvider).when(
                data: (data) {
                  return data.isEmpty
                      ? const Center(
                          child: Text(
                            'No Group Bookings Currently  ¯\\_(ツ)_/¯',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            final height = MediaQuery.of(context).size.height;
                            final width = MediaQuery.of(context).size.width;
                            final bookingData = data[index];

                            return InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return GroupDetailsDialog(
                                        groupBookingData: bookingData,
                                      );
                                    });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                height: 50,
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.all(3),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              color: Color(0xFFf7f2f9),
                                            ),
                                            child: Text(
                                              bookingData.customerName,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: SizedBox(
                                          width: width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(5)),
                                                    border: Border.all(
                                                      color: Pallete.greyColor,
                                                    )),
                                                child: Text(
                                                  bookingData.districtID.name,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              SizedBox(
                                                width: 18,
                                                child: Text(
                                                  bookingData.roomBooked
                                                      .toString(),
                                                ),
                                              ),
                                              const Icon(
                                                Icons.house,
                                                size: 20,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              1),
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey
                                                            .withOpacity(0.1),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(10),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        DateFormat.yMMMd()
                                                            .format(bookingData
                                                                .vacantDuration
                                                                .start),
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                    const Icon(
                                                        Icons
                                                            .arrow_downward_outlined,
                                                        size: 10),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              1),
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey
                                                            .withOpacity(0.1),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(10),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        DateFormat.yMMMd()
                                                            .format(bookingData
                                                                .vacantDuration
                                                                .end),
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: data.length);
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () => const Loader(),
              )),
    );
  }
}
