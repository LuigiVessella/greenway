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
          legStreetsName += '${step.name} \n';
        }
        tripStreetNames.add(legStreetsName);
      }
    }

    return tripStreetNames;
  }
}
