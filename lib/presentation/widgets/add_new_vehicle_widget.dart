import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:greenway/entity/vehicle/vehicle.dart';
import 'package:greenway/repositories/vehicle_repository.dart';

class VehicleInputDetail extends StatefulWidget {
  const VehicleInputDetail({super.key});

  @override
  State<VehicleInputDetail> createState() => _VehicleInputDetailState();
}

class _VehicleInputDetailState extends State<VehicleInputDetail> {
  final VehicleRepository vr = VehicleRepository();

  final modelTextController = TextEditingController();
  final maxAutonomyTextController = TextEditingController();
  final maxCapacityTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Informazioni sul veicolo"),
          centerTitle: true,
        ),
        body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(children: [
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: modelTextController,
                decoration: const InputDecoration(
                    labelText: 'Model name:',
                    prefixIcon: Icon(Icons.info),
                    border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: maxAutonomyTextController,
                decoration: const InputDecoration(
                    labelText: 'Battery Capacity (km):',
                    prefixIcon: Icon(Icons.battery_full),
                    border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: maxCapacityTextController,
                decoration: const InputDecoration(
                    labelText: 'Vehicle capacity (kg):',
                    prefixIcon: Icon(Icons.balance),
                    border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    vr
                        .addVehicle(Vehicle(
                          modelName: modelTextController.text,
                          maxAutonomyKm:
                              int.parse(maxAutonomyTextController.text),
                          maxCapacityKg:
                              int.parse(maxCapacityTextController.text),
                        ))
                        .then((value) => ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                backgroundColor: Colors.green,
                                content: Row(children: [
                                  Icon(Icons.abc),
                                  Text('Veicolo aggiunto correttamente')
                                ]))))
                        .then(
                          (value) => Navigator.pop(context),
                        )
                        .catchError((error, stackTrace) =>
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Row(children: [
                                      Icon(Icons.error),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text('Errore: impossibile aggiungere il veicolo')
                                    ]))));
                  },
                  child: const Text('Aggiungi'))
            ])));
  }
}
