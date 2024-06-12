class DepotPointDTO {
  String? depositAddress;
  DepositCoordinates? depositCoordinates;

  DepotPointDTO({this.depositAddress, this.depositCoordinates});

  DepotPointDTO.fromJson(Map<String, dynamic> json) {
    depositAddress = json['depositAddress'];
    depositCoordinates = json['depositCoordinates'] != null
        ? DepositCoordinates.fromJson(json['depositCoordinates'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['depositAddress'] = depositAddress;
    if (depositCoordinates != null) {
      data['depositCoordinates'] = depositCoordinates!.toJson();
    }
    return data;
  }
}

class DepositCoordinates {
  String? type;
  List<double>? coordinates;

  DepositCoordinates({this.type, this.coordinates});

  DepositCoordinates.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}
