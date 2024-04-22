import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:greenway/presentation/pages/map_page.dart';
import 'package:greenway/presentation/widgets/show_package_list.dart';
import 'package:greenway/presentation/widgets/show_vehicles_list.dart';


class DeliveryManPage extends StatelessWidget {
  const DeliveryManPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.2,
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.warehouse_outlined), text: "Consegne",),
                Tab(icon: Icon(Icons.electric_car), text: "Veicolo"),
                Tab(icon: Icon(Icons.map_outlined), text:"Mappa"),
              ],
            ),
            title: const Text('La tua giornata'),
          ),
          body: TabBarView(
            children: [
              const PackageList(),
             /* SizedBox(
                  height: 300,
                  child: ListView(children: const [
                    Card(
                        child: ExpansionTile(
                            title: Text('Consegne di oggi:'),
                            children: [
                          ListTile(
                            title: Text(
                              'Consegna 1',
                              style: TextStyle(fontSize: 20),
                            ),
                            subtitle: Text(
                              'In consegna presso Via statale 13',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          Divider(),
                          ListTile(
                              title: Text(
                                'Consegna 2',
                                style: TextStyle(fontSize: 20),
                              ),
                              subtitle: Text(
                                'In Via provinciale 100',
                              ))
                        ]))
                  ])),*/
              Container(
                child: VehicleListDmanWidget(),
              ),
              const NavigationWidget(),
            ],
          ),
        ));
  }
}
