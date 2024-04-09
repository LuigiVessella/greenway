import 'package:flutter/material.dart';
import 'package:greenway/entity/vehicle.dart';
import 'package:greenway/repositories/vehicle_repository.dart';

class VehicleInputDetailState extends StatefulWidget {
  const VehicleInputDetailState({super.key});

  @override
  State<VehicleInputDetailState> createState() =>
      _VehicleInputDetailStateState();
}

class _VehicleInputDetailStateState extends State<VehicleInputDetailState> {
  final VehicleRepository vr = VehicleRepository();

  final modelTextController = TextEditingController();
  final batteryTextController = TextEditingController();
  final vehicleConsumptionTextController = TextEditingController();
  final currentBatteryChargeTextController = TextEditingController();
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
              controller: batteryTextController,
              decoration: const InputDecoration(
                  labelText: 'Battery Capacity:',
                  prefixIcon: Icon(Icons.api_rounded),
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: vehicleConsumptionTextController,
              decoration: const InputDecoration(
                  labelText: 'Vehicle Consumption:',
                  prefixIcon: Icon(Icons.api_rounded),
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: currentBatteryChargeTextController,
              decoration: const InputDecoration(
                  labelText: 'Current Battery Charge',
                  prefixIcon: Icon(Icons.api_rounded),
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: maxCapacityTextController,
              decoration: const InputDecoration(
                  labelText: 'Max capacity:',
                  prefixIcon: Icon(Icons.api_rounded),
                  border: OutlineInputBorder()),
            ),
            FilledButton(
                onPressed: () {
                  vr.addVehicle(Vehicle(
                      model: modelTextController.text,
                      batteryNominalCapacity: batteryTextController.text,
                      vehicleConsumption: vehicleConsumptionTextController.text,
                      currentBatteryCharge:
                          currentBatteryChargeTextController.text,
                      maxCapacity: maxCapacityTextController.text));
                },
                child: const Text('crea veicolo'))
          ],
        ),
      ),
    );
  }
}
