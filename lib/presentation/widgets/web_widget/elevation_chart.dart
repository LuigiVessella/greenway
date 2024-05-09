import 'package:flutter/material.dart';
import 'package:greenway/dto/elevation_data_dto.dart';
import 'package:greenway/repositories/vehicle_repository.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ElevationChart extends StatelessWidget {
  const ElevationChart({super.key, required this.vehicleID});

  final String vehicleID;

  @override
  Widget build(BuildContext context) {
    VehicleRepository vr = VehicleRepository();

    return FutureBuilder<ElevationDataDTO>(
      future: vr.getElevationData(
          vehicleID), // Chiama la tua funzione che ritorna il Future
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Lista dei veicoli

          return Scaffold(
              body: Center(
                  child: SizedBox(
                      width: 300,
                      height: 400,
                      child: SfCartesianChart(
                          // Initialize category axis
                          primaryXAxis: const CategoryAxis(),
                          series: <LineSeries<Data, String>>[
                            LineSeries<Data, String>(
                                // Bind data source
                                dataSource: <Data>[
                                  Data('100',
                                      snapshot.data!.results![0].elevation),
                                  Data('200',
                                      snapshot.data!.results![1].elevation),
                                  Data('300',
                                      snapshot.data!.results![2].elevation),
                                  Data('400',
                                      snapshot.data!.results![3].elevation),
                                  Data('500',
                                      snapshot.data!.results![4].elevation)
                                ],
                                xValueMapper: (Data sales, _) => sales.meters,
                                yValueMapper: (Data sales, _) =>
                                    sales.elevation)
                          ]))));
        } else if (snapshot.hasError) {
          if (snapshot.error.toString().contains('401')) {
            return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  const Icon(
                    Icons.info_outline_rounded,
                    color: Colors.red,
                    size: 60,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('La tua sessione è scaduta'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: FilledButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/');
                        },
                        child: const Text('Login again')),
                  ),
                ]));
          } else {
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
          }
        } else {
          return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    CircularProgressIndicator(
                      strokeWidth: 5,
                    ),
                    SizedBox(height: 10,),
                    Text('Elaboro i dati', style: TextStyle(color: Colors.white, fontSize: 19),)
          ]));
        }
      },
    );
  }
}

class Data {
  Data(this.meters, this.elevation);
  final String meters;
  final num? elevation;
}
