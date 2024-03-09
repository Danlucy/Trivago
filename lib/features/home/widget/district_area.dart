import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trivago/features/booking/screen/booking_screen.dart';
import 'package:trivago/models/room_models/room_model.dart';
import 'package:trivago/models/room_models/room_model_data.dart';

class DistrictView extends ConsumerStatefulWidget {
  const DistrictView({
    super.key,
    required this.controller,
  });
  final TabController controller;

  @override
  ConsumerState createState() => _DistrictViewState();
}

class _DistrictViewState extends ConsumerState<DistrictView>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_clearList);
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  void _clearList() {
    selectedRoomList.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TabBarView(
          controller: widget.controller,
          children: DistrictsID.values
              .map((e) => DistrictRoom(
                    rooms: roomData[e]!,
                  ))
              .toList()),
    );
  }
}

class DistrictRoom extends StatefulWidget {
  const DistrictRoom({super.key, required this.rooms});
  final List<RoomModel> rooms;
  @override
  State<DistrictRoom> createState() => _DistrictRoomState();
}

final List<String> selectedRoomList = [];

class _DistrictRoomState extends State<DistrictRoom> {
  @override
  build(BuildContext context) {
    return ListView(
      children: [
        for (RoomModel room in widget.rooms)
          DistrictTiles(
            selectedRoomList: selectedRoomList,
            roomList: (data) {
              if (selectedRoomList.contains(data)) {
                selectedRoomList.remove(data);
              } else {
                selectedRoomList.add(data);
              }
              print(selectedRoomList);
            },
            roomModel: room,
          )
      ],
    );
  }
}
