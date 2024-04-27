import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:greenway/dto/navigation_dto.dart';
import 'package:greenway/presentation/widgets/show_trip_info.dart';
import 'package:greenway/repositories/vehicle_repository.dart';
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
    
    _navData = _vr.getVehicleRoute('1');

    colors.add(Colors.blue);
    colors.add(Colors.red);
  }
  

  final VehicleRepository _vr = VehicleRepository();
  final NavigationDataParser dataParser = NavigationDataParser();
  List<Color> colors = [];
  List<String> tripRoute = [];
  List<String> tripStreetNames = [];
  String? backTrip = '';

  late Future<NavigationDataDTO?> _navData;
  bool _viewBackTrip = false;
  bool _viewMarkers = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NavigationDataDTO?>(
      
      future:_navData, 
      builder: (context, snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          
          tripStreetNames.clear();
          tripRoute.clear();
          tripRoute.addAll(dataParser.combinePolylines(snapshot.data!));
          backTrip = tripRoute.lastOrNull;
          tripRoute.removeLast();
          tripStreetNames
              .addAll(dataParser.concatenateRoadNames(snapshot.data!));
          children = <Widget>[
            Row(
              children: [
                SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                      padding: const EdgeInsets.all(8.0),
                      scrollDirection: Axis.horizontal,
                      children: [
                        ElevatedButton(
                            onPressed: () {
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
                            child: const Text('Aggiungi percorso di ritorno')),
                        ElevatedButton(
                            onPressed: () {
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
                            child: const Text('Visualizza marcatori')),
                        ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  showDragHandle: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SizedBox(
                                        height: 400,
                                        child: Center(
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                              TripInfo(
                                                  tripInfo: tripStreetNames),
                                            ])));
                                  });
                            },
                            child: const Text('Visualizza indicazioni'))
                      ],
                    ))
              ],
            ),
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
                PolylineLayer(
                  polylineCulling: true,
                  polylines: tripRoute.asMap().entries.map((entry) {
                    final index = entry.key;
                    final polylineString = entry.value;

                    return Polyline(
                      points: decodePolyline(polylineString).unpackPolyline(),
                      color: colors[index],
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
                          .toList(),
                    )),
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
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
              child: Text('Awaiting result...'),
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
    // TODO: implement dispose
    super.dispose();
  }
}
