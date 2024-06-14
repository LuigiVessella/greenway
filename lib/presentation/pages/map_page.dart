import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greenway/config/themes/first_theme.dart';
import 'package:greenway/dto/navigation_dto.dart';
import 'package:greenway/presentation/widgets/show_trip_info.dart';
import 'package:greenway/repositories/vehicle_repository.dart';
import 'package:greenway/services/network/logging/logger.dart';
import 'package:greenway/services/parser/navigation_data_parser.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/other/unpack_polyline.dart';

class NavigationWidget extends StatefulWidget {
  const NavigationWidget({super.key, required this.vehicleID});
  final int vehicleID;

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  @override
  void initState() {
    super.initState();

    _navData = kIsWeb
        ? _vr.getVehicleRoutes(widget.vehicleID.toString())
        : _vr
            .getVehicleByDeliveryMan(AuthService().getUserInfo!)
            .then((value) => _vr.getVehicleRoutes(value.id.toString()));
  }

  final VehicleRepository _vr = VehicleRepository();
  final NavigationDataParser dataParser = NavigationDataParser();

  List<String> tripRoute = [];
  List<Widget> tripStreetNames = [];
  String? backTrip = '';

  int currentNavDataIndex = 0;

  late Future<List<NavigationDataDTO>> _navData;
  bool _viewBackTrip = true;
  bool _viewMarkers = true;
  bool _elevationRoute = false;

  String duration = '';

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

          duration = calculateDurance(snapshot);

