import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:greenway/dto/delivery_dman_dto.dart';
import 'package:greenway/entity/vehicle/vehicle.dart';
import 'package:greenway/dto/vehicle_dto.dart';
import 'package:greenway/presentation/pages/login_page.dart';
import 'package:greenway/repositories/vehicle_repository.dart';
import 'package:greenway/services/network/logger.dart';

final VehicleRepository vr = VehicleRepository();

class VehicleListAdminWidget extends StatelessWidget {
  const VehicleListAdminWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<VehicleDto>(
      future:
          vr.getAllVehicles(), // Chiama la tua funzione che ritorna il Future
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          VehicleDto vehicleDTO = snapshot.data!; // Lista dei veicoli

          return SizedBox(
              height: 250,
              child: ListView.builder(
                itemCount: vehicleDTO.content!.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                    leading: const Icon(Icons.local_shipping),
                    title: Text(vehicleDTO.content![index].modelName!),
                    subtitle: Text(
                        'max capacity: ${vehicleDTO.content![index].maxCapacityKg}kg'),
                  ));
                },
              ));
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
                      elevation: 5.0,
                      child: ExpansionTile(
                          tilePadding: const EdgeInsets.all(15),
                          childrenPadding: const EdgeInsets.all(9.0),
                          title: Text('Il tuo veicolo: ${vehicleDTO.id}'),
                          children: [
                            ListTile(
                              leading: const Icon(Icons.local_shipping),
                              title: Text(vehicleDTO.modelName!),
                              subtitle: Text(
                                  'max capacity: ${vehicleDTO.maxCapacityKg}kg'),
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FilledButton(
                                      onPressed: () {},
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
