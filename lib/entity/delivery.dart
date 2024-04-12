import 'dart:convert';

import 'package:greenway/entity/delivery_man.dart';
import 'package:greenway/entity/delivery_package.dart';

List<Delivery> DeliveriesFromJson(String str) => List<Delivery>.from(json.decode(str).map((x) => Delivery.fromJson(x)));

Delivery DeliveryFromJson(String str) => Delivery.fromJson(json.decode(str));

String DeliveryToJson(Delivery data) => json.encode(data.toJson());

class Delivery {
  DeliveryMan? deliveryMan;

  
  String? vehicleId;
  Coordinates? depositCoordinates;
  List<DeliveryPackage>? deliveryPackages;
  String? depositAddress;

  Delivery({
    this.vehicleId,
    this.deliveryMan,
    this.deliveryPackages,
    this.depositCoordinates,
    this.depositAddress,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
        vehicleId: json["vehicleId"],
        depositAddress: json["depositAddress"],
        depositCoordinates: Coordinates.fromJson(json["depositCoordinates"]),
        deliveryPackages: List<DeliveryPackage>.from(
            json["deliveryPackages"].map((x) => DeliveryPackage.fromJson(x))),
        
      );

  Map<String, dynamic> toJson() => {
        "vehicleId": vehicleId,
        "depositCoordinates": depositCoordinates!.toJson(),
        "deliveryPackages":
            List<dynamic>.from(deliveryPackages!.map((x) => x.toJson())),
        "depositAddress": depositAddress,
      };

  void addNewPackage(DeliveryPackage deliveryPackage) {
    deliveryPackages!.add(deliveryPackage);
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
