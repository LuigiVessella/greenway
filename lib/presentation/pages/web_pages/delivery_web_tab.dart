import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenway/dto/all_deliveries_dto.dart';
import 'package:greenway/dto/delivery_dman_dto.dart';
import 'package:greenway/presentation/widgets/web_widget/shipping_status.dart';
import 'package:greenway/repositories/delivery_repository.dart';

class DeliveryWebTab extends StatefulWidget {
  const DeliveryWebTab({super.key});

  @override
  State<DeliveryWebTab> createState() => _DeliveryWebTabState();
}

class _DeliveryWebTabState extends State<DeliveryWebTab> {
  final DeliveryRepository dr = DeliveryRepository();
  late Future<AllDeliveriesDTO> deliveries;

  int _pageCounter = 0;
  int _totalPages = 0;

  @override
  void initState() {
    deliveries = dr.getAllDeliveries(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Informazioni sulle consegne'),
          centerTitle: true,
          bottom: const PreferredSize(
              preferredSize: Size.zero,
              child: Text('Accedi a tutte le informazioni sulle consegne')),
        ),
        body: SafeArea(
            child: FutureBuilder<AllDeliveriesDTO>(
          future: deliveries, // Chiama la tua funzione che ritorna il Future
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<DeliveryDTO> del =
                  snapshot.data!.deliveries!; // Lista dei veicoli
              _totalPages = snapshot.data!.totalPages!; // Numero di pagine
              if (del.isEmpty) {
                return const Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Icon(
                        CupertinoIcons.smiley,
                        size: 50,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          'Wow! Sembra che i corrieri abbiano consegnato tutti i pacchi')
                    ]));
              } else {
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
                              if (_pageCounter < _totalPages - 1) {
                                _pageCounter++;
                              }
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
                              deliveries = dr.getAllDeliveries(_pageCounter);
                            });
                          },
                          icon: const Icon(Icons.update)),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  Expanded(
                      child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: del.length,
                    itemBuilder: (context, index) {
                      return Card(
                          semanticContainer: false,
                          elevation: 5.0,
                          child: ExpansionTile(
                              tilePadding: const EdgeInsets.all(7),
                              childrenPadding: const EdgeInsets.all(1.0),
                              title: Text(
                                'Consegna ${del[index].id}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700),
                              ),
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.local_post_office),
                                  title: Text(del[index].receiver!),
                                  subtitle: Text(
                                      'presso: ${del[index].receiverAddress}'),
                                ),
                                const Divider(),
                                Row(children: [
                                  ShippingStatus(delivery: del[index])
                                ]),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            )),
                                        child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: del[index].estimatedDeliveryTime!=null ? Text(
                                                'Consegna prevista: ${(del[index].estimatedDeliveryTime!).split('T')[0]}',
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500)) : const Text('Ancora non programmata'))),
                                    Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            )),
                                        child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              'Consegnata il: ${(del[index].deliveryTime) ?? 'Ancora non consegnata'}',
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ))),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                )
                              ]));
                    },
                  ))
                ]);
              }
            } else if (snapshot.hasError) {
              return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    const Icon(
                      Icons.info_outline_rounded,
                      color: Colors.orange,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('Info: ${snapshot.error}'),
                    ),
                  ]));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        )));
  }
}
