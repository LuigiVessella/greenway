import 'dart:convert';

import 'package:greenway/entity/vehicle/vehicle.dart';



VehicleDto vehicleDtoFromJson(String str) => VehicleDto.fromJson(json.decode(str));

String vehicleDtoToJson(VehicleDto data) => json.encode(data.toJson());

class VehicleDto {
    int pageNo;
    int pageSize;
    int totalElements;
    int totalPages;
    bool last;
    List<Vehicle> content;

    VehicleDto({
        required this.pageNo,
        required this.pageSize,
        required this.totalElements,
        required this.totalPages,
        required this.last,
        required this.content,
    });

    factory VehicleDto.fromJson(Map<String, dynamic> json) => VehicleDto(
        pageNo: json["pageNo"],
        pageSize: json["pageSize"],
        totalElements: json["totalElements"],
        totalPages: json["totalPages"],
        last: json["last"],
        content: List<Vehicle>.from(json["content"].map((x) => Vehicle.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "pageNo": pageNo,
        "pageSize": pageSize,
        "totalElements": totalElements,
        "totalPages": totalPages,
        "last": last,
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
    };
}