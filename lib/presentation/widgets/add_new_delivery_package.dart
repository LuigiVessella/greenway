import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:greenway/entity/addresses.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class AddNewPackage extends StatefulWidget {
  const AddNewPackage({super.key, required this.title});
  final String title;

  @override
  State<AddNewPackage> createState() => _AddNewPackageState();
}

class _AddNewPackageState extends State<AddNewPackage> {
  final List<Address> _addressList = [];
  double _lat = 0.0;
  double _lon = 0.0;
  String? address;
  final _formKey = GlobalKey<FormState>();
  String? _nameComplete;
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerSecondName = TextEditingController();
  Timer? _debounce;

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
            Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      controller: _controllerName,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obbligatiorio';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                      ),
                      onChanged: (value) {},
                    )),
                    
                    Expanded(
                        child: TextFormField(
                            controller: _controllerSecondName,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obbligatiorio';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Cognome',
                            ),
                            onChanged: (value) {})),
                  ],
                )),
            const SizedBox(
              height: 40,
            ),
            TextFormField(
              onChanged: (text) async {
                _onSearchChanged(text);
              },
              decoration: const InputDecoration(
                  labelText: 'Street address:',
                  prefixIcon: Icon(Icons.house),
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
                          onTap: () {
                            if (mounted) {
                              setState(() {
                                _lat = double.parse(_addressList[index].lat!);
                                _lon = double.parse(_addressList[index].lon!);
                                address = _addressList[index].displayName;
                              });
                            }
                          },
                        ));
                  }),
            ),
            const SizedBox(
              height: 40,
            ),
            Card(
              elevation: 5,
              child: SizedBox(
                
                child: Text(
                  'LAT: $_lat / LON: $_lon',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold)
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _nameComplete =
                    '${_controllerName.text} ${_controllerSecondName.text}';
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(
                    context,
                    {
                      'lat': _lat,
                      'lon': _lon,
                      'address': address,
                      'name': '$_nameComplete'
                    },
                  );
                }
              },
              child: const Text('Salva informazioni '),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _addressList.clear();
    super.dispose();
  }
}
