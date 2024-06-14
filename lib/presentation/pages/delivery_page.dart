import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:greenway/config/themes/first_theme.dart';
import 'package:greenway/dto/add_delivery_dto.dart';
import 'package:greenway/entity/delivery.dart';

import 'package:greenway/presentation/widgets/add_new_delivery_package.dart';
import 'package:greenway/presentation/widgets/show_shipping_list.dart';
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
          title: const Text('Crea Spedizione'),
          actions: <Widget>[
            IconButton.filledTonal(
                tooltip: 'Programma consegne',
                onPressed: () {
                  _scheduleDeliveries();
                },
                icon: const Icon(Icons.schedule_send))
          ],
        ),
        body: SingleChildScrollView(
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 220,
                      child: AutoSizeText(
                        'Gestisci e crea spedizioni. Poi, pianifica con il tasto in alto a destra.',
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ))
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                const SizedBox(
                  width: 5,
                ),
                Text(
                  textAlign: TextAlign.right,
                  'Spedizioni recenti',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: firstAppTheme.primaryColor,
                      fontSize: 16),
                )
              ]),
              const ShippingListMobile(),
              const Divider(),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                const SizedBox(
                  width: 5,
                ),
                Text(
                  textAlign: TextAlign.right,
                  'Crea una consegna',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: firstAppTheme.primaryColor,
                      fontSize: 16),
                )
              ]),
              const SizedBox(
                height: 30,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(children: [
                      OutlinedButton(
                          onPressed: () {
                            _navigateAndDisplaySelection(context, 'sender');
                          },
                          child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.info),
                                Text('Dati mittente')
                              ])),
                      SizedBox(
                          width: 170,
                          child: AutoSizeText(
                            maxLines: 3,
                            senderString,
                            textAlign: TextAlign.center,
                          )),
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
                      SizedBox(
                          width: 170,
                          child: AutoSizeText(
                              maxLines: 3,
                              receiverString,
                              textAlign: TextAlign.center)),
                    ]),
                  ]),
              const SizedBox(
                height: 35,
              ),
              FilledButton(
                  onPressed: () {
                    _addNewDelivery();
                  },
                  child: const SizedBox(
                      width: 110,
                      child: Text(
                        'Invia',
                        textAlign: TextAlign.center,
                      ))),
            ]))));
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
        senderString =
            'Dati inseriti: ${resultSender['name']},${resultSender['address']} ';
        newDeliveryDTO.sender = resultSender['name'];
        newDeliveryDTO.senderAddress = resultSender['address'];
        newDeliveryDTO.weightKg = resultSender['weight'];
      });
    }

    if (resultReceiver != null) {
      setState(() {
        receiverString =
            'Dati inseriti: ${resultReceiver['name']},${resultReceiver['address']} ';
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

  void _addNewDelivery() {
    Delivery newDelivery = Delivery(
        sender: newDeliveryDTO.sender!,
        senderAddress: newDeliveryDTO.senderAddress!,
        receiver: newDeliveryDTO.receiver!,
        receiverAddress: newDeliveryDTO.receiverAddress!,
        receiverCoordinates: Coordinates(
            type: newDeliveryDTO.receiverCoordinates!.type!,
            coordinates: newDeliveryDTO.receiverCoordinates!.coordinates!),
        weightKg: newDeliveryDTO.weightKg!);

    setState(() {
      createdDeliveries.add(newDelivery);
    });

    DeliveryRepository dv = DeliveryRepository();
    dv.addNewDelivery(newDelivery).then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green,
            content: Row(children: [
              Icon(Icons.info),
              SizedBox(
                width: 10,
              ),
              Text(
                'Consegna inserita',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ])));
      },
    ).catchError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Row(children: [
            Icon(Icons.error),
            SizedBox(
              width: 10,
            ),
            Text('Errore: il deposito esiste già, o anomalia')
          ])));
    }).whenComplete(
      () {
        setState(() {});
      },
    );
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
