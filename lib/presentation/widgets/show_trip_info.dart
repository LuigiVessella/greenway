import 'package:flutter/material.dart';

class TripInfo extends StatelessWidget {
  const TripInfo({super.key, required this.tripInfo});
  final List<String> tripInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(8.0),
     child:SizedBox(height: 300, child:   ListView.builder(
      itemCount: tripInfo.length,
      itemBuilder: (context, index) {
        return Card(
            elevation: 2.0,
            child: ExpansionTile(
                tilePadding: const EdgeInsets.all(5),
                childrenPadding: const EdgeInsets.all(5.0),
                title: const Text('Indicazioni stradali:'),
                children: [
                  ListTile(
                    leading: const Icon(Icons.directions),
                    title: Text('Viaggio ${index + 1}', style: const TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),),
                    subtitle: Text(tripInfo[index], style: const TextStyle(fontWeight: FontWeight.bold),),
                  )
                ]));
      },
    )));
  }
}
