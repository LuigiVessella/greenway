// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greenway/presentation/pages/delivery_page.dart';
import 'package:greenway/presentation/widgets/add_new_vehicle_widget.dart';
import 'package:greenway/presentation/widgets/show_vehicles_list.dart';

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
        appBar: AppBar(
          title: const Text('Admin'),
        ),
        body: ListView(children: [
          SvgPicture.asset(
            'lib/assets/undraw_delivery_address_re_cjca.svg',
            height: 150,
          ),
          const Text(
            'Benvenuto admin',
            textAlign: TextAlign.center,
          ),
          const Divider(),
          const SizedBox(
            height: 30,
            child: Text(
              "I tuoi veicoli:",
              textAlign: TextAlign.center,
            ),
          ),
          VehicleListAdminWidget(),
          const Divider(),
          Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const VehicleInputDetail()));
                  },
                  child: const Text('Aggiungi veicolo'),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddNewDelivery()));
                    },
                    child: const Text('Crea etichetta')),
              ]))
        ]));
  }
}
