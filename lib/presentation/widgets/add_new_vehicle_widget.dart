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
        title: const Text("Vehicle data"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: modelTextController,
              decoration: const InputDecoration(
                  labelText: 'Model name:',
                  prefixIcon: Icon(Icons.api_rounded),
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: maxAutonomyTextController,
              decoration: const InputDecoration(
                  labelText: 'Battery Capacity (km):',
                  prefixIcon: Icon(Icons.api_rounded),
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: maxCapacityTextController,
              decoration: const InputDecoration(
                  labelText: 'Vehicle capacity (kg):',
                  prefixIcon: Icon(Icons.api_rounded),
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            FilledButton(
                onPressed: () {
                  vr.addVehicle(Vehicle(
                    modelName: modelTextController.text,
                    maxAutonomyKm: double.parse(maxAutonomyTextController.text),
                    maxCapacityKg: double.parse(maxCapacityTextController.text),
                  ));
                },
                child: const Text('crea veicolo'))
          ],
        ),
      ),
    );
  }
}
