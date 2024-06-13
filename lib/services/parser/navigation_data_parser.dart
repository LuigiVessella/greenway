import 'package:greenway/dto/navigation_dto.dart';

import 'package:google_polyline_algorithm/src/google_polyline_algorithm.dart';

class NavigationDataParser {
  // Funzione per unire le polyline
  List<String> combinePolylines(NavigationDataDTO data) {
    List<List<num>> latLngsSteps = [];
    List<String> tripPolylines = [];
    String legPolyline = '';

    if (data.routes != null) {
      for (final trip in data.routes!) {
        for (final leg in trip.legs!) {
          latLngsSteps.clear();
          for (final step in leg.steps!) {
            latLngsSteps += (decodePolyline(
                step.geometry!)); // qua ho le coordinate di ogni step
          }
          legPolyline = encodePolyline(latLngsSteps);
          tripPolylines.add(legPolyline);
        }
      }
      print("legs: ${tripPolylines.length}");
    }

    return tripPolylines;
  }

  //Funzione per concatenare i nomi delle strade
  List<String> concatenateRoadNames(NavigationDataDTO data) {
    List<String> tripStreetNames = [];
    //List<String> legStreetsNames = [];
    String legStreetsName = '';

    for (final trip in data.routes!) {
      for (final leg in trip.legs!) {
        legStreetsName = '';
        for (final step in leg.steps!) {
          legStreetsName +=
              '${translateString(step.maneuver!.type)} ${translateString(step.maneuver!.modifier)} ${step.name}\n\n';
        }
        tripStreetNames.add(legStreetsName);
      }
    }

    return tripStreetNames;
  }

  String translateString(String? stringToTranslate) {
    if (stringToTranslate != null) {
      switch (stringToTranslate.toLowerCase()) {
        case 'turn':
          return 'Gira a';
        case 'right':
          return 'Destra per';
        case 'left':
          return 'Sinistra per';
        case 'continue':
          return 'Continua su';
        case 'depart':
          return 'Prendi';
        case 'fork':
          return 'Incrocio a';
        case 'arrive':
          return 'Sei giunto a';
        case 'roundabout':
          return 'Prendi la rotonda';
        case 'slight right':
          return 'a destra per';
        case 'slight left':
          return 'a sinistra per';
        case 'exit roundabout':
          return 'Esci dalla rotonda';
        case 'straight':
          return 'dritto per';
        default:
          return stringToTranslate;
      }
    } else {
      return '';
    }
  }
}
