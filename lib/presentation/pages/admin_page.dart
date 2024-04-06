import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greenway/entity/vehicle.dart';
import 'package:greenway/presentation/widgets/add_new_delivery_widget.dart';
import 'package:greenway/repositories/vehicle_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              //...
            },
            heroTag: null,
            child: const Icon(Icons.delete),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () {},
            heroTag: null,
            child: const Icon(Icons.star),
          )
        ],
      ),
      body: Center(
        child: Column(children: <Widget>[
          const SizedBox(
            height: 70,
          ),
          SvgPicture.asset(
            'lib/assets/undraw_delivery_address_re_cjca.svg',
            height: 150,
          ),
          const Text('Benvenuto admin'),
          const Text('Come stai'),
          const SizedBox(
            height: 40,
          ),
          FilledButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const _VehicleInputDetailState()));
            },
            style: const ButtonStyle(
                minimumSize: MaterialStatePropertyAll(Size(200, 50))),
            child: const Text('Add vehicle'),
          ),
          const SizedBox(
            height: 20,
          ),
          FilledButton(
              style: const ButtonStyle(
                  minimumSize: MaterialStatePropertyAll(Size(200, 50))),
              onPressed: () {
               _navigateAndDisplaySelection(context, 'sender');
              },
              child: const Text('Add sender')),
              const SizedBox(height: 20,),
          FilledButton(
              style: const ButtonStyle(
                  minimumSize: MaterialStatePropertyAll(Size(200, 50))),
              onPressed: () {
               _navigateAndDisplaySelection(context, 'receiver');
              },
              child: const Text('Add receiver')),
        ]),
      ),
    );
  }

  Future readToken() async {
    print('ciao');
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token').toString();
    print('token: $token');
  }

  //utilizzo i il Navigator.push in una funzione che ritorna Future in attesa dei risultati della scelta del luogo
  Future<void> _navigateAndDisplaySelection(BuildContext context, String role) async {
    var resultSender, resultReceiver;
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    if(role =='sender'){
       resultSender = await Navigator.push(
        context,
        // Create the SelectionScreen in the next step.
        MaterialPageRoute(
            builder: (context) => const AddNewDelivery(
                  title: "Aggiungi mittente",
                )),
      );
    }
    else if(role == 'receiver'){
         resultReceiver = await Navigator.push(
        context,
        // Create the SelectionScreen in the next step.
        MaterialPageRoute(
            builder: (context) => const AddNewDelivery(
                  title: "Aggiungi destinatario",
                )),
      );
    }

    if (resultReceiver != null) {
      print('destinatario: $resultReceiver');
    }
    
    if (resultSender != null) {
      print('mittente: $resultSender');
    }
  }
}




















//probabilmente questo va spostato in un altro file per pulizia
class _VehicleInputDetailState extends StatefulWidget {
  const _VehicleInputDetailState({super.key});

  @override
  State<_VehicleInputDetailState> createState() =>
      __VehicleInputDetailStateState();
}

class __VehicleInputDetailStateState extends State<_VehicleInputDetailState> {
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
                      batteryNominalCapacity:
                          double.parse(batteryTextController.text),
                      vehicleConsumption:
                          double.parse(vehicleConsumptionTextController.text),
                      currentBatteryCharge:
                          double.parse(currentBatteryChargeTextController.text),
                      maxCapacity:
                          double.parse(maxCapacityTextController.text)));
                },
                child: const Text('crea veicolo'))
          ],
        ),
      ),
    );
  }
}
