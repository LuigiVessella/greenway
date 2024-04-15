import 'dart:convert';
import 'package:greenway/entity/delivery_package.dart';

List<Delivery> deliveriesFromJson(String str) => List<Delivery>.from(json.decode(str).map((x) => Delivery.fromJson(x)));

Delivery deliveryFromJson(String str) => Delivery.fromJson(json.decode(str));

String deliveryToJson(Delivery data) => json.encode(data.toJson());

class Delivery {
    int? id;
    DateTime createdAt;
    DateTime estimatedDeliveryDate;
    String deliveryManUsername;
    int vehicleId;
    String depositAddress;
    Coordinates depositCoordinates;
    List<DeliveryPackage> deliveryPackages;

    Delivery({
        this.id,
        required this.createdAt,
        required this.estimatedDeliveryDate,
        required this.deliveryManUsername,
        required this.vehicleId,
        required this.depositAddress,
        required this.depositCoordinates,
        required this.deliveryPackages,
    });

    factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        estimatedDeliveryDate: DateTime.parse(json["estimatedDeliveryDate"]),
        deliveryManUsername: json["deliveryManUsername"],
        vehicleId: json["vehicleId"],
        depositAddress: json["depositAddress"],
        depositCoordinates: Coordinates.fromJson(json["depositCoordinates"]),
        deliveryPackages: List<DeliveryPackage>.from(json["deliveryPackages"].map((x) => DeliveryPackage.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "estimatedDeliveryDate": "${estimatedDeliveryDate.year.toString().padLeft(4, '0')}-${estimatedDeliveryDate.month.toString().padLeft(2, '0')}-${estimatedDeliveryDate.day.toString().padLeft(2, '0')}",
        "deliveryManUsername": deliveryManUsername,
        "vehicleId": vehicleId,
        "depositAddress": depositAddress,
        "depositCoordinates": depositCoordinates.toJson(),
        "deliveryPackages": List<dynamic>.from(deliveryPackages.map((x) => x.toJson())),
    };


  void addNewPackage(DeliveryPackage deliveryPackage) {
    deliveryPackages.add(deliveryPackage);
  }
}


class Coordinates {
  String type;
  List<double> coordinates;

Coordinates({
        required this.type,
        required this.coordinates,
    });

    factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
        type: json["type"],
        coordinates: List<double>.from(json["coordinates"].map((x) => x.toDouble())),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
    };
}
