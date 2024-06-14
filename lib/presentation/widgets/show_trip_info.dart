
import 'package:flutter/material.dart';

class TripInfo extends StatelessWidget {
  const TripInfo({super.key, required this.tripInfo});
  final List<Widget> tripInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          const Text('Indicazioni stradali', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600), ),
          SizedBox(
              height: 300,
              child: ListView.builder(
                  itemCount: tripInfo.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Card(child: tripInfo[index]));
                  }))
        ]));
  }
}
