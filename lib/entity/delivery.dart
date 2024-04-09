import 'dart:convert';

import 'package:greenway/entity/delivery_man.dart';
import 'package:greenway/entity/delivery_package.dart';

Delivery DeliveryFromJson(String str) => Delivery.fromJson(json.decode(str));

String DeliveryToJson(Delivery data) => json.encode(data.toJson());

class Delivery {
    DeliveryMan? deliveryMan;
    String vehicleId;
    StartingPoint startingPoint;
    List<DeliveryPackage> deliveryPackages;

    Delivery({
      required this.vehicleId,
      this.deliveryMan,
      required this.deliveryPackages,
      required this.startingPoint,
    });

    factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
        vehicleId: json["vehicleId"],
        startingPoint: StartingPoint.fromJson(json["startingPoint"]),
        deliveryPackages: List<DeliveryPackage>.from(json["deliveryPackages"].map((x) => DeliveryPackage.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "vehicleId": vehicleId,
        "startingPoint": startingPoint.toJson(),
        "deliveryPackages": List<dynamic>.from(deliveryPackages.map((x) => x.toJson())),
    };

    void addNewPackage(DeliveryPackage deliveryPackage) {
      deliveryPackages.add(deliveryPackage);
    }
}


class StartingPoint {
  String type;
  List<double> coordinates;

  StartingPoint({
    required this.type,
    required this.coordinates,
  });

  factory StartingPoint.fromJson(Map<String, dynamic> json) => StartingPoint(
        type: json["type"],
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
      };
}
