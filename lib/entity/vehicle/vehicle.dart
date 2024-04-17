// To parse this JSON data, do
//
//     final vehicle = vehicleFromJson(jsonString);

import 'dart:convert';

import 'package:greenway/entity/delivery.dart';

Vehicle vehicleFromJson(String str) => Vehicle.fromJson(json.decode(str));

String vehicleToJson(Vehicle data) => json.encode(data.toJson());

class Vehicle {
    int? id;
    String modelName;
    int maxAutonomyKm;
    int maxCapacityKg;
   
    List<Delivery>? deliveries = List.empty();

    Vehicle({
        this.id,
        required this.modelName,
        required this.maxAutonomyKm,
        required this.maxCapacityKg,
        this.deliveries,
    });

    factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json["id"],
        modelName: json["modelName"],
        maxAutonomyKm: json["maxAutonomyKm"],
        maxCapacityKg: json["maxCapacityKg"],
        deliveries: List<Delivery>.from(json["deliveries"].map((x) => Delivery.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "modelName": modelName,
        "maxAutonomyKm": maxAutonomyKm,
        "maxCapacityKg": maxCapacityKg,
        if(deliveries!=null)"deliveries": List<dynamic>.from(deliveries!.map((x) => x.toJson())),
    };
}