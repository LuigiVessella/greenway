import 'package:greenway/entity/delivery.dart';

class DeliveryPackage {
  
    StartingPoint destination;
    String weight;

    DeliveryPackage({
        required this.destination,
        required this.weight,
    });

    factory DeliveryPackage.fromJson(Map<String, dynamic> json) => DeliveryPackage(
        destination: StartingPoint.fromJson(json["destination"]),
        weight: json["weight"],
    );

    Map<String, dynamic> toJson() => {
        "destination": destination.toJson(),
        "weight": weight,
    };
}
