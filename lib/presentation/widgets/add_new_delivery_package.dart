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
  final _formAddressKey = GlobalKey<FormState>();
  String? _nameComplete;
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerSecondName = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.info))],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
         
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
                      onChanged: (value) {},
                    )),
                  ],
                )),
            const SizedBox(
              height: 40,
            ),
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
            ),
            Column(children: [
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(('Coordinate: LAT: ${_lat.toStringAsFixed(3)} / LON: ${_lon.toStringAsFixed(3)}'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  _nameComplete =
                      '${_controllerName.text} ${_controllerSecondName.text}';
                  if (_formKey.currentState!.validate() &&
                      _formAddressKey.currentState!.validate()) {
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
            ])
          ],
        ),
      ),
    ));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _addressList.clear();
    super.dispose();
  }
}
