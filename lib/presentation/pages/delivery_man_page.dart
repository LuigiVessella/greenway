import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greenway/presentation/pages/map_page.dart';
import 'package:greenway/presentation/widgets/show_package_list.dart';
import 'package:greenway/presentation/widgets/show_vehicles_list.dart';
import 'package:greenway/services/network/logger.dart';

class DeliveryManPage extends StatelessWidget {
  const DeliveryManPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.delivery_dining)),
                Tab(icon: Icon(Icons.local_shipping_rounded)),
                Tab(icon: Icon(Icons.map_outlined)),
              ],
            ),
            title: const Text('Le tue attività:'),
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
