import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greenway/presentation/pages/navigation_page.dart';

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
                Tab(icon: Icon(Icons.car_rental)),
                Tab(icon: Icon(Icons.map_outlined)),
              ],
            ),
            title: const Text('Le tue attività:'),
          ),
          body:  TabBarView(
            children: [
              SizedBox(height: 300,
              child: ListView(
                children: const [
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
                  ListTile(
                    
                    title: Text(
                      'Consegna 2',
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                      'In Via provinciale 100',
                      
              ))])),
              const Icon(Icons.car_rental),
              const NavigationWidget(),
            ],
          ),
  ));
  }
}
