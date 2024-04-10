// To parse this JSON data, do
//
//     final Vehicle= VehicleFromJson(jsonString);

import 'dart:convert';

import 'dart:convert';

Vehicle vehicleFromJson(String str) => Vehicle.fromJson(json.decode(str));
List<Vehicle> vehiclesFromJson(String str) => List<Vehicle>.from(json.decode(str).map((x) => Vehicle.fromJson(x)));
String vehicleToJson(Vehicle data) => json.encode(data.toJson());

class Vehicle {
    String modelName;
    double maxAutonomyKm;
    double maxCapacityKg;

    Vehicle({
       required this.modelName,
       required this.maxAutonomyKm,
       required this.maxCapacityKg,
    });

    factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        modelName: json["modelName"],
        maxAutonomyKm: json["maxAutonomyKm"],
        maxCapacityKg: json["maxCapacityKg"],
    );

    Map<String, dynamic> toJson() => {
        "modelName": modelName,
        "maxAutonomyKm": maxAutonomyKm,
        "maxCapacityKg": maxCapacityKg,
    };
}