// To parse this JSON data, do
//
//     final vehicleDeposit = vehicleDepositFromJson(jsonString);

import 'dart:convert';

import 'package:greenway/entity/delivery.dart';

VehicleDeposit vehicleDepositFromJson(String str) => VehicleDeposit.fromJson(json.decode(str));

String vehicleDepositToJson(VehicleDeposit data) => json.encode(data.toJson());

class VehicleDeposit {
    String depositAddress;
    Coordinates depositCoordinates;

    VehicleDeposit({
        required this.depositAddress,
        required this.depositCoordinates,
    });

    factory VehicleDeposit.fromJson(Map<String, dynamic> json) => VehicleDeposit(
        depositAddress: json["depositAddress"],
        depositCoordinates: Coordinates.fromJson(json["depositCoordinates"]),
    );

    Map<String, dynamic> toJson() => {
        "depositAddress": depositAddress,
        "depositCoordinates": depositCoordinates.toJson(),
    };
}

