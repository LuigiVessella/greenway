import 'package:flutter/material.dart';
import 'package:greenway/entity/vehicle.dart';
import 'package:greenway/repositories/vehicle_repository.dart';

// ignore: must_be_immutable
class VehiclesListWidget extends StatelessWidget {
  VehiclesListWidget({super.key});

  VehicleRepository vr = VehicleRepository();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Vehicle>>(
      future:
          vr.getAllVehicles(), // Chiama la tua funzione che ritorna il Future
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Vehicle> vehicles = snapshot.data!; // Lista dei veicoli
          return SizedBox(
              height: 250,
              child: ListView.builder(
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  return Card(
                        
                        child: SizedBox(height:50, child:Text(vehicles[index].modelName.toString()), // Esempio
                    // Mostra altre proprietà del veicolo
                  ));
                },
              ));
        } else if (snapshot.hasError) {
          return const Center(
              child: Text('Errore durante il caricamento dei veicoli'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
