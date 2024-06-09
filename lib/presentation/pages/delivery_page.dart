import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenway/config/themes/first_theme.dart';
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

  String senderString = 'Inserisci i dati';
  String receiverString = 'Inserisci i dati';

  NewDeliveryDTO newDeliveryDTO = NewDeliveryDTO();

  List<Delivery> createdDeliveries = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Spedizioni'),
          
          bottom: const PreferredSize(
              preferredSize: Size.zero,
              child: Text('Da qui puoi gestire le tue spedizioni')),
          actions: <Widget>[
            
            IconButton.filledTonal(
                tooltip: 'Programma consegne',
                onPressed: () {
                  _scheduleDeliveries();
                },
                icon: const Icon(Icons.schedule_send))
          ],
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
              const SizedBox(
                height: 40,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                const SizedBox(
                  width: 5,
                ),
                Text(
                  textAlign: TextAlign.right,
                  'Le tue spedizioni:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: firstAppTheme.primaryColor,
                      fontSize: 16),
                )
              ]),
              SizedBox(
                height: 300,
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: createdDeliveries.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.house),
                          title: Text(
                              'A: ${createdDeliveries[index].receiverAddress}'),
                          subtitle: Text(
                            'Da: ${createdDeliveries[index].sender}',
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      );
                    }),
              ),
              const Divider(),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                const SizedBox(
                  width: 5,
                ),
                Text(
                  textAlign: TextAlign.right,
                  'Vuoi spedire?',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: firstAppTheme.primaryColor,
                      fontSize: 16),
                )
              ]),
              const SizedBox(
                height: 30,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Column(children: [
                  OutlinedButton(
                      onPressed: () {
                        _navigateAndDisplaySelection(context, 'sender');
                      },
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [Icon(Icons.info), Text('Dati mittente')])),
                  Text(senderString,
                      style: const TextStyle(fontStyle: FontStyle.italic)),
                ]),
                Column(children: [
                  OutlinedButton(
                      onPressed: () {
                        _navigateAndDisplaySelection(context, 'receiver');
                      },
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.info),
                            Text('Dati destinatario')
                          ])),
                  Text(receiverString,
                      style: const TextStyle(fontStyle: FontStyle.italic)),
                ]),
              ]),
              const SizedBox(
                height: 35,
              ),
              FilledButton(
                  onPressed: () {
                    _addNewDelivery();
                  },
                  child: const SizedBox(width: 110, child:  Text('Invia', textAlign: TextAlign.center,))),
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
        senderString = 'Dati inseriti';
        newDeliveryDTO.sender = resultSender['name'];
        newDeliveryDTO.senderAddress = resultSender['address'];
      });
    }

    if (resultReceiver != null) {
      setState(() {
        receiverString = 'Dati inseriti';
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
    try {
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

      DeliveryRepository dv = DeliveryRepository();
      dv.addNewDelivery(newDelivery);
      return true;
    } on TypeError {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.orange,
          content: Row(children: [
            Icon(Icons.info),
            SizedBox(
              width: 10,
            ),
            Text(
              'Inserisci mittente e destinatario!',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ])));
      return false;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Row(children: [
            Icon(Icons.info),
            SizedBox(
              width: 10,
            ),
            Text('Anomalia ')
          ])));
      return false;
    }
  }

  void _scheduleDeliveries() {
    SystemRepository sr = SystemRepository();
    sr
        .trigDeliverySheduling()
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                backgroundColor: Colors.green,
                content: Row(children: [
                  Icon(Icons.check),
                  Text('Consegne programmate')
                ]))))
        .catchError((error, stackTrace) =>
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.orange,
                content: Row(children: [
                  Icon(Icons.info),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Nessun corriere disponibile ora')
                ]))));
  }
}
