import 'package:flutter/material.dart';
import 'package:greenway/entity/vehicle/vehicle.dart';
import 'package:greenway/dto/vehicle_dto.dart';
import 'package:greenway/repositories/vehicle_repository.dart';

// ignore: must_be_immutable
class VehiclesListWidget extends StatelessWidget {
  VehiclesListWidget({super.key});

  VehicleRepository vr = VehicleRepository();

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
                itemCount: vehicleDTO.content.length,
                itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.local_shipping),
                          title: Text(vehicleDTO.content[index].modelName),
                          subtitle: Text('max capacity: ${vehicleDTO.content[index].maxCapacityKg}kg'),
                      ));
                },
              ));
        } else if (snapshot.hasError) {
          return  Center(
              child: Text('Errore durante il caricamento dei veicoli ${snapshot.error}'),);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
