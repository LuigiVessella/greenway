import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:greenway/dto/elevation_data_dto.dart';
import 'package:greenway/dto/navigation_dto.dart';
import 'package:greenway/repositories/vehicle_repository.dart';
import 'package:greenway/services/network/logger.dart';
import 'package:greenway/services/other/unpack_polyline.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ElevationChart extends StatelessWidget {
  const ElevationChart({super.key, required this.vehicleID});

  final String vehicleID;

  @override
  Widget build(BuildContext context) {
    VehicleRepository vr = VehicleRepository();

    return FutureBuilder<NavigationDataDTO?>(
      future: vr.getVehicleRoute(vehicleID),
      // Chiama la tua funzione che ritorna il Future
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
              body: Center(
                  child: SizedBox(
            width: kIsWeb ? 1500 : 500,
            height: 500,
            child: SfCartesianChart(
                zoomPanBehavior: ZoomPanBehavior(
                  zoomMode: ZoomMode.x,
                  enablePanning: true,
                  maximumZoomLevel: 0.1
                ),
                title: const ChartTitle(text: 'Grafico elevazione'),
                // Initialize category axis
                primaryXAxis: const NumericAxis(
                    autoScrollingDelta: 15,
                    autoScrollingMode: AutoScrollingMode.start),
                primaryYAxis: const NumericAxis(
                  name: 'altitude meters',
                ),
                 legend: const Legend(
                isVisible: true,
                // Border color and border width of legend
                
                borderWidth: 2
              ),
                series: <LineSeries<ChartData, num>>[
                  LineSeries<ChartData, num>(
                    name: 'Altitudine',
                      dataSource: processJsonForChart(snapshot.data),
                      xValueMapper: (ChartData data, _) => data.distance
                          .round(), // data already holds the distance string
                      yValueMapper: (ChartData data, _) =>
                          data.elevation.round(),
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: false),
                      ),
                ]),
          )));
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
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Elaboro i dati',
                  style: TextStyle(color: Colors.white, fontSize: 19),
                )
              ]));
        }
      },
    );
  }

  List<ChartData> processJsonForChart(NavigationDataDTO? navData) {
    List<ChartData> chartData = [];
    List<num> distances = [];
    List<List<num>> points = decodePolyline(navData!.routes![0].geometry!);
    double distanceSum = 0.0;
    print('points: ${points.length}');
    print('elevation lenght ${navData.elevations!.length}');

    for (final route in navData.routes!) {
      for (int i = 0; i < decodePolyline(route.geometry!).length - 1; i++) {
        List<num> firstPoint = points[i];
        print('punto $i: $firstPoint');
        List<num> secondPoint = points[i + 1];
        print('punto $i: $secondPoint');

        num distance = Geolocator.distanceBetween(
            firstPoint[0].toDouble(),
            firstPoint[1].toDouble(),
            secondPoint[0].toDouble(),
            secondPoint[1].toDouble());
        print('distance: $distance');
        distances.add(distance);
        if (i % 10 == 0) {
          chartData.add(ChartData(navData.elevations![i],
              distanceSum > 1000 ? (distanceSum / 1000) : distanceSum));
        }
        distanceSum += distance;

        print('chartdata lenght ${chartData.length}');
      }
    }
    return chartData;
  }
}

class ChartData {
  ChartData(this.elevation, this.distance);

  num elevation; // asse y
  num distance; // asse x
}
