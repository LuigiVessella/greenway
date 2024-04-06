// To parse this JSON data, do
//
//     final addresses = addressFromJson(jsonString);

import 'dart:convert';

List<Address> welcomeFromJson(String str) => List<Address>.from(json.decode(str).map((x) => Address.fromJson(x)));

String welcomeToJson(List<Address> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Address {
    int? placeId;
    String? licence;
    OsmType? osmType;
    int? osmId;
    String? lat;
    String? lon;
    Category? category;
    Type? type;
    int? placeRank;
    double? importance;
    Addresstype? addresstype;
    String? name;
    String? displayName;
    List<String>? boundingbox;

    Address({
        this.placeId,
        this.licence,
        this.osmType,
        this.osmId,
        this.lat,
        this.lon,
        this.category,
        this.type,
        this.placeRank,
        this.importance,
        this.addresstype,
        this.name,
        this.displayName,
        this.boundingbox,
    });

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        placeId: json["place_id"],
        licence: json["licence"],
        osmType: osmTypeValues.map[json["osm_type"]],
        osmId: json["osm_id"],
        lat: json["lat"],
        lon: json["lon"],
        category: categoryValues.map[json["category"]],
        type: typeValues.map[json["type"]],
        placeRank: json["place_rank"],
        importance: json["importance"].toDouble(),
        addresstype: addresstypeValues.map[json["addresstype"]],
        name: json["name"],
        displayName: json["display_name"],
        boundingbox: List<String>.from(json["boundingbox"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "place_id": placeId,
        "licence": licence,
        "osm_type": osmTypeValues.reverse[osmType],
        "osm_id": osmId,
        "lat": lat,
        "lon": lon,
        "category": categoryValues.reverse[category],
        "type": typeValues.reverse[type],
        "place_rank": placeRank,
        "importance": importance,
        "addresstype": addresstypeValues.reverse[addresstype],
        "name": name,
        "display_name": displayName,
        "boundingbox": List<dynamic>.from(boundingbox!.map((x) => x)),
    };
}

enum Addresstype {
    ROAD
}

final addresstypeValues = EnumValues({
    "road": Addresstype.ROAD
});

enum Category {
    HIGHWAY
}

final categoryValues = EnumValues({
    "highway": Category.HIGHWAY
});

enum OsmType {
    WAY
}

final osmTypeValues = EnumValues({
    "way": OsmType.WAY
});

enum Type {
    SECONDARY,
    TERTIARY
}

final typeValues = EnumValues({
    "secondary": Type.SECONDARY,
    "tertiary": Type.TERTIARY
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
