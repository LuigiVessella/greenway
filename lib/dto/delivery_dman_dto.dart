import 'dart:convert';
import 'package:greenway/entity/delivery.dart';

List<DeliveryDmanDto> deliveriesByDmanFromJson(String str) => List<DeliveryDmanDto>.from(json.decode(str).map((x) => DeliveryDmanDto.fromJson(x)));
DeliveryDmanDto deliveryDmanDtoFromJson(String str) => DeliveryDmanDto.fromJson(json.decode(str));

String deliveryDmanDtoToJson(DeliveryDmanDto data) => json.encode(data.toJson());

class DeliveryDmanDto {
    int pageNo;
    int pageSize;
    int totalElements;
    int totalPages;
    bool last;
    List<Delivery> deliveries;

    DeliveryDmanDto({
       required this.pageNo,
       required this.pageSize,
       required this.totalElements,
       required this.totalPages,
       required this.last,
       required this.deliveries,
    });

    factory DeliveryDmanDto.fromJson(Map<String, dynamic> json) => DeliveryDmanDto(
        pageNo: json["pageNo"],
        pageSize: json["pageSize"],
        totalElements: json["totalElements"],
        totalPages: json["totalPages"],
        last: json["last"],
        deliveries: List<Delivery>.from(json["content"].map((x) => Delivery.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "pageNo": pageNo,
        "pageSize": pageSize,
        "totalElements": totalElements,
        "totalPages": totalPages,
        "last": last,
        "content": List<dynamic>.from(deliveries.map((x) => x.toJson())),
    };
}
