import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trivago/constants/colour.dart';
import 'package:trivago/core/error_text.dart';
import 'package:trivago/core/loader.dart';
import 'package:trivago/features/booking/repository/booking_repository.dart';
import 'package:intl/intl.dart';
import 'package:trivago/features/booking/screen/booking_details_screen.dart';
import 'package:trivago/features/home/widget/drawer.dart';
import 'package:trivago/models/booked_models/booked_models.dart';

@RoutePage()
class BookingOverviewScreen extends ConsumerStatefulWidget {
  const BookingOverviewScreen({super.key});
  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  ConsumerState createState() => _BookingOverviewScreenState();
}

class _BookingOverviewScreenState extends ConsumerState<BookingOverviewScreen> {
  String name = "";
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
              title: const Text('Bookings'),
              centerTitle: false,
              leading: Builder(builder: (context) {
                return IconButton(
                  onPressed: () => widget.displayDrawer(context),
                  icon: const Icon(Icons.menu),
                );
              }),
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(25),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white60,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30))),
                    child: TextField(
                      onChanged: (val) {
                        setState(() {
                          name = val;
                        });
                      },
                      maxLines: 1,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search...'),
                    ),
                  )),
            ),
            drawer: GeneralDrawer(height: height, width: width),
            body: ref.watch(relevantBookingsProvider).when(
                  data: (data) {
                    final filteredData = data.where(
                      (element) {
                        return element.customerName
                            .toLowerCase()
                            .startsWith(name.toLowerCase());
                      },
                    ).toList();

                    return filteredData.isEmpty
                        ? const Center(
                            child: Text(
                              'No Bookings Found  ¯\\_(ツ)_/¯',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              final height = MediaQuery.of(context).size.height;
                              final width = MediaQuery.of(context).size.width;

                              final BookingData bookingData =
                                  filteredData[index];

                              return InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return DetailsDialog(
                                          bookingData: bookingData,
                                        );
                                      });
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  height: 50,
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
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
                                                style: const TextStyle(
                                                    fontSize: 14),
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
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color(0xFFf7f2f9),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(6),
                                                    ),
                                                  ),
                                                  width: 40,
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  child: Text(
                                                      bookingData.roomName,
                                                      textAlign:
                                                          TextAlign.center),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(5),
                                                      ),
                                                      border: Border.all(
                                                        color:
                                                            Pallete.greyColor,
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
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(1),
                                                        decoration:
                                                            BoxDecoration(
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
                                                          style: TextStyle(
                                                              color: Pallete
                                                                  .purpleColor,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                      const Icon(
                                                          Icons
                                                              .arrow_downward_outlined,
                                                          size: 10),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(1),
                                                        decoration:
                                                            BoxDecoration(
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
                                                          style: TextStyle(
                                                              color: Pallete
                                                                  .purpleColor,
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
                            itemCount: filteredData.length,
                          );
                  },
                  error: (error, stackTrace) =>
                      ErrorText(error: error.toString()),
                  loading: () => const Loader(),
                )));
  }
}
