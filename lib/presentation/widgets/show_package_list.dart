import 'package:flutter/material.dart';
import 'package:greenway/dto/delivery_dman_dto.dart';
import 'package:greenway/repositories/delivery_repository.dart';
import 'package:greenway/repositories/vehicle_repository.dart';
import 'package:greenway/services/network/logger.dart';

class PackageList extends StatelessWidget {
  const PackageList({super.key});

  @override
  Widget build(BuildContext context) {
    VehicleRepository vr = VehicleRepository();
    DeliveryRepository dr = DeliveryRepository();

    return FutureBuilder<VehicleByDmanDto>(
      future: vr.getVehicleByDeliveryMan(AuthService()
          .getUserInfo!), // Chiama la tua funzione che ritorna il Future
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          VehicleByDmanDto vehicleDTO = snapshot.data!; // Lista dei veicoli

          return SizedBox(
              height: 250,
              child: ListView.builder(
                itemCount: vehicleDTO.deliveries!.length,
                itemBuilder: (context, index) {
                  return Card(
                      semanticContainer: false,
                      elevation: 5.0,
                      child: ExpansionTile(
                          tilePadding: const EdgeInsets.all(7),
                          childrenPadding: const EdgeInsets.all(1.0),
                          title: Text(
                            'Consegna ${vehicleDTO.deliveries![index].id}',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          children: [
                            ListTile(
                              leading: const Icon(Icons.local_post_office),
                              title:
                                  Text(vehicleDTO.deliveries![index].receiver!),
                              subtitle: Text(
                                  'presso: ${vehicleDTO.deliveries![index].receiverAddress}'),
                            ),
                            const Divider(),
                            Text(
                              'Consegna prevista: ${vehicleDTO.deliveries![index].estimatedDeliveryTime}',
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FilledButton(
                                    onPressed: () {
                                      dr.completeDelivery(vehicleDTO
                                          .deliveries![index].id
                                          .toString());
                                    },
                                    child: const Text('Consegnata'))
                              ],
                            )
                          ]));
                },
              ));
        } else if (snapshot.hasError) {
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
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
