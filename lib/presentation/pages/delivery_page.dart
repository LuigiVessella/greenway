import 'package:flutter/material.dart';
import 'package:greenway/dto/add_delivery_dto.dart';
import 'package:greenway/entity/delivery.dart';

import 'package:greenway/presentation/widgets/add_new_delivery_package.dart';
import 'package:greenway/repositories/delivery_repository.dart';
import 'package:greenway/repositories/system_repository.dart';

class AddNewDelivery extends StatefulWidget {
  const AddNewDelivery({super.key});

  @override
  State<AddNewDelivery> createState() => _AddNewDeliveryState();
}

class _AddNewDeliveryState extends State<AddNewDelivery> {
  var resultSenderG, resultReceiverG;

  NewDeliveryDTO newDeliveryDTO = NewDeliveryDTO();

  List<Delivery> createdDeliveries = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Genera etichetta'),
          actions: <Widget>[
            IconButton(
              tooltip: 'Programma consegne',
              onPressed:(){ _scheduleDeliveries();},
             icon: const Icon(Icons.schedule))
          ],
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
              const SizedBox(
                height: 40,
              ),
              const Text('Le tue spedizioni:', style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(
                height: 300,
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: createdDeliveries.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.local_shipping),
                          title: Text('A: ${createdDeliveries[index].receiverAddress}'),
                          subtitle: Text(
                              'Da: ${createdDeliveries[index].sender}'),
                        ),
                      );
                    }),
              ),
              
              const Divider(),
              const Text('Vuoi spedire?', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 40,),
              ElevatedButton(
                  onPressed: () {
                    _navigateAndDisplaySelection(context, 'sender');
                  },
                  child: const Text('Aggiungi mittente')),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    _navigateAndDisplaySelection(context, 'receiver');
                  },
                  child: const Text('Aggiungi destinatario')),
              const SizedBox(
                height: 10,
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
      setState(() {
        newDeliveryDTO.sender = resultSender['name'];
        newDeliveryDTO.senderAddress = resultSender['address'];
      });
    }

    if (resultReceiver != null) {
      setState(() {
        newDeliveryDTO.receiver = resultReceiver['name'];
        newDeliveryDTO.receiverAddress = resultReceiver['address'];
        newDeliveryDTO.receiverCoordinates = NewCoordinatesDTO(
          type: "Point",
          coordinates: [
            resultReceiver['lon'],
            resultReceiver['lat'],
          ],
        );
      });
    }
  }

  bool _addNewDelivery() {
    Delivery newDelivery = Delivery(
        sender: newDeliveryDTO.sender!,
        senderAddress: newDeliveryDTO.senderAddress!,
        receiver: newDeliveryDTO.receiver!,
        receiverAddress: newDeliveryDTO.receiverAddress!,
        receiverCoordinates: Coordinates(
            type: newDeliveryDTO.receiverCoordinates!.type!,
            coordinates: newDeliveryDTO.receiverCoordinates!.coordinates!),
        weightKg: '1.0');

    setState(() {
      createdDeliveries.add(newDelivery);
    });

    //TODO: aggiungere un controllo sulla risposta del metodo
    DeliveryRepository dv = DeliveryRepository();
    dv.addNewDelivery(newDelivery);
    return true;
  }

  void _scheduleDeliveries() {
    SystemRepository sr = SystemRepository();
    sr.trigDeliverySheduling();
  }
}
