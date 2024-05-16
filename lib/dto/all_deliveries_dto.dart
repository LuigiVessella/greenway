import 'package:greenway/dto/delivery_dman_dto.dart';

class AllDeliveriesDTO {
  int? pageNo;
  int? pageSize;
  int? totalElements;
  int? totalPages;
  bool? last;
  List<DeliveryDTO>? deliveries;

  AllDeliveriesDTO(
      {this.pageNo,
      this.pageSize,
      this.totalElements,
      this.totalPages,
      this.last,
      this.deliveries});

  AllDeliveriesDTO.fromJson(Map<String, dynamic> json) {
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
    totalElements = json['totalElements'];
    totalPages = json['totalPages'];
    last = json['last'];
    if (json['content'] != null) {
      deliveries = <DeliveryDTO>[];
      json['content'].forEach((v) {
        deliveries!.add(DeliveryDTO.fromJson(v));
      });
    }
  }
}
