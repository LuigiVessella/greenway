import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greenway/dto/delivery_dman_dto.dart';
import 'package:greenway/repositories/delivery_repository.dart';
import 'package:greenway/repositories/vehicle_repository.dart';
import 'package:greenway/services/network/logging/logger.dart';

class PackageList extends StatefulWidget {
  const PackageList({super.key});

  @override
  State<PackageList> createState() => _PackageListState();
}

class _PackageListState extends State<PackageList> {
  final VehicleRepository vr = VehicleRepository();
  final DeliveryRepository dr = DeliveryRepository();

  late Future<VehicleByDmanDto> data;

  @override
  void initState() {
    data = vr.getVehicleByDeliveryMan(AuthService().getUserInfo!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<VehicleByDmanDto>(
      future: data, // Chiama la tua funzione che ritorna il Future
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          VehicleByDmanDto vehicleDTO = snapshot.data!; // Lista dei veicoli
          if (vehicleDTO.deliveries!.isEmpty) {
            return const Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Icon(CupertinoIcons.smiley, size: 50,),
                  Text('Wow! Sembra che tu abbia consegnato tutti i pacchi')
                ]));
          }
          return SizedBox(
              height: 250,
              child: ListView.builder(
                itemCount: vehicleDTO.deliveries!.length,
                itemBuilder: (context, index) {
                  return Card.filled(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      // Define how the card's content should be clipped
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: ExpansionTile(
                          tilePadding: const EdgeInsets.all(7),
                          childrenPadding: const EdgeInsets.all(1.0),
                          title: Row(children: [
                            Expanded(
                              child: Text(
                                  vehicleDTO.deliveries![index].receiver!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                            ),
                            //controlliamo se la consegna è in ritardo
                            DateTime.parse(vehicleDTO.deliveries![index]
                                        .estimatedDeliveryTime!)
                                    .isAfter(DateTime.now())
                                ? Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.green),
                                    child: const Text('In transito',
                                        style: TextStyle(
                                          fontSize: 10,
                                        )),
                                  )
                                : Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.orange),
                                    child: const Text('In ritardo',
                                        style: TextStyle(
                                          fontSize: 10,
                                        )))
                          ]),
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                child: SvgPicture.asset(
                                    'lib/assets/avatar_ship.svg'),
                              ),
                              title:
                                  Text(vehicleDTO.deliveries![index].receiver!),
                              subtitle: Text(
                                  'presso: ${vehicleDTO.deliveries![index].receiverAddress}'),
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Consegna prevista: ${vehicleDTO.deliveries![index].estimatedDeliveryTime!.split('T')[0]}',
                                ),
                                TextButton(
                                    onPressed: () {
                                      dr
                                          .completeDelivery(vehicleDTO
                                              .deliveries![index].id
                                              .toString())
                                          .then((value) =>
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      backgroundColor:
                                                          Colors.green,
                                                      content: Row(children: [
                                                        Icon(Icons.check),
                                                        Text(
                                                            'Marcata come consegnata')
                                                      ]))))
                                          .then(
                                            (value) => setState(() {
                                              data = vr.getVehicleByDeliveryMan(
                                                  AuthService().getUserInfo!);
                                            }),
                                          )
                                          .catchError((error, stackTrace) =>
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      backgroundColor: Colors.red,
                                                      content: Row(children: [
                                                        Icon(Icons.error),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                            'Errore: impossibile completare consegna')
                                                      ]))));
                                    },
                                    child: const Text('Consegnata'))
                              ],
                            )
                          ]));
                },
              ));
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
    );
  }
}
