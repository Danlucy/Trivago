import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trivago/features/home/screen/dsitrict_area.dart';
import 'package:trivago/models/room_models/room_model.dart';

enum DistrictsID {
  A,
  B,
  C,
  D,
  E,
  F,
  G;

  static DistrictsID fromName(String? name) {
    for (DistrictsID enumVariant in DistrictsID.values) {
      if (enumVariant.name == name) return enumVariant;
      print('dog');
    }
    return DistrictsID.A;
  }
}

const roomData = <DistrictsID, List<RoomModel>>{
  DistrictsID.A: [
    RoomModel(name: '6301', defaultPrice: 950, district: DistrictsID.A),
    RoomModel(name: '6302', defaultPrice: 950, district: DistrictsID.A),
    RoomModel(name: '6303', defaultPrice: 950, district: DistrictsID.A),
    RoomModel(name: '6304', defaultPrice: 950, district: DistrictsID.A),
    RoomModel(name: '6305', defaultPrice: 950, district: DistrictsID.A),
    RoomModel(name: '6306', defaultPrice: 950, district: DistrictsID.A),
    RoomModel(name: '6307', defaultPrice: 950, district: DistrictsID.A),
    RoomModel(name: '6308', defaultPrice: 950, district: DistrictsID.A),
    RoomModel(name: '6309', defaultPrice: 950, district: DistrictsID.A),
    RoomModel(name: '6310', defaultPrice: 950, district: DistrictsID.A),
    RoomModel(name: '6311', defaultPrice: 950, district: DistrictsID.A),
    RoomModel(name: '6312', defaultPrice: 950, district: DistrictsID.A),
    RoomModel(name: '6313', defaultPrice: 950, district: DistrictsID.A),
    RoomModel(name: '6314', defaultPrice: 950, district: DistrictsID.A),
    RoomModel(name: '6315', defaultPrice: 950, district: DistrictsID.A),
    RoomModel(name: '6316', defaultPrice: 950, district: DistrictsID.A),
  ],
  DistrictsID.B: [
    RoomModel(name: '6201', defaultPrice: 950, district: DistrictsID.B),
    RoomModel(name: '6202', defaultPrice: 950, district: DistrictsID.B),
    RoomModel(name: '6203', defaultPrice: 950, district: DistrictsID.B),
    RoomModel(name: '6204', defaultPrice: 950, district: DistrictsID.B),
    RoomModel(name: '6205', defaultPrice: 950, district: DistrictsID.B),
    RoomModel(name: '6206', defaultPrice: 950, district: DistrictsID.B),
    RoomModel(name: '6207', defaultPrice: 950, district: DistrictsID.B),
    RoomModel(name: '6208', defaultPrice: 950, district: DistrictsID.B),
    RoomModel(name: '6209', defaultPrice: 950, district: DistrictsID.B),
    RoomModel(name: '6210', defaultPrice: 950, district: DistrictsID.B),
    RoomModel(name: '6211', defaultPrice: 950, district: DistrictsID.B),
    RoomModel(name: '6212', defaultPrice: 950, district: DistrictsID.B),
    RoomModel(name: '6213', defaultPrice: 950, district: DistrictsID.B),
    RoomModel(name: '6214', defaultPrice: 950, district: DistrictsID.B),
    RoomModel(name: '6215', defaultPrice: 950, district: DistrictsID.B),
    RoomModel(name: '6216', defaultPrice: 950, district: DistrictsID.B),
  ],
  DistrictsID.C: [
    RoomModel(name: '1', defaultPrice: 850, district: DistrictsID.C),
    RoomModel(name: '2', defaultPrice: 850, district: DistrictsID.C),
    RoomModel(name: '3', defaultPrice: 850, district: DistrictsID.C),
    RoomModel(name: '4', defaultPrice: 850, district: DistrictsID.C),
    RoomModel(name: '5', defaultPrice: 850, district: DistrictsID.C),
    RoomModel(name: '6', defaultPrice: 850, district: DistrictsID.C),
    RoomModel(name: '7', defaultPrice: 850, district: DistrictsID.C),
  ],
  DistrictsID.D: [
    RoomModel(name: '901', defaultPrice: 750, district: DistrictsID.D),
    RoomModel(name: '902', defaultPrice: 750, district: DistrictsID.D),
    RoomModel(name: '903', defaultPrice: 750, district: DistrictsID.D),
    RoomModel(name: '904', defaultPrice: 750, district: DistrictsID.D),
    RoomModel(name: '905', defaultPrice: 750, district: DistrictsID.D),
    RoomModel(name: '906', defaultPrice: 750, district: DistrictsID.D),
    RoomModel(name: '907', defaultPrice: 750, district: DistrictsID.D),
    RoomModel(name: '908', defaultPrice: 750, district: DistrictsID.D),
    RoomModel(name: '909', defaultPrice: 750, district: DistrictsID.D),
    RoomModel(name: '910', defaultPrice: 750, district: DistrictsID.D),
    RoomModel(name: '911', defaultPrice: 750, district: DistrictsID.D),
    RoomModel(name: '912', defaultPrice: 750, district: DistrictsID.D),
    RoomModel(name: '913', defaultPrice: 750, district: DistrictsID.D),
    RoomModel(name: '914', defaultPrice: 750, district: DistrictsID.D),
    RoomModel(name: '915', defaultPrice: 750, district: DistrictsID.D),
    RoomModel(name: '916', defaultPrice: 750, district: DistrictsID.D),
    RoomModel(name: '917', defaultPrice: 750, district: DistrictsID.D),
  ],
  DistrictsID.E: [
    RoomModel(name: '800', defaultPrice: 750, district: DistrictsID.E),
    RoomModel(name: '801', defaultPrice: 750, district: DistrictsID.E),
    RoomModel(name: '802', defaultPrice: 750, district: DistrictsID.E),
    RoomModel(name: '803', defaultPrice: 750, district: DistrictsID.E),
    RoomModel(name: '809', defaultPrice: 750, district: DistrictsID.E),
    RoomModel(name: '810', defaultPrice: 750, district: DistrictsID.E),
    RoomModel(name: '811', defaultPrice: 750, district: DistrictsID.E),
    RoomModel(name: '812', defaultPrice: 750, district: DistrictsID.E),
    RoomModel(name: '813', defaultPrice: 750, district: DistrictsID.E),
  ],
  DistrictsID.F: [
    RoomModel(name: '301', defaultPrice: 750, district: DistrictsID.F),
    RoomModel(name: '302', defaultPrice: 750, district: DistrictsID.F),
    RoomModel(name: '303', defaultPrice: 750, district: DistrictsID.F),
    RoomModel(name: '304', defaultPrice: 750, district: DistrictsID.F),
    RoomModel(name: '305', defaultPrice: 750, district: DistrictsID.F),
    RoomModel(name: '306', defaultPrice: 750, district: DistrictsID.F),
    RoomModel(name: '307', defaultPrice: 750, district: DistrictsID.F),
    RoomModel(name: '308', defaultPrice: 750, district: DistrictsID.F),
    RoomModel(name: '309', defaultPrice: 750, district: DistrictsID.F),
    RoomModel(name: '310', defaultPrice: 750, district: DistrictsID.F),
    RoomModel(name: '311', defaultPrice: 750, district: DistrictsID.F),
    RoomModel(name: '312', defaultPrice: 750, district: DistrictsID.F),
    RoomModel(name: '313', defaultPrice: 750, district: DistrictsID.F),
    RoomModel(name: '314', defaultPrice: 750, district: DistrictsID.F),
    RoomModel(name: '315', defaultPrice: 750, district: DistrictsID.F),
    RoomModel(name: '316', defaultPrice: 750, district: DistrictsID.F),
  ],
  DistrictsID.G: [
    RoomModel(name: '6A', defaultPrice: 500, district: DistrictsID.G),
    RoomModel(name: '6B', defaultPrice: 500, district: DistrictsID.G),
    RoomModel(name: '6C', defaultPrice: 500, district: DistrictsID.G),
    RoomModel(name: '6D', defaultPrice: 500, district: DistrictsID.G),
    RoomModel(name: '6E', defaultPrice: 500, district: DistrictsID.G),
  ]
};
