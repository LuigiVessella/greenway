class VehicleByDmanDto {
  num? id;
  String? modelName;
  num? maxAutonomyKm;
  num? maxCapacityKg;
  List<DeliveryDTO>? deliveries;

  VehicleByDmanDto(
      {this.id,
      this.modelName,
      this.maxAutonomyKm,
      this.maxCapacityKg,
      this.deliveries});

  VehicleByDmanDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    modelName = json['modelName'];
    maxAutonomyKm = json['maxAutonomyKm'];
    maxCapacityKg = json['maxCapacityKg'];
    if (json['deliveries'] != null) {
      deliveries = <DeliveryDTO>[];
      json['deliveries'].forEach((v) {
        deliveries!.add(DeliveryDTO.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['modelName'] = modelName;
    data['maxAutonomyKm'] = maxAutonomyKm;
    data['maxCapacityKg'] = maxCapacityKg;
    if (deliveries != null) {
      data['deliveries'] = deliveries!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DeliveryDTO {
  num? id;
  String? sender;
  String? senderAddress;
  String? receiver;
  String? receiverAddress;
  ReceiverCoordinatesDto? receiverCoordinates;
  String? estimatedDeliveryTime;
  num? weightKg;
  bool? inTransit;
  String? deliveryTime;

  DeliveryDTO(
      {this.id,
      this.sender,
      this.senderAddress,
      this.receiver,
      this.receiverAddress,
      this.receiverCoordinates,
      this.estimatedDeliveryTime,
      this.weightKg});

  DeliveryDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sender = json['sender'];
    senderAddress = json['senderAddress'];
    receiver = json['receiver'];
    receiverAddress = json['receiverAddress'];
    receiverCoordinates = json['receiverCoordinates'] != null
        ? ReceiverCoordinatesDto.fromJson(json['receiverCoordinates'])
        : null;
    estimatedDeliveryTime = json['estimatedDeliveryTime'];
    weightKg = json['weightKg'];
    inTransit = json['inTransit'];
    deliveryTime = json['deliveryTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sender'] = sender;
    data['senderAddress'] = senderAddress;
    data['receiver'] = receiver;
    data['receiverAddress'] = receiverAddress;
    if (receiverCoordinates != null) {
      data['receiverCoordinates'] = receiverCoordinates!.toJson();
    }
    data['estimatedDeliveryTime'] = estimatedDeliveryTime;
    data['weightKg'] = weightKg;
    return data;
  }
}

class ReceiverCoordinatesDto {
  String? type;
  List<double>? coordinates;

  ReceiverCoordinatesDto({this.type, this.coordinates});

  ReceiverCoordinatesDto.fromJson(Map<String, dynamic> json) {
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
