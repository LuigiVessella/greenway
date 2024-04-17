import 'package:flutter/material.dart';
import 'package:greenway/entity/delivery.dart';

import 'package:greenway/presentation/widgets/add_new_delivery_package.dart';
import 'package:greenway/repositories/delivery_repository.dart';

class AddNewDelivery extends StatefulWidget {
  const AddNewDelivery({super.key});

  @override
  State<AddNewDelivery> createState() => _AddNewDeliveryState();
}

class _AddNewDeliveryState extends State<AddNewDelivery> {
  var resultSenderG, resultReceiverG;

  Delivery newDelivery = Delivery(
      sender: "Mario Rossi",
      senderAddress: "Via Roma",
      receiver: "Beatrice Bianchi",
      receiverAddress: "Via Napoli",
      receiverCoordinates:
          Coordinates(type: "Point", coordinates: [14.275188, 40.860434]),
      weightKg: "1.5");

  List<Delivery> createdDeliveries = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Consegna:'),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
              const SizedBox(
                height: 40,
              ),
              const Text('I pacchi di questa consegna:'),
              SizedBox(
                height: 300,
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: createdDeliveries.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.local_shipping),
                          title: Text(createdDeliveries[index].receiverAddress),
                          subtitle: Text(
                              'da ${createdDeliveries[index].senderAddress}'),
                        ),
                      );
                    }),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              ElevatedButton(
                  onPressed: () {
                    _navigateAndDisplaySelection(context, 'sender');
                  },
                  child: const Text('Aggiungi mittente')),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    _navigateAndDisplaySelection(context, 'receiver');
                  },
                  child: const Text('Aggiungi destinatario')),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    _addNewDelivery();
                  },
                  child: const Text('Invia')),
            ])));
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
            builder: (context) => const AddNewPackage(
                  title: 'Aggiungi mittente',
                )),
      );
    } else if (role == 'receiver') {
      resultReceiver = await Navigator.push(
        context,
        // Create the SelectionScreen in the next step.
        MaterialPageRoute(
            builder: (context) => const AddNewPackage(
                  title: "Aggiungi destinatario",
                )),
      );
    }

    if (resultSender != null) {
      print('sender address: ${resultSender['address']}');
      setState(() {
        resultSenderG = resultSender;
      });
    }

    if (resultReceiver != null) {
      print('receiver address: ${resultReceiver['address']}');
      setState(() {
        resultReceiverG = resultReceiver;
      });
    }
  }

  bool _addNewDelivery() {
    //aggiorno l'oggetto newDelivery creato sopra
    //questa cosa va sistemata in quanto creerò un delivery dto da poter modificare liberamente e solo infine assegnarlo a una delivery
    newDelivery.sender = 'Luigi Vessella';
    newDelivery.receiverAddress = resultReceiverG['address'];
    newDelivery.senderAddress = resultSenderG['address'];

    setState(() {
      createdDeliveries.add(newDelivery);
    });

    DeliveryRepository dv = DeliveryRepository();
    dv.addNewDelivery(newDelivery);
    return true;
  }
}
