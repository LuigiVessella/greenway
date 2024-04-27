// To parse this JSON data, do
//
//     final vehicleDto = vehicleDtoFromJson(jsonString);

import 'dart:convert';

import 'package:greenway/entity/vehicle/vehicle.dart';

class VehicleDto {
  int? pageNo;
  int? pageSize;
  int? totalElements;
  int? totalPages;
  bool? last;
  List<Vehicle>? content;

  VehicleDto(
      {this.pageNo,
      this.pageSize,
      this.totalElements,
      this.totalPages,
      this.last,
      this.content});

  VehicleDto.fromJson(Map<String, dynamic> json) {
    
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
    totalElements = json['totalElements'];
    totalPages = json['totalPages'];
    last = json['last'];
    if (json['content'] != null) {
      content = <Vehicle>[];
      json['content'].forEach((v) {
        content!.add(Vehicle.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pageNo'] = pageNo;
    data['pageSize'] = pageSize;
    data['totalElements'] = totalElements;
    data['totalPages'] = totalPages;
    data['last'] = last;
    if (content != null) {
      data['content'] = content!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
