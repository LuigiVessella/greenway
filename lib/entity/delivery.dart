// To parse this JSON data, do
//
//     final delivery = deliveryFromJson(jsonString);

import 'dart:convert';

Delivery deliveryFromJson(String str) => Delivery.fromJson(json.decode(str));

String deliveryToJson(Delivery data) => json.encode(data.toJson());

class Delivery {
    String sender;
    String senderAddress;
    String receiver;
    String receiverAddress;
    Coordinates receiverCoordinates;
    String weightKg;

    Delivery({
       required this.sender,
       required this.senderAddress,
       required this.receiver,
       required this.receiverAddress,
       required this.receiverCoordinates,
       required this.weightKg,
    });

    factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
        sender: json["sender"],
        senderAddress: json["senderAddress"],
        receiver: json["receiver"],
        receiverAddress: json["receiverAddress"],
        receiverCoordinates: Coordinates.fromJson(json["receiverCoordinates"]),
        weightKg: json["weightKg"],
    );

    Map<String, dynamic> toJson() => {
        "sender": sender,
        "senderAddress": senderAddress,
        "receiver": receiver,
        "receiverAddress": receiverAddress,
        "receiverCoordinates": receiverCoordinates.toJson(),
        "weightKg": weightKg,
    };
}

class Coordinates {
    String type;
    List<double> coordinates;

    Coordinates({
        required this.type,
        required this.coordinates,
    });

    factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
        type: json["type"],
        coordinates: List<double>.from(json["coordinates"].map((x) => x.toDouble())),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
    };
}