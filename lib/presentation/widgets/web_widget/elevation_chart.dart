import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:greenway/config/themes/first_theme.dart';
import 'package:greenway/dto/navigation_dto.dart';
import 'package:greenway/repositories/vehicle_repository.dart';
import 'package:greenway/services/other/unpack_polyline.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ElevationChart extends StatefulWidget {
  const ElevationChart({super.key, required this.vehicleID});
  final String vehicleID;

  @override
  State<ElevationChart> createState() => _ElevationChartState();
}

class _ElevationChartState extends State<ElevationChart> {
  @override
  Widget build(BuildContext context) {
    VehicleRepository vr = VehicleRepository();

    return Scaffold(
        body: FutureBuilder<List<NavigationDataDTO>>(
      future: vr.getVehicleRoutes(widget.vehicleID),
      // Chiama la tua funzione che ritorna il Future
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SafeArea(
              child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                  child: Column(children: [
                    const Text('Grafico altitudine / profilo Standard'),
                    SizedBox(
                        width: kIsWeb ? 1500 : 500,
                        height: 500,
                        child: charts.LineChart([
                          charts.Series<ChartData, num>(
                            displayName: 'Grafico elevazione',
                            id: 'Sales',
                            colorFn: (_, __) =>
                                charts.MaterialPalette.blue.shadeDefault,
                            domainFn: (ChartData sales, _) => sales.distance,
                            measureFn: (ChartData sales, _) => sales.elevation,
                            data: processJsonForChart(snapshot.data![0]),
                          ),
                        ],
                            primaryMeasureAxis: const charts.NumericAxisSpec(),
                            secondaryMeasureAxis:
                                const charts.NumericAxisSpec(),
                            animate: true,
                            defaultRenderer: charts.LineRendererConfig(
                                includePoints: false))),
                    const Text('Grafico altitudine / profilo Elevazione'),
                    SizedBox(
                        width: kIsWeb ? 1500 : 500,
                        height: 500,
                        child: charts.LineChart([
                          charts.Series<ChartData, num>(
                            displayName: 'Grafico elevazione',
                            id: 'Sales',
                            colorFn: (_, __) =>
                                charts.MaterialPalette.blue.shadeDefault,
                            domainFn: (ChartData sales, _) => sales.distance,
                            measureFn: (ChartData sales, _) => sales.elevation,
                            data: processJsonForChart(snapshot.data![1]),
                          ),
                        ],
                            primaryMeasureAxis: const charts.NumericAxisSpec(),
                            secondaryMeasureAxis:
                                const charts.NumericAxisSpec(),
                            animate: true,
                            defaultRenderer: charts.LineRendererConfig(
                                includePoints: false)))
                  ])));
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
          return Container(
              alignment: Alignment.center,
              child: const Column(
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
                      style: TextStyle(fontSize: 19),
                    )
                  ]));
        }
      },
    ));
  }

  List<ChartData> processJsonForChart(NavigationDataDTO navData) {
    List<ChartData> chartData = [];
    List<num> distances = [];
    List<List<num>> points = decodePolyline(navData.routes![0].geometry!);
    double distanceSum = 0.0;

    print('points: ${points.length}');
    print('elevation lenght ${navData.elevations!.length}');

    for (int i = 0; i < navData.elevations!.length - 1; i++) {
      List<num> firstPoint = points[i];
      List<num> secondPoint = points[i + 1];

      num distance = Geolocator.distanceBetween(
          firstPoint[0].toDouble(),
          firstPoint[1].toDouble(),
          secondPoint[0].toDouble(),
          secondPoint[1].toDouble());

      distances.add(distance);

      num? nullChecker = navData.elevations?[i];

      if (nullChecker == null) {
        continue;
      } else {
        chartData.add(
            ChartData(navData.elevations![i] ?? 0, (i == 0) ? 0 : distanceSum));
      }

      distanceSum = (distanceSum + distance);
    }

    return chartData;
  }
}

class ChartData {
  ChartData(this.elevation, this.distance);

  final num elevation; // asse y
  final num distance; // asse x
}
