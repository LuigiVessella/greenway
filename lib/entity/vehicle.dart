// To parse this JSON data, do
//
//     final Vehicle= VehicleFromJson(jsonString);

import 'dart:convert';

VehicleVehicleFromJson(String str) => Vehicle.fromJson(json.decode(str));

String VehicleToJson(Vehicle data) => json.encode(data.toJson());

class Vehicle{
    String model;
    String batteryNominalCapacity;
    String vehicleConsumption;
    String currentBatteryCharge;
    String maxCapacity;

    Vehicle({
        required this.model,
        required this.batteryNominalCapacity,
        required this.vehicleConsumption,
        required this.currentBatteryCharge,
        required this.maxCapacity,
    });

    factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        model: json["model"],
        batteryNominalCapacity: json["batteryNominalCapacity"],
        vehicleConsumption: json["vehicleConsumption"],
        currentBatteryCharge: json["currentBatteryCharge"],
        maxCapacity: json["maxCapacity"],
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "batteryNominalCapacity": batteryNominalCapacity,
        "vehicleConsumption": vehicleConsumption,
        "currentBatteryCharge": currentBatteryCharge,
        "maxCapacity": maxCapacity,
    };
}