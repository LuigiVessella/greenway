import 'dart:convert';

import 'package:greenway/dto/navigation_dto.dart'; // Importa la classe contenente DeliveryNavigation

class NavigationDataParser {

  // Funzione per unire le polyline
  String combinePolylines(NavigationDataDto data) {
    String combinedGeometry = '';

    for (final trip in data.routes) {
      for (final leg in trip.legs) {
        for (final step in leg.steps) {
          combinedGeometry += step.geometry;
        }
      }
    }

    return combinedGeometry;
  }

  // Funzione per concatenare i nomi delle strade
  String concatenateRoadNames(NavigationDataDto data) {
    final Set<String> uniqueRoadNames = {};

    for (final trip in data.routes) {
      for (final leg in trip.legs) {
        for (final step in leg.steps) {
          uniqueRoadNames.add(step.name);
        }
      }
    }

    return uniqueRoadNames.join(', ');
  }

  // Esempio d'uso:
  void parseData() {
    String jsonString = '...'; // Il tuo JSON
    NavigationDataDto parsedData = navigationDataDtoFromJson(jsonString);

    final combinedPolyline = combinePolylines(parsedData);
    final concatenatedRoadNames = concatenateRoadNames(parsedData);

    print('Polyline combinata: $combinedPolyline');
    print('Nomi strade concatenati: $concatenatedRoadNames');
  }

}

