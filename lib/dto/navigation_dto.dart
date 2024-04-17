// To parse this JSON data, do
//
//     final navigationDataDto = navigationDataDtoFromJson(jsonString);

import 'dart:convert';

NavigationDataDto navigationDataDtoFromJson(String str) => NavigationDataDto.fromJson(json.decode(str));

String navigationDataDtoToJson(NavigationDataDto data) => json.encode(data.toJson());

class NavigationDataDto {
    String code;
    List<Route> routes;
    List<Waypoint> waypoints;

    NavigationDataDto({
       required this.code,
       required this.routes,
       required this.waypoints,
    });

    factory NavigationDataDto.fromJson(Map<String, dynamic> json) => NavigationDataDto(
        code: json["code"],
        routes: List<Route>.from(json["routes"].map((x) => Route.fromJson(x))),
        waypoints: List<Waypoint>.from(json["waypoints"].map((x) => Waypoint.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "routes": List<dynamic>.from(routes.map((x) => x.toJson())),
        "waypoints": List<dynamic>.from(waypoints.map((x) => x.toJson())),
    };
}

class Route {
    String geometry;
    List<Leg> legs;
    String weightName;
    double weight;
    double duration;
    double distance;

    Route({
       required this.geometry,
       required this.legs,
       required this.weightName,
       required this.weight,
       required this.duration,
       required this.distance,
    });

    factory Route.fromJson(Map<String, dynamic> json) => Route(
        geometry: json["geometry"],
        legs: List<Leg>.from(json["legs"].map((x) => Leg.fromJson(x))),
        weightName: json["weight_name"],
        weight: json["weight"].toDouble(),
        duration: json["duration"].toDouble(),
        distance: json["distance"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "geometry": geometry,
        "legs": List<dynamic>.from(legs.map((x) => x.toJson())),
        "weight_name": weightName,
        "weight": weight,
        "duration": duration,
        "distance": distance,
    };
}

class Leg {
    List<Step> steps;
    String summary;
    double weight;
    double duration;
    double distance;

    Leg({
       required this.steps,
       required this.summary,
       required this.weight,
       required this.duration,
       required this.distance,
    });

    factory Leg.fromJson(Map<String, dynamic> json) => Leg(
        steps: List<Step>.from(json["steps"].map((x) => Step.fromJson(x))),
        summary: json["summary"],
        weight: json["weight"].toDouble(),
        duration: json["duration"].toDouble(),
        distance: json["distance"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "steps": List<dynamic>.from(steps.map((x) => x.toJson())),
        "summary": summary,
        "weight": weight,
        "duration": duration,
        "distance": distance,
    };
}

class Step {
    String geometry;
    Maneuver maneuver;
    Mode mode;
    DrivingSide drivingSide;
    String name;
    List<Intersection> intersections;
    double weight;
    double duration;
    double distance;
    String rotaryName;

    Step({
        required this.geometry,
        required this.maneuver,
        required this.mode,
        required this.drivingSide,
        required this.name,
        required this.intersections,
        required this.weight,
        required this.duration,
        required this.distance,
        required this.rotaryName,
    });

    factory Step.fromJson(Map<String, dynamic> json) => Step(
        geometry: json["geometry"],
        maneuver: Maneuver.fromJson(json["maneuver"]),
        mode: modeValues.map[json["mode"]]!,
        drivingSide: drivingSideValues.map[json["driving_side"]]!,
        name: json["name"],
        intersections: List<Intersection>.from(json["intersections"].map((x) => Intersection.fromJson(x))),
        weight: json["weight"].toDouble(),
        duration: json["duration"].toDouble(),
        distance: json["distance"].toDouble(),
        rotaryName: json["rotary_name"],
    );

    Map<String, dynamic> toJson() => {
        "geometry": geometry,
        "maneuver": maneuver.toJson(),
        "mode": modeValues.reverse[mode],
        "driving_side": drivingSideValues.reverse[drivingSide],
        "name": name,
        "intersections": List<dynamic>.from(intersections.map((x) => x.toJson())),
        "weight": weight,
        "duration": duration,
        "distance": distance,
        "rotary_name": rotaryName,
    };
}

enum DrivingSide {
    LEFT,
    RIGHT,
    SLIGHT_LEFT,
    SLIGHT_RIGHT,
    STRAIGHT
}

final drivingSideValues = EnumValues({
    "left": DrivingSide.LEFT,
    "right": DrivingSide.RIGHT,
    "slight left": DrivingSide.SLIGHT_LEFT,
    "slight right": DrivingSide.SLIGHT_RIGHT,
    "straight": DrivingSide.STRAIGHT
});

class Intersection {
    int out;
    List<bool> entry;
    List<int> bearings;
    List<double> location;
    int intersectionIn;

    Intersection({
       required this.out,
       required this.entry,
       required this.bearings,
       required this.location,
       required this.intersectionIn,
    });

    factory Intersection.fromJson(Map<String, dynamic> json) => Intersection(
        out: json["out"],
        entry: List<bool>.from(json["entry"].map((x) => x)),
        bearings: List<int>.from(json["bearings"].map((x) => x)),
        location: List<double>.from(json["location"].map((x) => x.toDouble())),
        intersectionIn: json["in"],
    );

    Map<String, dynamic> toJson() => {
        "out": out,
        "entry": List<dynamic>.from(entry.map((x) => x)),
        "bearings": List<dynamic>.from(bearings.map((x) => x)),
        "location": List<dynamic>.from(location.map((x) => x)),
        "in": intersectionIn,
    };
}

class Maneuver {
    int bearingAfter;
    int bearingBefore;
    List<double> location;
    DrivingSide modifier;
    String type;
    int exit;

    Maneuver({
       required this.bearingAfter,
       required this.bearingBefore,
       required this.location,
       required this.modifier,
       required this.type,
       required this.exit,
    });

    factory Maneuver.fromJson(Map<String, dynamic> json) => Maneuver(
        bearingAfter: json["bearing_after"],
        bearingBefore: json["bearing_before"],
        location: List<double>.from(json["location"].map((x) => x.toDouble())),
        modifier: drivingSideValues.map[json["modifier"]]!,
        type: json["type"],
        exit: json["exit"],
    );

    Map<String, dynamic> toJson() => {
        "bearing_after": bearingAfter,
        "bearing_before": bearingBefore,
        "location": List<dynamic>.from(location.map((x) => x)),
        "modifier": drivingSideValues.reverse[modifier],
        "type": type,
        "exit": exit,
    };
}

enum Mode {
    DRIVING
}

final modeValues = EnumValues({
    "driving": Mode.DRIVING
});

class Waypoint {
    String hint;
    double distance;
    String name;
    List<double> location;

    Waypoint({
       required this.hint,
       required this.distance,
       required this.name,
       required this.location,
    });

    factory Waypoint.fromJson(Map<String, dynamic> json) => Waypoint(
        hint: json["hint"],
        distance: json["distance"].toDouble(),
        name: json["name"],
        location: List<double>.from(json["location"].map((x) => x.toDouble())),
    );

    Map<String, dynamic> toJson() => {
        "hint": hint,
        "distance": distance,
        "name": name,
        "location": List<dynamic>.from(location.map((x) => x)),
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
