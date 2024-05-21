import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:greenway/config/themes/first_theme.dart';
import 'package:greenway/dto/navigation_dto.dart';
import 'package:greenway/presentation/widgets/show_trip_info.dart';
import 'package:greenway/repositories/vehicle_repository.dart';
import 'package:greenway/services/network/logger.dart';
import 'package:greenway/services/parser/navigation_data_parser.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/other/unpack_polyline.dart';

class NavigationWidget extends StatefulWidget {
  const NavigationWidget({super.key});

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  @override
  void initState() {
    super.initState();

    _navData = _vr
        .getVehicleByDeliveryMan(AuthService().getUserInfo!)
        .then((value) => _vr.getVehicleRoutes(value.id.toString()));

    colors.add(Colors.purple);
    colors.add(Colors.red);
    colors.add(Colors.orange);
  }

  final VehicleRepository _vr = VehicleRepository();
  final NavigationDataParser dataParser = NavigationDataParser();
  List<Color> colors = [];
  List<String> tripRoute = [];
  List<String> tripStreetNames = [];
  String? backTrip = '';

  int currentNavDataIndex = 0;

  late Future<List<NavigationDataDTO>> _navData;
  bool _viewBackTrip = false;
  bool _viewMarkers = true;
  bool _elevationRoute = false;

  String _routeText = 'Standard';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NavigationDataDTO>>(
      future: _navData,
      builder: (context, snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          tripStreetNames.clear();
          tripRoute.clear();

          //qui invece cambierà dinamicamente in base all current index
          tripRoute.addAll(
              dataParser.combinePolylines(snapshot.data![currentNavDataIndex]));

          backTrip = tripRoute.lastOrNull;
          tripRoute.removeLast();
          tripStreetNames.addAll(dataParser
              .concatenateRoadNames(snapshot.data![currentNavDataIndex]));
          children = <Widget>[
            // ignore: sized_box_for_whitespace
            Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  scrollDirection: Axis.horizontal,
                  children: [
                    Switch(
                      // This bool value toggles the switch.
                      value: _elevationRoute,
                      activeColor: firstAppTheme.primaryColor,
                      onChanged: (bool value) {
                        // This is called when the user toggles the switch.
                        setState(() {
                          _elevationRoute = value;
                          setState(() {
                            if (value == false) {
                              _routeText = 'Standard';
                            } else {
                              _routeText = 'Elevation';
                            }
                            currentNavDataIndex == 0
                                ? currentNavDataIndex = 1
                                : currentNavDataIndex = 0;
                          });
                        });
                      },
                    ),
                    Container(
                        alignment: Alignment.center, child: Text(_routeText)),
                    const SizedBox(
                      width: 3,
                    ),
                    FilterChip(
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black87),
                      label: const Text(
                        'Visualizza ritorno',
                      ),
                      selected: _viewBackTrip,
                      onSelected: (bool selected) {
                        if (backTrip != null && _viewBackTrip != true) {
                          setState(() {
                            _viewBackTrip = true;
                          });
                        } else if (_viewBackTrip != false) {
                          setState(() {
                            _viewBackTrip = false;
                          });
                        }
                      },
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    FilterChip(
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black87),
                      label: const Text(
                        'Punti di consegna',
                      ),
                      selected: _viewMarkers,
                      onSelected: (bool selected) {
                        if (_viewMarkers != true) {
                          setState(() {
                            _viewMarkers = true;
                          });
                        } else {
                          setState(() {
                            _viewMarkers = false;
                          });
                        }
                      },
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    const VerticalDivider(),
                    ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              enableDrag: true,
                              showDragHandle: true,
                              context: context,
                              builder: (BuildContext context) {
                                return SingleChildScrollView(
                                    child: Center(
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Durata: ${Duration(seconds: snapshot.data![currentNavDataIndex].routes![0].duration!.floor()).inHours}h e '
                                                '${Duration(seconds: snapshot.data![currentNavDataIndex].routes![0].duration!.floor() % 3600).inMinutes}min'
                                                ' (${(snapshot.data![currentNavDataIndex].routes![0].distance!.round() / 1000).toStringAsFixed(2)}km)',
                                                style: TextStyle(
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 18,
                                                    color: firstAppTheme
                                                        .primaryColor,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ))
                                        ],
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.all(9),
                                          child: Text(
                                              'Il percorso mostrato è stato calcolato considerando l\' elevazione del territorio',
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                              ))),
                                      const Divider(),
                                      TripInfo(tripInfo: tripStreetNames),
                                    ])));
                              });
                        },
                        child: const Text('Visualizza indicazioni'))
                  ],
                )),
            Expanded(
                child: FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(41.353153, 14.355927),
                initialZoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.greenway',
                ),
                Visibility(
                    visible: !_elevationRoute,
                    child: PolylineLayer(polylines: [
                      Polyline(
                          points: decodePolyline(
                                  snapshot.data![1].routes![0].geometry!)
                              .unpackPolyline(),
                          color: Colors.blue.shade200,
                          strokeWidth: 3.0)
                    ])),
                PolylineLayer(
                  polylineCulling: true,
                  polylines: tripRoute.asMap().entries.map((entry) {
                    final index = entry.key;
                    final polylineString = entry.value;

                    return Polyline(
                      points: decodePolyline(polylineString).unpackPolyline(),
                      color: colors.elementAtOrNull(index) ?? Colors.red,
                      strokeWidth: 3.0,
                    );
                  }).toList(),
                ),
                Visibility(
                    visible: _viewBackTrip,
                    child: PolylineLayer(polylines: [
                      Polyline(
                          points: decodePolyline(backTrip!).unpackPolyline(),
                          color: Colors.green,
                          strokeWidth: 3.0)
                    ])),
                CurrentLocationLayer(
                  style: const LocationMarkerStyle(
                    marker: DefaultLocationMarker(
                      child: Icon(
                        Icons.navigation,
                        color: Colors.white,
                      ),
                    ),
                    markerSize: Size(40, 40),
                    markerDirection: MarkerDirection.heading,
                  ),
                ),
                Visibility(
                    visible: _viewMarkers,
                    child: MarkerLayer(
                        markers: tripRoute
                            .map((polylineString) => Marker(
                                  point: decodePolyline(polylineString)
                                      .unpackPolyline()
                                      .last,
                                  width: 30,
                                  height: 30,
                                  child: const Icon(Icons.location_pin),
                                ))
                            .toList())),
                Visibility(
                    visible: _viewMarkers,
                    child: MarkerLayer(markers: [
                      Marker(
                        point: decodePolyline(backTrip!).unpackPolyline().last,
                        width: 30,
                        height: 30,
                        child: IconButton(
                          icon: const Icon(Icons.warehouse),
                          onPressed: () {},
                          tooltip: 'Il veicolo parte da qui',
                        ),
                      ),
                    ])),
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'GreenWay Team x Unina x OpenStreetMap',
                      onTap: () => launchUrl(
                          Uri.parse('https://openstreetmap.org/copyright')),
                    ),
                  ],
                ),
              ],
            ))
          ];
        } else if (snapshot.hasError) {
          children = <Widget>[
            const Icon(
              Icons.info_outline_rounded,
              color: Colors.orange,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Info: ${snapshot.error}'),
            ),
          ];
        } else {
          children = const <Widget>[
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Sto caricando la mappa...'),
            ),
          ];
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
