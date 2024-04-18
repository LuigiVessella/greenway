// To parse this JSON data, do
//
//     final vehicleDto = vehicleDtoFromJson(jsonString);

import 'dart:convert';

VehicleDto vehicleDtoFromJson(String str) => VehicleDto.fromJson(json.decode(str));

String vehicleDtoToJson(VehicleDto data) => json.encode(data.toJson());

class VehicleDto {
    int pageNo;
    int pageSize;
    int totalElements;
    int totalPages;
    bool last;
    List<Content> content;

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
        content: List<Content>.from(json["content"].map((x) => Content.fromJson(x))),
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

class Content {
    int? id;
    String? modelName;
    int? maxAutonomyKm;
    int? maxCapacityKg;

    Content({
        this.id,
        this.modelName,
        this.maxAutonomyKm,
        this.maxCapacityKg,
    });

    factory Content.fromJson(Map<String, dynamic> json) => Content(
        id: json["id"],
        modelName: json["modelName"],
        maxAutonomyKm: json["maxAutonomyKm"],
        maxCapacityKg: json["maxCapacityKg"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "modelName": modelName,
        "maxAutonomyKm": maxAutonomyKm,
        "maxCapacityKg": maxCapacityKg,
    };
}