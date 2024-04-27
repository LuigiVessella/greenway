
import 'dart:convert';

import 'package:greenway/entity/delivery.dart';

Vehicle vehicleFromJson(String str) => Vehicle.fromJson(json.decode(str));

String vehicleToJson(Vehicle data) => json.encode(data.toJson());

class Vehicle {
  num? id;
  String? modelName;
  num? maxAutonomyKm;
  num? maxCapacityKg;

  Vehicle({this.id, this.modelName, this.maxAutonomyKm, this.maxCapacityKg});

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    modelName = json['modelName'];
    maxAutonomyKm = json['maxAutonomyKm'];
    maxCapacityKg = json['maxCapacityKg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['modelName'] = modelName;
    data['maxAutonomyKm'] = maxAutonomyKm;
    data['maxCapacityKg'] = maxCapacityKg;
    return data;
  }
}