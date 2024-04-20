import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:greenway/dto/navigation_dto.dart';
import 'package:greenway/entity/vehicle/vehicle.dart';
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
    _getNavigationData();

    colors.add(Colors.blue);
    colors.add(Colors.red);
  }

  final VehicleRepository _vr = VehicleRepository();
  final NavigationDataParser dataParser = NavigationDataParser();
  List<Color> colors = [];
  List<String> tripRoute = [];
  String? backTrip = '';
  bool _viewBackTrip = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NavigationDataDTO>(
      future:
          _getNavigationData(), // a previously-obtained Future<String> or null
      builder: (context, snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          tripRoute.addAll(dataParser.combinePolylines(snapshot.data!));
          backTrip = tripRoute.lastOrNull;
          dataParser.concatenateRoadNames(snapshot.data!);
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
                            onPressed: () {},
                            child: const Text('Visualizza marcatori')),
                        ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  showDragHandle: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SizedBox(
                                        height: 300,
                                       
                                        child: Center(
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                              const Text('Modal BottomSheet'),
                                              ElevatedButton(
                                                child: const Text(
                                                    'Close BottomSheet'),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                              ),
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
                initialCenter: LatLng(41.3518, 14.3689),
                initialZoom: 9.2,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.greenway',
                ),
                PolylineLayer(polylines: [
                  Polyline(
                      points: decodePolyline(tripRoute[0]).unpackPolyline(),
                      color: Colors.blue,
                      strokeWidth: 3.0),
                ]),
                Visibility(
                    visible: _viewBackTrip,
                    child: PolylineLayer(polylines: [
                      Polyline(
                          points: decodePolyline(tripRoute[1]).unpackPolyline(),
                          color: Colors.purple,
                          strokeWidth: 2.0)
                    ])),
                CurrentLocationLayer(),
                const MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(40.884837, 14.266262),
                      width: 30,
                      height: 30,
                      child: Icon(Icons.warehouse),
                    ),
                  ],
                ),
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
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
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

  Future<NavigationDataDTO> _getNavigationData() async {
    NavigationDataDTO navData = await _vr.getVehicleRoute('1');

    return navData;
  }
}
