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

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text('Inserisci o aggiorna deposito'),
          Visibility(
              visible: _isLoading, child: const CircularProgressIndicator())
        ],
      ),
      content: SizedBox(
          width: 300,
          height: 350,
          child: SingleChildScrollView(
              child: Column(children: [
            _depotInfo(),
            Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Form(
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
                    ))),
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
            child: const Text('Annulla'),
            onPressed: () {
              Navigator.pop(context);
            }),
        TextButton(
          child: const Text('Salva'),
          onPressed: () async {
            await dr
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

  Future<void> _onSearchChanged(String query) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 2000), () async {
      await _getAddress(query).then(
        (value) {},
      );
    });
  }

  Future<void> _getAddress(String userInput) async {
    //late Delivery newDelivery;
    setState(() {
      _isLoading = true;
    });

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
        _isLoading = false;
        _addressList.clear();
        _addressList.addAll(addresses);
      });
    } else {
      setState(() {
        _isLoading = false;
        _addressList.addAll([]);
      });
    }
  }

  Widget _depotInfo() {
    return FutureBuilder(
        future: dr.getDepotPoint(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Indirizzo attuale: ${
                snapshot.data!.depositAddress!}',
                style: const TextStyle(fontSize: 13),
              ),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return const CircularProgressIndicator(
              color: Colors.black,
            );
          }
        });
  }
}
