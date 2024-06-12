import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greenway/entity/vehicle/vehicle.dart';
import 'package:greenway/repositories/vehicle_repository.dart';

class VehicleInputDetail extends StatefulWidget {
  const VehicleInputDetail({super.key});

  @override
  State<VehicleInputDetail> createState() => _VehicleInputDetailState();
}

class _VehicleInputDetailState extends State<VehicleInputDetail> {
  final VehicleRepository vr = VehicleRepository();

  final modelTextController = TextEditingController();
  final maxAutonomyTextController = TextEditingController();
  final maxCapacityTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Informazioni sul veicolo"),
          centerTitle: true,
        ),
        body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
                child: Column(children: [
              Visibility(
                visible: _isLoading,
                child: const LinearProgressIndicator(),
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obbligatiorio';
                        }
                        return null;
                      },
                      controller: modelTextController,
                      decoration: const InputDecoration(
                          labelText: 'Modello:',
                          prefixIcon: Icon(Icons.info),
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obbligatiorio';
                        }
                        return null;
                      },
                      controller: maxAutonomyTextController,
                      decoration: const InputDecoration(
                          labelText: 'Capacità della batteria (km):',
                          prefixIcon: Icon(Icons.battery_full),
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obbligatiorio';
                        }
                        return null;
                      },
                      controller: maxCapacityTextController,
                      decoration: const InputDecoration(
                          labelText: 'Carico massimo (kg):',
                          prefixIcon: Icon(Icons.balance),
                          border: OutlineInputBorder()),
                    )
                  ])),
              const SizedBox(
                height: 10,
              ),
              FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                      });
                      FocusManager.instance.primaryFocus?.unfocus();
                      vr
                          .addVehicle(Vehicle(
                            modelName: modelTextController.text,
                            maxAutonomyKm:
                                int.parse(maxAutonomyTextController.text),
                            maxCapacityKg:
                                int.parse(maxCapacityTextController.text),
                          ))
                          .then(
                            (value) {
                              setState(() {
                                _isLoading = false;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Row(children: [
                                        Icon(Icons.info),
                                        Text('Veicolo aggiunto correttamente')
                                      ])));
                            },
                          )
                          .catchError(
                            (error, stackTrace) {
                              setState(() {
                                _isLoading = false;
                              });

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Row(children: [
                                        Icon(Icons.error),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                            'Errore: impossibile aggiungere il veicolo')
                                      ])));
                            },
                          )
                          .then(
                            (value) =>
                                Future.delayed(const Duration(seconds: 3)),
                          )
                          .then(
                            (value) => Navigator.pop(context),
                          );
                    }
                  },
                  child: const SizedBox(
                      width: 70,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [Icon(Icons.save), Text('Salva')])))
            ]))));
  }
}
