import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:greenway/entity/addresses.dart';
import 'package:http/http.dart' as http;

class AddNewDelivery extends StatefulWidget {
  const AddNewDelivery({super.key, required this.title});
  final String title;

  @override
  State<AddNewDelivery> createState() => _AddNewDeliveryState();
}

class _AddNewDeliveryState extends State<AddNewDelivery> {
  List<Address> _addressList = [];
  String _lat = '0.0';
  String _lon = '0.0';

  Future<List<Address>> _getAddress(String userInput) async {
    var client = http.Client();

    var response = await client.get(Uri.https(
      'nominatim.openstreetmap.org',
      '/search',
      {
        'state': 'Campania',
        'street': userInput,
        'format': 'jsonv2',
      },
    ));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)
          as List; // Tratta la risposta come una lista
      List<Address> addresses = jsonData
          .map((data) => Address.fromJson(data))
          .toList(); // Mappa gli oggetti Address
      setState(() {
        _addressList = addresses;
      });
      return addresses;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            const SizedBox(
              height: 40,
            ),
            TextFormField(
              onChanged: (text) async {
                _addressList = (await _getAddress(text));
              },
              decoration: const InputDecoration(
                  labelText: 'Street name:',
                  prefixIcon: Icon(Icons.api_rounded),
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 270,
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _addressList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        elevation: 7.6,
                        child: ListTile(
                          title:
                              Text(_addressList[index].displayName.toString()),
                          onTap: () => setState(() {
                            _lat = _addressList[index].lat.toString();
                            _lon = _addressList[index].lon.toString();
                          }),
                        ));
                  }),
            ),
            const SizedBox(
              height: 40,
            ),
            Card(
              elevation: 10,
              child: SizedBox(
                height: 30,
                child: Text(
                  'lat: $_lat e lon: $_lon',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, 'lat: $_lat e lon: $_lon');
              },
              child: const Text('Ok'),
            )
          ],
        ),
      ),
    );
  }
}
