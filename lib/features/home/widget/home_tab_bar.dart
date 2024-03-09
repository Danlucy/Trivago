import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trivago/features/booking/controller/booking_controller.dart';
import 'package:trivago/models/room_models/room_model_data.dart';

class HomeTabBar extends ConsumerStatefulWidget {
  const HomeTabBar({super.key, required this.controller});
  final TabController controller;
  @override
  ConsumerState createState() => _TabBarAreaState();
}

class _TabBarAreaState extends ConsumerState<HomeTabBar> {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: widget.controller,
      tabs: const [
        TabBars(DistrictsID.A),
        TabBars(DistrictsID.B),
        TabBars(DistrictsID.C),
        TabBars(DistrictsID.D),
        TabBars(DistrictsID.E),
        TabBars(DistrictsID.F),
        TabBars(DistrictsID.G),
      ],
    );
  }
}

class TabBars extends ConsumerStatefulWidget {
  const TabBars(this.district, {super.key});
  final DistrictsID district;
  @override
  ConsumerState createState() => _TabBarsState();
}

class _TabBarsState extends ConsumerState<TabBars> {
  @override
  Widget build(BuildContext context) {
    BookingController homeController = BookingController();
    final availableRoom = homeController.roomCalculator(
        ref.watch(bookingControllerProvider).selectedDate,
        ref,
        widget.district);

    return Tab(
      // icon: const Icon(Icons.add),
      child: Column(children: [
        Text(
          widget.district.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text((availableRoom).toString())
      ]),
    );
  }
}

class CheckBoxArea extends ConsumerStatefulWidget {
  const CheckBoxArea({super.key});
  @override
  ConsumerState createState() => _CheckBoxAreaState();
}

class _CheckBoxAreaState extends ConsumerState<CheckBoxArea> {
  bool isCheckedBreakfast = false;
  bool isCheckedUK1 = false;
  bool isCheckedUK2 = false;
  bool isCheckedUK3 = false;
  bool isCheckedByCash = false;

  @override
  Widget build(BuildContext context) {
    ref.watch(bookingControllerProvider);
    return Expanded(
      child: ListView(
        children: [
          CheckboxListTile(
              title: const Text('Breakfast'),
              value: isCheckedBreakfast,
              onChanged: (bool? value) {
                ref
                    .read(bookingControllerProvider.notifier)
                    .hasBreakfast(value!);
                setState(() {
                  isCheckedBreakfast = value;
                });
              }),
          CheckboxListTile(
              title: const Text('村⺠，导游， 司机'),
              value: isCheckedUK1,
              onChanged: (bool? value) {
                ref.read(bookingControllerProvider.notifier).setUKBool1(value!);
                setState(() {
                  isCheckedUK1 = value;
                });
              }),
          CheckboxListTile(
              title: const Text('股东'),
              value: isCheckedUK2,
              onChanged: (bool? value) {
                ref.read(bookingControllerProvider.notifier).setUKBool2(value!);
                setState(() {
                  isCheckedUK2 = value;
                });
              }),
          CheckboxListTile(
              title: const Text('政府⼈员'),
              value: isCheckedUK3,
              onChanged: (bool? value) {
                ref.read(bookingControllerProvider.notifier).setUKBool3(value!);
                setState(() {
                  isCheckedUK3 = value;
                });
              }),
          CheckboxListTile(
              title: const Text('By Cash'),
              value: isCheckedByCash,
              onChanged: (bool? value) {
                ref.read(bookingControllerProvider.notifier).byCash(value!);
                setState(() {
                  isCheckedByCash = value;
                });
              }),
        ],
      ),
    );
  }
}
