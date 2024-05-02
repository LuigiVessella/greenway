import 'package:flutter/material.dart';
import 'package:greenway/dto/vehicle_dto.dart';
import 'package:greenway/repositories/vehicle_repository.dart';

class VehicleListWeb extends StatelessWidget {
  const VehicleListWeb({super.key});

  @override
  Widget build(BuildContext context) {
    VehicleRepository vr = VehicleRepository();
    return FutureBuilder<VehicleDto>(
      future:
          vr.getAllVehicles(), // Chiama la tua funzione che ritorna il Future
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          VehicleDto vehicleDTO = snapshot.data!; // Lista dei veicoli

          return Container(
            margin: const EdgeInsets.all(8.0),
          
              child: ListView.builder(
                itemCount: vehicleDTO.content!.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: ExpansionTile(
                          tilePadding: const EdgeInsets.all(15),
                          childrenPadding: const EdgeInsets.all(9.0),
                          title: Text(
                              'Il tuo veicolo: ${vehicleDTO.content![index].id}'),
                          children: [
                        ListTile(
                          leading: const Icon(Icons.local_shipping),
                          title: Text(vehicleDTO.content![index].modelName!),
                          subtitle: Text(
                              'max capacity: ${vehicleDTO.content![index].maxCapacityKg}kg'),
                        ),
                        TextButton(
                            onPressed: () {},
                            child: const Text('Visualizza dati elevazione')),
                        TextButton(
                            onPressed: () {},
                            child: const Text('Stato spedizione'))
                      ]));
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
