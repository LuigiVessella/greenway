import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  List<Widget> concatenateRoadNames(NavigationDataDTO data) {
    Widget textRow = const Text('');
    List<Widget> tripStreetNames = [];
    //List<String> legStreetsNames = [];
    String legStreetsName = '';

    for (final trip in data.routes!) {
      for (final leg in trip.legs!) {
        legStreetsName = '';
        for (final step in leg.steps!) {
          legStreetsName =
              '${translateString(step.maneuver!.type)} ${translateString(step.maneuver!.modifier)} ${step.name}';
          textRow = Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(padding: const EdgeInsets.only(left: 5, right: 10), child:
                getIconBasedOnDirection(step.maneuver!.modifier)),
                
                SizedBox(
                    width: 250,
                    child: AutoSizeText(
                      textAlign: TextAlign.left,
                      minFontSize: 15,
                      legStreetsName,
                      maxLines: 2,
                    )),
                  Align (alignment: Alignment.centerRight,child:  Text(' ${step.distance ?? ''}m', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w700),))
              ]);

          tripStreetNames.add(textRow);
        }
      }
    }

    return tripStreetNames;
  }

  Widget getIconBasedOnDirection(String? direction) {
    if (direction == null) {
      return SvgPicture.asset('lib/assets/directions_icon/turn_right_icon.svg');
    } else {
      switch (direction.toLowerCase()) {
        case 'right':
          return SvgPicture.asset(
              'lib/assets/directions_icon/turn_right_icon.svg');
        case 'ahead':
           return const Icon(Icons.location_pin);
        case 'left':
          return SvgPicture.asset(
              'lib/assets/directions_icon/turn_left_icon.svg');
        case 'continue':
          return SvgPicture.asset('lib/assets/directions_icon/road_icon.svg');
        case 'depart':
          return SvgPicture.asset('lib/assets/directions_icon/road_icon.svg');

        case 'roundabout':
          return SvgPicture.asset(
              'lib/assets/directions_icon/roundabout_icon.svg');

        default:
          return SvgPicture.asset('lib/assets/directions_icon/road_icon.svg');
      }
    }
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
          return 'destra per';
        case 'slight left':
          return 'sinistra per';
        case 'exit roundabout':
          return 'Esci dalla rotonda ';
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