          children = <Widget>[
            Expanded(
                child: Stack(children: [
              FlutterMap(
                options: const MapOptions(
                  initialCenter: LatLng(41.353153, 14.355927),
                  initialZoom: 15,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.greenway',
                  ),
                  Visibility(
                      visible: !_elevationRoute,
                      child: PolylineLayer(polylines: [
                        Polyline(
                            points: decodePolyline(
                                    snapshot.data![1].routes![0].geometry!)
                                .unpackPolyline(),
                            color: const Color.fromARGB(208, 39, 36, 36),
                            strokeWidth: 5.0)
                      ])),
                  PolylineLayer(
                    polylineCulling: true,
                    polylines: tripRoute.asMap().entries.map((entry) {
                      final polylineString = entry.value;
                      return Polyline(
                        points: decodePolyline(polylineString).unpackPolyline(),
                        color: firstAppTheme.primaryColor,
                        strokeWidth: 5.0,
                      );
                    }).toList(),
                  ),
                  Visibility(
                      visible: _viewBackTrip,
                      child: PolylineLayer(polylines: [
                        Polyline(
                            points: decodePolyline(backTrip!).unpackPolyline(),
                            color: const Color.fromARGB(199, 76, 175, 79),
                            strokeWidth: 5.0)
                      ])),
                  CurrentLocationLayer(
                    style: const LocationMarkerStyle(
                      marker: DefaultLocationMarker(
                        child: Icon(
                          Icons.navigation,
                          color: Colors.white,
                        ),
                      ),
                      markerSize: Size(30, 30),
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
                                    child: const Icon(Icons.location_pin,
                                        color: Colors.blue),
                                  ))
                              .toList())),
                  Visibility(
                      visible: _viewMarkers,
                      child: MarkerLayer(markers: [
                        Marker(
                          point:
                              decodePolyline(backTrip!).unpackPolyline().last,
                          child: IconButton(
                            icon: const Icon(
                              Icons.warehouse,
                              color: Colors.black,
                            ),
                            onPressed: () {},
                            tooltip: 'Il veicolo parte da qui',
                          ),
                        ),
                      ])),
                  RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution(
                        'GreenWay Team & Unina on OpenStreetMap',
                        onTap: () => launchUrl(
                            Uri.parse('https://openstreetmap.org/copyright')),
                      ),
                    ],
                  ),
                ],
              ),
              Align(
                  alignment: Alignment.topRight,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        IconButton.filledTonal(
                            onPressed: () {
                              _showMyDialog();
                            },
                            icon:
                                SvgPicture.asset('lib/assets/legend_icon.svg')),
                        IconButton.filledTonal(
                          tooltip: 'Visualizza ritorno',
                          icon: const Icon(
                            Icons.layers,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                                useSafeArea: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                      builder:
                                          (context, setModalState) => SizedBox(
                                                  child: Column(
                                                children: [
                                                  const Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                          'Ottimizza percorso:',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))
                                                    ],
                                                  ),
                                                  Row(children: [
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 15),
                                                        child: Column(
                                                            children: [
                                                              SizedBox(
                                                                width: 80,
                                                                height: 80,
                                                                child: Card(
                                                                  shape: _elevationRoute
                                                                      ? StadiumBorder(
                                                                          side: BorderSide(
                                                                          color:
                                                                              firstAppTheme.primaryColor,
                                                                          width:
                                                                              2.0,
                                                                        ))
                                                                      : null,
                                                                  child: IconButton(
                                                                      icon: (SvgPicture.asset('lib/assets/elevation_icon_profile.svg')),
                                                                      onPressed: () => {
                                                                            if (_elevationRoute ==
                                                                                false)
                                                                              {
                                                                                setState(() {
                                                                                  _elevationRoute = true;
                                                                                  currentNavDataIndex == 0 ? currentNavDataIndex = 1 : currentNavDataIndex = 0;
                                                                                })
                                                                              },
                                                                            setModalState(() {}),
                                                                          }),
                                                                ),
                                                              ),
                                                              const Text(
                                                                'Elevation',
                                                              )
                                                            ])),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 15),
                                                        child: Column(
                                                            children: [
                                                              SizedBox(
                                                                width: 80,
                                                                height: 80,
                                                                child: Card(
                                                                  shape: !_elevationRoute
                                                                      ? const StadiumBorder(
                                                                          side: BorderSide(
                                                                          color:
                                                                              Colors.green,
                                                                          width:
                                                                              2.0,
                                                                        ))
                                                                      : null,
                                                                  child: IconButton(
                                                                      icon: (SvgPicture.asset('lib/assets/standard_icon_profile.svg')),
                                                                      onPressed: () => {
                                                                            if (_elevationRoute ==
                                                                                true)
                                                                              {
                                                                                setState(() {
                                                                                  _elevationRoute = false;
                                                                                  currentNavDataIndex == 0 ? currentNavDataIndex = 1 : currentNavDataIndex = 0;
                                                                                }),
                                                                                setModalState(() {})
                                                                              }
                                                                          }),
                                                                ),
                                                              ),
                                                              const Text(
                                                                  'Standard')
                                                            ]))
                                                  ]),
                                                  const Divider(),
                                                  const Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Informazioni da mostrare:',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                  Row(children: [
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    FilterChip(
                                                        label: const Text(
                                                            'Percorso Ritorno'),
                                                        selected: _viewBackTrip,
                                                        onSelected:
                                                            (bool selected) {
                                                          if (backTrip !=
                                                                  null &&
                                                              _viewBackTrip !=
                                                                  true) {
                                                            setState(() {
                                                              _viewBackTrip =
                                                                  true;
                                                            });
                                                          } else if (_viewBackTrip !=
                                                              false) {
                                                            setState(() {
                                                              _viewBackTrip =
                                                                  false;
                                                            });
                                                          }
                                                          setModalState(() {});
                                                        }),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    FilterChip(
                                                        label: const Text(
                                                            'Punti consegna'),
                                                        selected: _viewMarkers,
                                                        onSelected:
                                                            (bool selected) {
                                                          if (_viewMarkers !=
                                                              true) {
                                                            setState(() {
                                                              _viewMarkers =
                                                                  true;
                                                            });
                                                          } else if (_viewMarkers !=
                                                              false) {
                                                            setState(() {
                                                              _viewMarkers =
                                                                  false;
                                                            });
                                                          }
                                                          setModalState(() {});
                                                        })
                                                  ])
                                                ],
                                              )));
                                });
                          },
                        ),
                      ])),
              Padding(
                  padding: const EdgeInsets.only(bottom: 10, right: 10),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton.extended(
                      label: const Text('Indicazioni'),
                      icon: const Icon(Icons.arrow_upward),
                      onPressed: () {
                        showModalBottomSheet(
                            useSafeArea: true,
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
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              duration,
                                              style: TextStyle(
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 18,
                                                  color: firstAppTheme
                                                      .primaryColor,
                                                  fontWeight: FontWeight.w800),
                                            ))
                                      ],
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.all(9),
                                        child: _elevationRoute
                                            ? const Text(
                                                'Il percorso mostrato e le info qui presenti si riferiscono al percorso ottimizzato di GreenWay',
                                                style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                ))
                                            : const Text(
                                                'Il percorso mostrato e le info qui presenti si riferiscono al percorso standard di OSMR',
                                                style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                ))),
                                    const Divider(),
                                    TripInfo(tripInfo: tripStreetNames),
                                  ])));
                            });
                      },
                    ),
                  ))
            ]))
          ];
        } else if (snapshot.hasError) {
          children = [
            const Icon(
              CupertinoIcons.info_circle,
              color: Colors.orange,
              size: 60,
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Il veicolo non è in transito',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ];
        } else {
          children = const <Widget>[
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Sto caricando la mappa...', style: TextStyle(color: Colors.black, fontSize: 18)),
            ),
          ];
        }
        return Center(
          child : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        );
      },
    );
  }

  String calculateDurance(var snapshot) {
    return 'Durata viaggio: ${Duration(seconds: snapshot.data![currentNavDataIndex].routes![0].duration!.floor()).inHours}h e '
        '${Duration(seconds: snapshot.data![currentNavDataIndex].routes![0].duration!.floor() % 3600).inMinutes}min'
        ' (${(snapshot.data![currentNavDataIndex].routes![0].distance!.round() / 1000).toStringAsFixed(2)}km)';
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Legenda mappa'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Container(
                    width: 35,
                    height: 10,
                    decoration: BoxDecoration(
                        color: firstAppTheme.primaryColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        )),
                  ),
                  const Text('Percorso principale'),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Container(
                    width: 35,
                    height: 10,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(199, 76, 175, 79),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        )),
                  ),
                  const Text('Percorso ritorno'),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Container(
                    width: 35,
                    height: 10,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(208, 39, 36, 36),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        )),
                  ),
                  const Text('Percorso alternativo GreenWay'),
                ]),
                const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_pin,
                        color: Colors.blue,
                      ),
                      Text('Punti consegna'),
                    ]),
                const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warehouse_outlined,
                        color: Colors.black,
                      ),
                      Text('Magazzino/Partenza'),
                    ]),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
