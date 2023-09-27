class Bus {
  Bus({
    required this.msg,
    required this.buses,
  });
  late final String msg;
  late final List<Buses> buses;

  Bus.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    buses = List.from(json['buses']).map((e) => Buses.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['msg'] = msg;
    _data['buses'] = buses.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Buses {
  Buses({
    required this.busId,
    required this.busPlate,
    required this.numberSeat,
    required this.isDoubleDecker,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.busImage,
  });
  late final String? busId;
  late final String? busPlate;
  late final int? numberSeat;
  late final bool? isDoubleDecker;
  late final String? status;
  late final String? createdAt;
  late final String? updatedAt;
  late final List<dynamic>? busImage;

  Buses.fromJson(Map<String, dynamic> json) {
    busId = json['busId'];
    busPlate = json['busPlate'];
    numberSeat = json['numberSeat'];
    isDoubleDecker = json['isDoubleDecker'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['bus_image'] != null && json['bus_image'] is List) {
      busImage = List<Buses>.from(
        json['bus_image'].map((x) => Buses.fromJson(x)),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['busId'] = busId;
    _data['busPlate'] = busPlate;
    _data['numberSeat'] = numberSeat;
    _data['isDoubleDecker'] = isDoubleDecker;
    _data['status'] = status;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    if (busImage != null) {
      _data['bus_image'] = busImage!.map((x) => x.toJson()).toList();
    }
    return _data;
  }
}
