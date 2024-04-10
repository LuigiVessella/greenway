// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greenway/entity/delivery.dart';
import 'package:greenway/entity/delivery_package.dart';
import 'package:greenway/presentation/widgets/add_new_delivery_widget.dart';
import 'package:greenway/presentation/widgets/add_new_vehicle_widget.dart';
import 'package:greenway/repositories/delivery_repository.dart';


//import 'package:shared_preferences/shared_preferences.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  var resultSenderG, resultReceiverG;

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
                      builder: (context) => const VehicleInputDetail()));
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
          const SizedBox(
            height: 20,
          ),
          FilledButton(
              style: const ButtonStyle(
                  minimumSize: MaterialStatePropertyAll(Size(200, 50))),
              onPressed: () {
                _navigateAndDisplaySelection(context, 'receiver');
              },
              child: const Text('Add receiver')),
          FilledButton(
              style: const ButtonStyle(
                  minimumSize: MaterialStatePropertyAll(Size(200, 50))),
              onPressed: () {
                _addDelivery();
              },
              child: const Text('Add delivery')),
        ]),
      ),
    );
  }

  void _addDelivery() {
    Coordinates start =
        Coordinates(type: 'Point', coordinates: resultSenderG);
    Coordinates destination =
        Coordinates(type: 'Point', coordinates: resultReceiverG);

    // ignore: prefer_collection_literals
    Delivery newDelivery = Delivery(vehicleId: '1', deliveryMan: null, deliveryPackages: List.empty(growable: true), depositCoordinates: start);

    DeliveryPackage newPackage = DeliveryPackage(
        receiverCoordinates: destination, weight: '1.0');

    newDelivery.addNewPackage(newPackage);

    DeliveryRepository dv = DeliveryRepository();
    dv.AddNewDelivery(newDelivery);
  }

  //utilizzo i il Navigator.push in una funzione che ritorna Future in attesa dei risultati della scelta del luogo
  Future<void> _navigateAndDisplaySelection(
      BuildContext context, String role) async {
    var resultSender, resultReceiver;
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    if (role == 'sender') {
      resultSender = await Navigator.push(
        context,
        // Create the SelectionScreen in the next step.
        MaterialPageRoute(
            builder: (context) => const AddNewDelivery(
                  title: "Aggiungi mittente",
                )),
      );
    } else if (role == 'receiver') {
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
      setState(() {
        resultReceiverG = resultReceiver;
      });
    }

    if (resultSender != null) {
      setState(() {
        resultSenderG = resultSender;
      });
    }
  }
}
