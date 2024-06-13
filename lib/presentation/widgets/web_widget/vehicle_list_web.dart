import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenway/dto/vehicle_dto.dart';
import 'package:greenway/presentation/pages/map_page.dart';
import 'package:greenway/presentation/widgets/web_widget/elevation_chart.dart';
import 'package:greenway/repositories/vehicle_repository.dart';

class VechicleListWeb extends StatefulWidget {
  const VechicleListWeb({super.key});

  @override
  State<VechicleListWeb> createState() => _VechicleListWebState();
}

class _VechicleListWebState extends State<VechicleListWeb> {
  final VehicleRepository vr = VehicleRepository();
  late Future<VehicleDto> vehiclesList;

  int _pageCounter = 0;
  int _totalPages = 0;

  @override
  void initState() {
    super.initState();

    vehiclesList = vr.getAllVehicles(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Grafici e Viaggio'),
          centerTitle: true,
          leading: null,
          bottom: const PreferredSize(
              preferredSize: Size.zero,
              child: Text(
                  'Accedi al veicolo in transito e visualizza il grafico')),
        ),
        body: SafeArea(
            child: FutureBuilder<VehicleDto>(
          future: vehiclesList, // Chiama la tua funzione che ritorna il Future
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              VehicleDto vehicleDTO = snapshot.data!; // Lista dei veicoli
              _totalPages = vehicleDTO.totalPages!;

              return Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('Numero di pagina:'),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            if (_pageCounter > 0) {
                              _pageCounter--;
                            }
                          });
                        },
                        icon: const Icon(Icons.remove)),
                    Text(
                      '$_pageCounter',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            if (_pageCounter < _totalPages - 1) _pageCounter++;
                          });
                        },
                        icon: const Icon(
                          Icons.add,
                        )),
                    IconButton.filledTonal(
                        enableFeedback: true,
                        tooltip: 'Carica la nuova pagina',
                        onPressed: () {
                          setState(() {
                            vehiclesList = vr.getAllVehicles(_pageCounter);
                          });
                        },
                        icon: const Icon(CupertinoIcons.refresh)),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                Expanded(
                    child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: vehicleDTO.content!.length,
                  itemBuilder: (context, index) {
                    return Card(
                        semanticContainer: false,
                        elevation: 5.0,
                        child: ExpansionTile(
                            tilePadding: const EdgeInsets.all(15),
                            childrenPadding: const EdgeInsets.all(9.0),
                            title: Text(
                              'VEICOLO ${vehicleDTO.content![index].id}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            children: [
                              ListTile(
                                leading: const Icon(Icons.local_shipping),
                                title:
                                    Text(vehicleDTO.content![index].modelName!),
                                subtitle: Text(
                                    'CARICO MASSIMO: ${vehicleDTO.content![index].maxCapacityKg}kg'),
                              ),
                              FilledButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ElevationChart(
                                            vehicleID: vehicleDTO
                                                .content![index].id
                                                .toString(),
                                          ),
                                        ));
                                  },
                                  icon: const Icon(Icons.auto_graph),
                                  label:
                                      const Text('Visualizza dati elevazione')),
                              const SizedBox(
                                height: 20,
                                child: Center(child: Text('o')),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NavigationWidget(
                                          vehicleID: vehicleDTO
                                              .content![index].id!
                                              .toInt(),
                                        ),
                                      ));
                                },
                                label:
                                    const Text('Visulizza percorso su mappa'),
                                icon: const Icon(CupertinoIcons.map),
                              )
                            ]));
                  },
                ))
              ]);
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                    'Errore durante il caricamento dei veicoli ${snapshot.error}'),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        )));
  }
}
