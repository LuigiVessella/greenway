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
                  prefixIcon: Icon(Icons.info),
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: maxCapacityTextController,
              decoration: const InputDecoration(
                  labelText: 'Vehicle capacity (kg):',
                  prefixIcon: Icon(Icons.info),
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  try{
                  vr.addVehicle(Vehicle(
                    modelName: modelTextController.text,
                    maxAutonomyKm: int.parse(maxAutonomyTextController.text),
                    maxCapacityKg: int.parse(maxCapacityTextController.text),
                  ));
                  }catch(e){
                    print('assicurati di aver inserito i dati');
                    
                  }

                  Navigator.pop(context);
                },
                
                child: const Text('Aggiungi'))
          ],
        ),
      ),
    );
  }
}
