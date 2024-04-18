// To parse this JSON data, do
//
//     final vehicleByDmanDto = vehicleByDmanDtoFromJson(jsonString);

import 'dart:convert';

VehicleByDmanDto vehicleByDmanDtoFromJson(String str) => VehicleByDmanDto.fromJson(json.decode(str));

String vehicleByDmanDtoToJson(VehicleByDmanDto data) => json.encode(data.toJson());

class VehicleByDmanDto {
    int id;
    String modelName;
    int maxAutonomyKm;
    int maxCapacityKg;
    List<DeliveryDTO> deliveries;

    VehicleByDmanDto({
       required this.id,
       required this.modelName,
       required this.maxAutonomyKm,
       required this.maxCapacityKg,
       required this.deliveries,
    });

    factory VehicleByDmanDto.fromJson(Map<String, dynamic> json) => VehicleByDmanDto(
        id: json["id"],
        modelName: json["modelName"],
        maxAutonomyKm: json["maxAutonomyKm"],
        maxCapacityKg: json["maxCapacityKg"],
        deliveries: List<DeliveryDTO>.from(json["deliveries"].map((x) => DeliveryDTO.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "modelName": modelName,
        "maxAutonomyKm": maxAutonomyKm,
        "maxCapacityKg": maxCapacityKg,
        "deliveries": List<dynamic>.from(deliveries.map((x) => x.toJson())),
    };
}

class DeliveryDTO {
    String sender;
    String senderAddress;
    String receiver;
    String receiverAddress;
    ReceiverCoordinatesDTO receiverCoordinates;
    DateTime estimatedDeliveryTime;
    double weightKg;

    DeliveryDTO({
       required this.sender,
       required this.senderAddress,
       required this.receiver,
       required this.receiverAddress,
       required this.receiverCoordinates,
       required this.estimatedDeliveryTime,
       required this.weightKg,
    });

    factory DeliveryDTO.fromJson(Map<String, dynamic> json) => DeliveryDTO(
        sender: json["sender"],
        senderAddress: json["senderAddress"],
        receiver: json["receiver"],
        receiverAddress: json["receiverAddress"],
        receiverCoordinates: ReceiverCoordinatesDTO.fromJson(json["receiverCoordinates"]),
        estimatedDeliveryTime: DateTime.parse(json["estimatedDeliveryTime"]),
        weightKg: json["weightKg"],
    );

    Map<String, dynamic> toJson() => {
        "sender": sender,
        "senderAddress": senderAddress,
        "receiver": receiver,
        "receiverAddress": receiverAddress,
        "receiverCoordinates": receiverCoordinates.toJson(),
        "estimatedDeliveryTime": estimatedDeliveryTime.toIso8601String(),
        "weightKg": weightKg,
    };
}

class ReceiverCoordinatesDTO {
    String type;
    List<double> coordinates;

    ReceiverCoordinatesDTO({
       required this.type,
       required this.coordinates,
    });

    factory ReceiverCoordinatesDTO.fromJson(Map<String, dynamic> json) => ReceiverCoordinatesDTO(
        type: json["type"],
        coordinates: List<double>.from(json["coordinates"].map((x) => x.toDouble())),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
    };
}

