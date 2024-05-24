import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:greenway/dto/delivery_dman_dto.dart';
import 'package:greenway/dto/vehicle_dto.dart';

import 'package:greenway/presentation/widgets/web_widget/elevation_chart.dart';
import 'package:greenway/repositories/vehicle_repository.dart';
import 'package:greenway/services/network/logger.dart';

final VehicleRepository vr = VehicleRepository();

class VehicleListAdminWidget extends StatefulWidget {
  const VehicleListAdminWidget({super.key});

  @override
  State<VehicleListAdminWidget> createState() => _VehicleListAdminWidgetState();
}

class _VehicleListAdminWidgetState extends State<VehicleListAdminWidget> {
  late Future<VehicleDto> _vehicles;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _vehicles = vr.getAllVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Expanded(child: Text('I tuoi veicoli: ')),
          const Text('Aggiorna'),
          IconButton(
              enableFeedback: true,
              tooltip: 'Aggiorna lista veicoli',
              onPressed: () {
                _vehicles = vr.getAllVehicles();
                setState(() {});
              },
              icon: const Icon(Icons.update)),
        ],
      ),
      FutureBuilder<VehicleDto>(
        future: _vehicles, // Chiama la tua funzione che ritorna il Future
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            VehicleDto vehicleDTO = snapshot.data!; // Lista dei veicoli

            return SizedBox(
                height: 250,
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
                                        'lib/assets/electric_icon.svg',
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(width: 20,),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: 
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(vehicleDTO
                                                .content![index].modelName!),
                                            Text(
                                                'carico massimo: ${vehicleDTO.content![index].maxCapacityKg}kg'),
                                          ],
                                        ),
                                      )
                                    ]))
                              ]));
                    }));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                  'Errore durante il caricamento dei veicoli ${snapshot.error}'),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      )
    ]);
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
                              subtitle: Text(
                                  'Carico massimo: ${vehicleDTO.maxCapacityKg}kg\nNon è previsto rifornimento'),
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
                                  FilledButton(
                                      onPressed: () {
                                        vr.putLeaveVehicle(
                                            vehicleDTO.id.toString());
                                      },
                                      child: const Text('Rientra')),
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
