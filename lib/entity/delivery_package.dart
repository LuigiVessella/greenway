import 'package:greenway/entity/delivery.dart';

class DeliveryPackage {
    String? sender;
    String? senderAddress;
    String? receiver;
    String? receiverAddress;
    Coordinates? receiverCoordinates;
    String? weight;

    DeliveryPackage({
        this.sender,
        this.senderAddress,
        this.receiver,
        this.receiverAddress,
        this.receiverCoordinates,
        this.weight,
    });

    factory DeliveryPackage.fromJson(Map<String, dynamic> json) => DeliveryPackage(
        sender: json["sender"],
        senderAddress: json["senderAddress"],
        receiver: json["receiver"],
        receiverAddress: json["receiverAddress"],
        receiverCoordinates: Coordinates.fromJson(json["receiverCoordinates"]),
        weight: json["weight"],
    );

    Map<String, dynamic> toJson() => {
        "sender": sender,
        "senderAddress": senderAddress,
        "receiver": receiver,
        "receiverAddress": receiverAddress,
        "receiverCoordinates": receiverCoordinates!.toJson(),
        "weight": weight,
    };
}