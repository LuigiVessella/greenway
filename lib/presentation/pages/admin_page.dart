// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greenway/components/components.dart';
import 'package:greenway/presentation/pages/delivery_page.dart';
import 'package:greenway/presentation/widgets/add_new_vehicle_widget.dart';
import 'package:greenway/presentation/widgets/show_vehicles_list.dart';
import 'package:greenway/presentation/widgets/update_depot_point.dart';
import 'package:greenway/repositories/delivery_repository.dart';

//import 'package:shared_preferences/shared_preferences.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  var resultSenderG, resultReceiverG;
  final DeliveryRepository dr = DeliveryRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Admin Dashboard'),
          actions: [
            Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton.filledTonal(
                    enableFeedback: true,
                    icon: const Icon(Icons.warehouse),
                    tooltip: "Aggiungi punto deposito",
                    onPressed: () async {
                      await showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return const UpdateDepotWidget();
                        },
                      );
                    }))
          ],
        ),
        body: SingleChildScrollView(
            child: PopScope(
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
                      const Padding(
                          padding:
                              EdgeInsetsDirectional.only(top: 8, bottom: 8),
                          child: Text(
                            'Qui puoi inserire Veicoli e Spedizioni',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          )),
                      const Divider(),
                      const VehicleListAdminWidget(),
                      const Divider(),
                      Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(children: [
                            FilledButton.tonal(
                              onPressed: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const VehicleInputDetail()));
                                setState(() {});
                              },
                              child: const SizedBox(
                                  width: 110, child: Text('Aggiungi veicolo')),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            
                            FilledButton.tonal(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AddNewDelivery()));
                                },
                                child: const SizedBox(
                                    width: 110,
                                    child: Text(
                                      'Aggiungi spedizione',
                                      textAlign: TextAlign.center,
                                    ))),
                          ]))
                    ])))));
  }
}
