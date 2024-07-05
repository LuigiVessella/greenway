import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:greenway/dto/all_deliveries_dto.dart';
import 'package:greenway/repositories/delivery_repository.dart';

class ShippingListMobile extends StatefulWidget {
  const ShippingListMobile({super.key});

  @override
  State<ShippingListMobile> createState() => _ShippingListMobileState();
}

class _ShippingListMobileState extends State<ShippingListMobile> {
  final DeliveryRepository dr = DeliveryRepository();
  late Future<AllDeliveriesDTO> _deliveries;

  final int _pageCounter = 0;

  @override
  void initState() {
    super.initState();

    _deliveries = dr.getAllDeliveries(_pageCounter);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AllDeliveriesDTO>(
      future: _deliveries, // Chiama la tua funzione che ritorna il Future
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          AllDeliveriesDTO deliveriesDTO = snapshot.data!;
          if (deliveriesDTO.totalElements! < 1) {
            return Center(
                child: SizedBox(
                    height: 350,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            CupertinoIcons.info,
                            size: 50,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Non ci sono consegne al momento. Puoi crearne una nella sezione in basso. Poi aggiorna.',
                            textAlign: TextAlign.center,
                          ),
                          IconButton.outlined(
                              enableFeedback: true,
                              tooltip: 'Aggiorna lista veicoli',
                              onPressed: () {
                                setState(() {
                                  _deliveries =
                                      dr.getAllDeliveries(_pageCounter);
                                });
                              },
                              icon: const Icon(CupertinoIcons.refresh))
                        ])));
          }

          return Column(children: [
             Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              
                IconButton.filledTonal(
                    enableFeedback: true,
                    tooltip: 'Aggiorna lista consegne',
                    onPressed: () {
                      setState(() {
                        _deliveries = dr.getAllDeliveries(_pageCounter);
                      });
                    },
                    icon: const Icon(CupertinoIcons.refresh)),
              ],
            ),
            SizedBox(
                height: 320,
                child: Scrollbar(
                    child: ListView.builder(
                        itemCount: deliveriesDTO.deliveries!.length,
                        itemBuilder: (context, index) {
                          return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              // Define how the card's content should be clipped
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    // Add padding around the row widget
                                    Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Row(children: [
                                          SvgPicture.asset(
                                            'lib/assets/pack_icon.svg',
                                            height: 40,
                                            width: 40,
                                            fit: BoxFit.cover,
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(deliveriesDTO
                                                    .deliveries![index]
                                                    .receiver!),
                                                Text(
                                                    'consegna: ${deliveriesDTO.deliveries![index].estimatedDeliveryTime ?? 'Ancora da pianificare. Premi il pulsante in alto a destra.'}'),
                                              ],
                                            ),
                                          )
                                        ]))
                                  ]));
                        })))
          ]);
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
                'Errore durante il caricamento delle consegne ${snapshot.error}'),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
