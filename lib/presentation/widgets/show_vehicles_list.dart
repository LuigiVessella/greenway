import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:greenway/dto/delivery_dman_dto.dart';
import 'package:greenway/dto/vehicle_dto.dart';

import 'package:greenway/presentation/widgets/web_widget/elevation_chart.dart';
import 'package:greenway/repositories/vehicle_repository.dart';
import 'package:greenway/services/network/logging/logger.dart';
import 'package:http/http.dart';

final VehicleRepository vr = VehicleRepository();

class VehicleListAdminWidget extends StatefulWidget {
  const VehicleListAdminWidget({super.key});

  @override
  State<VehicleListAdminWidget> createState() => _VehicleListAdminWidgetState();
}

class _VehicleListAdminWidgetState extends State<VehicleListAdminWidget> {
  late Future<VehicleDto> _vehicles;

  int _pageCounter = 0;
  int _totalPages = 0;

  @override
  void initState() {
    super.initState();

    _vehicles = vr.getAllVehicles(_pageCounter);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<VehicleDto>(
      future: _vehicles, // Chiama la tua funzione che ritorna il Future
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          VehicleDto vehicleDTO = snapshot.data!;
          if (vehicleDTO.totalElements! < 1) {
            return Center(
                child: SizedBox(
                    height: 250,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            CupertinoIcons.info,
                            size: 50,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Non ci sono veicoli al momento. Puoi aggiungerne uno cliccando in basso.',
                            textAlign: TextAlign.center,
                          ),
                          IconButton.outlined(
                              enableFeedback: true,
                              tooltip: 'Aggiorna lista veicoli',
                              onPressed: () {
                                setState(() {
                                  _vehicles = vr.getAllVehicles(_pageCounter);
                                });
                              },
                              icon: const Icon(CupertinoIcons.refresh))
                        ])));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            // Lista dei veicoli
            if (vehicleDTO.totalPages! > 0) {
              _totalPages = vehicleDTO.totalPages!;
              print('ci sono ${vehicleDTO.totalPages!} pagine');
            }
          }
          return Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Expanded(
                    child: Text('Veicoli presenti al deposito: ',
                        style: TextStyle(fontSize: kIsWeb ? 18 : 14))),
                const Text('Pagina:'),
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (_pageCounter > 0) {
                          _pageCounter--;
                        }
                      });
                    },
                    icon: const Icon(Icons.remove)),
                Text(
                  '$_pageCounter',
                  style: const TextStyle(fontSize: 18.0),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (_pageCounter < _totalPages - 1) _pageCounter++;
                      });
                    },
                    icon: const Icon(
                      Icons.add,
                    )),
                IconButton.filledTonal(
                    enableFeedback: true,
                    tooltip: 'Aggiorna lista veicoli',
                    onPressed: () {
                      setState(() {
                        _vehicles = vr.getAllVehicles(_pageCounter);
                      });
                    },
                    icon: const Icon(CupertinoIcons.refresh)),
              ],
            ),
            SizedBox(
                height: 250,
                child: Scrollbar(
                    child: ListView.builder(
                        itemCount: vehicleDTO.content!.length,
                        itemBuilder: (context, index) {
                          return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              // Define how the card's content should be clipped
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    // Add padding around the row widget
                                    Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Row(children: [
                                          SvgPicture.asset(
                                            'lib/assets/delivery_truck_icon.svg',
                                            height: 40,
                                            width: 40,
                                            fit: BoxFit.cover,
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(vehicleDTO.content![index]
                                                    .modelName!),
                                                Text(
                                                    'carico massimo: ${vehicleDTO.content![index].maxCapacityKg}kg'),
                                              ],
                                            ),
                                          )
                                        ]))
                                  ]));
                        })))
          ]);
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
                'Errore durante il caricamento dei veicoli ${snapshot.error}'),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class VehicleListDmanWidget extends StatelessWidget {
  const VehicleListDmanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<VehicleByDmanDto>(
      future: vr.getVehicleByDeliveryMan(AuthService()
          .getUserInfo!), // Chiama la tua funzione che ritorna il Future
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          VehicleByDmanDto vehicleDTO = snapshot.data!; // Lista dei veicoli

          return SizedBox(
              height: 250,
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      // Define how the card's content should be clipped
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: ExpansionTile(
                          tilePadding: const EdgeInsets.all(7),
                          childrenPadding: const EdgeInsets.all(1),
                          title: const Text(
                            'Veicolo in viaggio: ',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          children: [
                            ListTile(
                              leading: const Icon(Icons.local_shipping),
                              title: Text(vehicleDTO.modelName!.toUpperCase()),
                              subtitle: Row(children: [
                                const Icon(
                                  Icons.battery_charging_full,
                                  color: Colors.green,
                                ),
                                Text(
                                    'Carico massimo: ${vehicleDTO.maxCapacityKg}kg\nNon è previsto rifornimento')
                              ]),
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      //const Test(),
                                                      ElevationChart(
                                                          vehicleID: vehicleDTO
                                                              .id
                                                              .toString()),
                                                ));
                                          },
                                          child: const Text(
                                            'PROFILO ELEVAZIONE',
                                            textAlign: TextAlign.center,
                                          ))),
                                  FilledButton.tonal(
                                      onPressed: () {
                                        vr.putLeaveVehicle(
                                            vehicleDTO.id.toString());
                                      },
                                      child: const Text('Termina giro')),
                                ]),
                          ]));
                },
              ));
        } else if (snapshot.hasError) {
          if (snapshot.error.toString().contains('401')) {
            return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  const Icon(
                    Icons.info_outline_rounded,
                    color: Colors.red,
                    size: 60,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('La tua sessione è scaduta'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: FilledButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/');
                        },
                        child: const Text('Login again')),
                  ),
                ]));
          } else {
            return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  const Icon(
                    Icons.info_outline_rounded,
                    color: Colors.orange,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Info: ${snapshot.error}'),
                  ),
                ]));
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
