import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greenway/config/themes/first_theme.dart';
import 'package:greenway/entity/vehicle.dart';

import 'package:greenway/repositories/vehicle_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: firstAppTheme,
      home: Scaffold(
          body: Center(
        child: Column(children: <Widget>[
          const SizedBox(
            height: 30,
          ),
          SvgPicture.asset(
            'lib/assets/undraw_delivery_address_re_cjca.svg',
            height: 200,
            width: 200,
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
                readToken();
              },
              child: const Text('Add delivery'))
        ]),
      )),
    );
  }

  Future readToken() async {
    print('ciao');
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token').toString();
    print('token: $token');
  }
}

class _VehicleInputDetailState extends StatefulWidget {
  const _VehicleInputDetailState({super.key});

  @override
  State<_VehicleInputDetailState> createState() =>
      __VehicleInputDetailStateState();
}

class __VehicleInputDetailStateState extends State<_VehicleInputDetailState> {
  final VehicleRepository vr = VehicleRepository();
  final myTextController = TextEditingController();

  //Vehicle v1 = Vehicle();
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
              controller: myTextController,
              decoration: const InputDecoration(
                  labelText: 'Model name:',
                  prefixIcon: Icon(Icons.api_rounded),
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Battery Capacity:',
                  prefixIcon: Icon(Icons.api_rounded),
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Vehicle Consumption:',
                  prefixIcon: Icon(Icons.api_rounded),
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Current Battery Charge',
                  prefixIcon: Icon(Icons.api_rounded),
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Max capacity:',
                  prefixIcon: Icon(Icons.api_rounded),
                  border: OutlineInputBorder()),
            ),
            FilledButton(onPressed: () {}, child: const Text('crea veicolo'))
          ],
        ),
      ),
    );
  }
}
