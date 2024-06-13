import 'package:flutter/cupertino.dart';
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
                tilePadding: const EdgeInsets.all(4),
                childrenPadding: const EdgeInsets.all(2.0),
                title: Row(children:[ const Icon(CupertinoIcons.map_pin, color: Colors.red,), Text((index != tripInfo.length  -1) ? 'Spedizione ${index + 1}' : 'Ritorno', style: const TextStyle(fontWeight: FontWeight.w600),)]),
                children: [
                  ListTile(
                    leading: const Icon(Icons.directions),
                    title: const Text('Indicazioni:', style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),),
                    subtitle: Text(tripInfo[index], style: const TextStyle(fontWeight: FontWeight.bold),),
                  )
                ]));
      },
    )));
  }
}
