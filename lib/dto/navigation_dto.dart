class NavigationDataDTO {
	String? code;
  String? geometry; 
	List<Routes>? routes;
	List<Waypoints>? waypoints;
  List<dynamic>? elevations;

	NavigationDataDTO({this.code, this.routes, this.waypoints});

	NavigationDataDTO.fromJson(Map<String, dynamic> json) {
    geometry = json['geometry'];
		code = json['code'];
		if (json['routes'] != null) {
			routes = <Routes>[];
			json['routes'].forEach((v) { routes!.add(Routes.fromJson(v)); });
		}
		if (json['waypoints'] != null) {
			waypoints = <Waypoints>[];
			json['waypoints'].forEach((v) { waypoints!.add(Waypoints.fromJson(v)); });
		}
    elevations = json['elevations'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['code'] = code;
		if (routes != null) {
      data['routes'] = routes!.map((v) => v.toJson()).toList();
    }
		if (waypoints != null) {
      data['waypoints'] = waypoints!.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class Routes {
	String? geometry;
	List<Legs>? legs;
	String? weightName;
	num? weight;
	num? duration;
	num? distance;

	Routes({this.geometry, this.legs, this.weightName, this.weight, this.duration, this.distance});

	Routes.fromJson(Map<String, dynamic> json) {
		geometry = json['geometry'];
		if (json['legs'] != null) {
			legs = <Legs>[];
			json['legs'].forEach((v) { legs!.add(Legs.fromJson(v)); });
		}
		weightName = json['weight_name'];
		weight = json['weight'];
		duration = json['duration'];
		distance = json['distance'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['geometry'] = geometry;
		if (legs != null) {
      data['legs'] = legs!.map((v) => v.toJson()).toList();
    }
		data['weight_name'] = weightName;
		data['weight'] = weight;
		data['duration'] = duration;
		data['distance'] = distance;
		return data;
	}
}

class Legs {
	List<Steps>? steps;
	String? summary;
	num? weight;
	num? duration;
	num? distance;

	Legs({this.steps, this.summary, this.weight, this.duration, this.distance});

	Legs.fromJson(Map<String, dynamic> json) {
		if (json['steps'] != null) {
			steps = <Steps>[];
			json['steps'].forEach((v) { steps!.add(Steps.fromJson(v)); });
		}
		summary = json['summary'];
		weight = json['weight'];
		duration = json['duration'];
		distance = json['distance'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		if (steps != null) {
      data['steps'] = steps!.map((v) => v.toJson()).toList();
    }
		data['summary'] = summary;
		data['weight'] = weight;
		data['duration'] = duration;
		data['distance'] = distance;
		return data;
	}
}

class Steps {
	String? geometry;
	Maneuver? maneuver;
	String? mode;
	String? drivingSide;
	String? name;
	List<Intersections>? intersections;
	num? weight;
	num? duration;
	num? distance;
	String? rotaryName;
	String? ref;
	String? destinations;

	Steps({this.geometry, this.maneuver, this.mode, this.drivingSide, this.name, this.intersections, this.weight, this.duration, this.distance, this.rotaryName, this.ref, this.destinations});

	Steps.fromJson(Map<String, dynamic> json) {
		geometry = json['geometry'];
		maneuver = json['maneuver'] != null ? Maneuver.fromJson(json['maneuver']) : null;
		mode = json['mode'];
		drivingSide = json['driving_side'];
		name = json['name'];
		if (json['intersections'] != null) {
			intersections = <Intersections>[];
			json['intersections'].forEach((v) { intersections!.add(Intersections.fromJson(v)); });
		}
		weight = json['weight'];
		duration = json['duration'];
		distance = json['distance'];
		rotaryName = json['rotary_name'];
		ref = json['ref'];
		destinations = json['destinations'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['geometry'] = geometry;
		if (maneuver != null) {
      data['maneuver'] = maneuver!.toJson();
    }
		data['mode'] = mode;
		data['driving_side'] = drivingSide;
		data['name'] = name;
		if (intersections != null) {
      data['intersections'] = intersections!.map((v) => v.toJson()).toList();
    }
		data['weight'] = weight;
		data['duration'] = duration;
		data['distance'] = distance;
		data['rotary_name'] = rotaryName;
		data['ref'] = ref;
		data['destinations'] = destinations;
		return data;
	}
}

class Maneuver {
	num? bearingAfter;
	num? bearingBefore;
	List<num>? location;
	String? modifier;
	String? type;
	num? exit;

	Maneuver({this.bearingAfter, this.bearingBefore, this.location, this.modifier, this.type, this.exit});

	Maneuver.fromJson(Map<String, dynamic> json) {
		bearingAfter = json['bearing_after'];
		bearingBefore = json['bearing_before'];
		location = json['location'].cast<num>();
		modifier = json['modifier'];
		type = json['type'];
		exit = json['exit'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['bearing_after'] = bearingAfter;
		data['bearing_before'] = bearingBefore;
		data['location'] = location;
		data['modifier'] = modifier;
		data['type'] = type;
		data['exit'] = exit;
		return data;
	}
}

class Intersections {
	num? out;
	List<bool>? entry;
	List<int>? bearings;
	List<num>? location;
	num? intersectionIn;

	Intersections({this.out, this.entry, this.bearings, this.location, this.intersectionIn});

	Intersections.fromJson(Map<String, dynamic> json) {
		out = json['out'];
		entry = json['entry'].cast<bool>();
		bearings = json['bearings'].cast<int>();
		location = json['location'].cast<num>();
		intersectionIn = json['in'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['out'] = out;
		data['entry'] = entry;
		data['bearings'] = bearings;
		data['location'] = location;
		data['in'] = intersectionIn;
		return data;
	}
}

class Waypoints {
	String? hint;
	num? distance;
	String? name;
	List<num>? location;

	Waypoints({this.hint, this.distance, this.name, this.location});

	Waypoints.fromJson(Map<String, dynamic> json) {
		hint = json['hint'];
		distance = json['distance'];
		name = json['name'];
		location = json['location'].cast<num>();
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['hint'] = hint;
		data['distance'] = distance;
		data['name'] = name;
		data['location'] = location;
		return data;
	}
}