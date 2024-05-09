// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greenway/components/components.dart';
import 'package:greenway/presentation/pages/delivery_page.dart';
import 'package:greenway/presentation/widgets/add_new_vehicle_widget.dart';
import 'package:greenway/presentation/widgets/show_vehicles_list.dart';
import 'package:greenway/repositories/delivery_repository.dart';


//import 'package:shared_preferences/shared_preferences.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  var resultSenderG, resultReceiverG;
  DeliveryRepository dr = DeliveryRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Home Page'),
          actions: [
            IconButton(
              icon: const Icon(Icons.warehouse),
              tooltip: "Aggiungi punto deposito",
              onPressed: () {
                dr
                    .addDepotPoint()
                    .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.green,
                                content: Row(children: [
                          Icon(Icons.abc),
                          Text('Punto deposito creato')
                        ]))))
                    .catchError((error, stackTrace) =>
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                backgroundColor: Colors.red,
                                content: Row(children: [
                                  Icon(Icons.error),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Errore: il deposito esiste già, o anomalia')
                                ]))));
              },
            )
          ],
        ),
        body: PopScope(
            canPop: false,
            onPopInvoked: (bool didPop) {
              if (didPop) {
                return;
              }
              showBackDialog(context);
            },
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  SvgPicture.asset(
                    'lib/assets/undraw_delivery_address_re_cjca.svg',
                    height: 150,
                  ),
                  const Text(
                    'Benvenuto admin',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 30,
                    child: Text(
                      "I tuoi veicoli:",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  updateList(),
                  const Divider(),
                  Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const VehicleInputDetail()));
                          },
                          child: const Text('Aggiungi veicolo'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AddNewDelivery()));
                            },
                            child: const Text('Spedizioni')),
                      ]))
                ]))));
  }

  Widget updateList() {
    return const VehicleListAdminWidget();
  }
}
