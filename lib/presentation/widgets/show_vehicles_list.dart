import 'package:flutter/material.dart';

class ShowAllVehicles extends StatefulWidget {
  const ShowAllVehicles({super.key});

  @override
  State<ShowAllVehicles> createState() => _ShowAllVehiclesState();
}

class _ShowAllVehiclesState extends State<ShowAllVehicles> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
                 //itemCount: _
                 itemBuilder: (BuildContext context, int index) {
                   return const Card(

                  );
  }),
    );
  }


  void _getAllVehicles(){
    
  }
}