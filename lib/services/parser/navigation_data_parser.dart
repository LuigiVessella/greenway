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
                Padding(
                    padding: const EdgeInsets.only(left: 5, right: 10),
                    child: getIconBasedOnDirection2(
                        '${step.maneuver!.modifier} ${step.maneuver!.type}')),
                Expanded(
                    child: SizedBox(
                        width: 250,
                        child: AutoSizeText(
                          textAlign: TextAlign.left,
                          minFontSize: 15,
                          legStreetsName,
                          maxLines: 2,
                        ))),
                Expanded(
                    child: Align(
                  alignment: Alignment.centerRight,
                  child: (step.distance! < 1000)
                      ? Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Text(
                            ' ${step.distance}m',
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ))
                      : Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Text(
                            '${(step.distance! / 1000).round()}km',
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          )),
                ))
              ]);

          tripStreetNames.add(textRow);
        }
      }
    }

    return tripStreetNames;
  }

  Widget getIconBasedOnDirection2(String? direction) {
    if (direction == null) {
      return SvgPicture.asset('lib/assets/directions_icon/turn_right_icon.svg');
    } else {
      switch (direction.toLowerCase()) {
        case 'right turn':
          return const Icon(Icons.turn_right);
        case 'sharp left continue':
          return const Icon(Icons.turn_sharp_left);
        case 'straight roundabout':
          return const Icon(Icons.straight);
        case 'slight right exit roundabout':
          return const Icon(Icons.roundabout_right);
        case 'slight left exit roundabout':
          return const Icon(Icons.roundabout_left);
        case 'right roundabout':
          return const Icon(Icons.roundabout_right);
        case 'left roundabout':
          return const Icon(Icons.roundabout_left);
        case 'roundabout':
          return SvgPicture.asset(
              'lib/assets/directions_icon/roundabout_icon.svg');
        default:
          if (direction.contains('left')) {
            return const Icon(Icons.turn_left);
          } else if (direction.contains('right')) {
            return const Icon(Icons.turn_right);
          } else if (direction.contains('uturn')) {
            return const Icon(Icons.u_turn_right);
          } else if (direction.contains('depart')) {
            return const Icon(CupertinoIcons.car);
          } else if (direction.contains('arrive')) {
            return const Icon(CupertinoIcons.pin);
          } else if (direction.contains('roundabout')) {
            return SvgPicture.asset(
                'lib/assets/directions_icon/roundabout_icon.svg');
          } else {
            return const Icon(Icons.straight_outlined);
          }
      }
    }
  }

  String translateString(String? stringToTranslate) {
    if (stringToTranslate != null) {
      switch (stringToTranslate.toLowerCase()) {
        case 'turn':
          return 'Svolta';
        case 'continue':
          return 'Proseguire';
        case 'new name':
          return 'Cambio nome strada';
        case 'depart':
          return 'Partenza';
        case 'arrive':
          return 'Arrivo';
        case 'merge':
          return 'Immettersi';
        case 'ramp':
          return 'Raccordo'; // Deprecated, use on_ramp or off_ramp
        case 'on ramp':
          return 'Imboccare raccordo';
        case 'off ramp':
          return 'Uscire dal raccordo';
        case 'fork':
          return 'Bifurcazione';
        case 'end':
          return 'Fine strada';
        case 'use lane':
          return 'Utilizzare corsia'; // Deprecated, replaced by lanes
        case 'roundabout':
          return 'Rotonda';
        case 'rotary':
          return 'Traffico rotatorio';
        case 'roundabout turn':
          return 'Svolta a rotonda';
        case 'notification':
          return 'Avviso';
        case 'exit roundabout':
          return 'Uscita da rotonda';
        case 'exit rotary':
          return 'Uscita da traffico rotatorio';
        case 'uturn':
          return 'Inversione a U';
        case 'left':
          return 'a sinistra';
        case 'right':
          return 'a destra';
        case 'straight':
          return 'dritto';
        case 'sharp left':
          return 'bruscamente a sinistra';
        case 'sharp right':
          return 'bruscamente a destra';
        case 'slight left':
          return 'leggermente a sinistra';
        case 'slight right':
          return 'leggermente a destra';
        case 'roundabout left':
          return 'rotonda a sinistra';
        case 'roundabout right':
          return 'rotonda a destra';
        case 'exit left':
          return 'uscita a sinistra';
        case 'exit right':
          return 'uscita a destra';
        case 'exit':
          return 'esci';
        case 'exit straight':
          return 'uscita dritta';
        case 'continue left':
          return 'proseguire a sinistra';
        case 'continue right':
          return 'proseguire a destra';
        case 'continue straight':
          return 'proseguire dritto';

        default:
          return stringToTranslate;
      }
    } else {
      return '';
    }
  }
}
