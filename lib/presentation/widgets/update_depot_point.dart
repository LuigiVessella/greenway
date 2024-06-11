import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:greenway/entity/addresses.dart';
import 'package:greenway/repositories/delivery_repository.dart';

import 'package:http/http.dart' as http;

class UpdateDepotWidget extends StatefulWidget {
  const UpdateDepotWidget({super.key});

  @override
  State<UpdateDepotWidget> createState() => _UpdateDepotWidgetState();
}

class _UpdateDepotWidgetState extends State<UpdateDepotWidget> {
  final DeliveryRepository dr = DeliveryRepository();
  final List<Address> _addressList = [];
  final TextEditingController _controllerAddress = TextEditingController();
  final _formAddressKey = GlobalKey<FormState>();
  double _lat = 0.0;
  double _lon = 0.0;
  String? address;
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Selezione punto di deposito'),
      content: SizedBox(
          width: 300,
          height: 350,
          child: SingleChildScrollView(
              child: Column(children: [
            Form(
                key: _formAddressKey,
                child: TextFormField(
                  controller: _controllerAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obbligatiorio';
                    }
                    return null;
                  },
                  onChanged: (text) {
                    _onSearchChanged(text);
                  },
                  decoration: const InputDecoration(
                      labelText: 'Street address:',
                      prefixIcon: Icon(Icons.house),
                      border: OutlineInputBorder()),
                )),
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
                          onTap: () {
                            if (mounted) {
                              setState(() {
                                _controllerAddress.text =
                                    _addressList[index].displayName!;
                                _lat = double.parse(_addressList[index].lat!);
                                _lon = double.parse(_addressList[index].lon!);
                                address = _addressList[index].displayName;
                              });
                            }
                          },
                        ));
                  }),
            )
          ]))),
      actions: <Widget>[
        TextButton(
          child: const Text('Salva'),
          onPressed: () {
            dr
                .addDepotPoint({
                  "depositAddress": "'$address'",
                  "depositCoordinates": {
                    "type": "Point",
                    "coordinates": [_lon, _lat]
                  }
                })
                .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        backgroundColor: Colors.green,
                        content: Row(children: [
                          Icon(Icons.check),
                          Text('Punto deposito creato')
                        ]))))
                .catchError((error, stackTrace) =>
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.red,
                        content: Row(children: [
                          Icon(Icons.error),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Errore: il deposito esiste già, o anomalia')
                        ]))))
                .whenComplete(
                  () {
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                );
          },
        ),
      ],
    );
  }

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 3000), () {
      _getAddress(query);
    });
  }

  Future<void> _getAddress(String userInput) async {
    //late Delivery newDelivery;

    var client = http.Client();

    var response = await client.get(Uri.https(
      'nominatim.openstreetmap.org',
      '/search',
      {
        'country': 'Italia',
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
        _addressList.clear();
        _addressList.addAll(addresses);
      });
    } else {
      setState(() {
        _addressList.addAll([]);
      });
    }
  }
}
