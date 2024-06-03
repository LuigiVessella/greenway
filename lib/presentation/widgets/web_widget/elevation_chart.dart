import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:greenway/config/themes/first_theme.dart';
import 'package:greenway/dto/navigation_dto.dart';
import 'package:greenway/repositories/vehicle_repository.dart';
import 'package:greenway/services/other/unpack_polyline.dart';
import 'package:fl_chart/fl_chart.dart';

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
        appBar: AppBar(
          title: const Text('Grafici'),
        ),
        body: FutureBuilder<List<NavigationDataDTO>>(
          future: vr.getVehicleRoutes(widget.vehicleID),
          // Chiama la tua funzione che ritorna il Future
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SafeArea(
                  child: SingleChildScrollView(
                      child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                                topLeft: Radius.circular(10))),
                                        child: const Text(
                                          '<30m',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: Container(
                                      color: Colors.yellow,
                                      child: const Text('<70m',
                                          textAlign: TextAlign.center),
                                    )),
                                    Expanded(
                                      child: Container(
                                        color: Colors.orange,
                                        child: const Text('<150m',
                                            textAlign: TextAlign.center),
                                      ),
                                    ),
                                    Expanded(
                                        child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(10),
                                              topRight: Radius.circular(10))),
                                      child: const Text('>150m',
                                          textAlign: TextAlign.center),
                                    ))
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  'PROFILO STANDARD',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                    height: kIsWeb ? 400 : 240,
                                    width: kIsWeb ? 1000 : 370,
                                    child: AspectRatio(
                                      aspectRatio: 2,
                                      child: LineChart(
                                        LineChartData(
                                          lineBarsData: [
                                            LineChartBarData(
                                              color: Colors.blue.shade100,
                                              spots: processJsonForChart(
                                                      snapshot.data![0])
                                                  .map((point) => FlSpot(
                                                      point.distance.toDouble(),
                                                      point.elevation
                                                          .toDouble()))
                                                  .toList(),
                                              isCurved: true,
                                              dotData: FlDotData(getDotPainter:
                                                  (spot, percent, barData,
                                                      index) {
                                                return calculateColor(spot);
                                              }),
                                            ),
                                          ],
                                          titlesData: FlTitlesData(
                                            show: true,
                                            bottomTitles: AxisTitles(
                                              axisNameWidget: Text(
                                                'Distanza (kM)',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: firstAppTheme
                                                      .primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              sideTitles: const SideTitles(
                                                showTitles: true,
                                                getTitlesWidget:
                                                    bottomTitleWidgets,
                                              ),
                                            ),
                                            leftTitles: AxisTitles(
                                              axisNameSize: 20,
                                              axisNameWidget: Text(
                                                'Altitudine(m)',
                                                style: TextStyle(
                                                  color: firstAppTheme
                                                      .primaryColor,
                                                ),
                                              ),
                                              sideTitles: const SideTitles(
                                                showTitles: true,
                                                reservedSize: 35,
                                                getTitlesWidget:
                                                    leftTitleWidgets,
                                              ),
                                            ),
                                            topTitles: const AxisTitles(
                                                sideTitles: SideTitles(
                                                    showTitles: false)),
                                            rightTitles: const AxisTitles(
                                                sideTitles: SideTitles(
                                                    showTitles: false)),
                                          ),
                                          gridData:
                                              const FlGridData(show: false),
                                          borderData: FlBorderData(
                                            show: true,
                                            border: Border.all(
                                                color: const Color(0xff37434d)),
                                          ),
                                        ),
                                      ),
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Divider(),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'PROFILO ELEVAZIONE',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: kIsWeb ? 400 : 240,
                                  width: kIsWeb ? 1000 : 370,
                                  child: LineChart(
                                    LineChartData(
                                      lineBarsData: [
                                        LineChartBarData(
                                          color: Colors.blue.shade100,
                                          spots: processJsonForChart(
                                                  snapshot.data![1])
                                              .map((point) => FlSpot(
                                                  point.distance.toDouble(),
                                                  point.elevation.toDouble()))
                                              .toList(),
                                          isCurved: true,
                                          dotData: FlDotData(getDotPainter:
                                              (spot, percent, barData, index) {
                                            return calculateColor(spot);
                                          }),
                                          show: true,
                                        ),
                                      ],
                                      titlesData: FlTitlesData(
                                        show: true,
                                        bottomTitles: AxisTitles(
                                          axisNameWidget: Text(
                                            'Distanza (kM)',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: firstAppTheme.primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          sideTitles: const SideTitles(
                                            showTitles: true,
                                            getTitlesWidget: bottomTitleWidgets,
                                          ),
                                        ),
                                        leftTitles: AxisTitles(
                                          axisNameSize: 20,
                                          axisNameWidget: Text(
                                            'Altitudine(m)',
                                            style: TextStyle(
                                              color: firstAppTheme.primaryColor,
                                            ),
                                          ),
                                          sideTitles: const SideTitles(
                                            showTitles: true,
                                            reservedSize: 35,
                                            getTitlesWidget: leftTitleWidgets,
                                          ),
                                        ),
                                        topTitles: const AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false)),
                                        rightTitles: const AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false)),
                                      ),
                                      gridData: const FlGridData(show: false),
                                      borderData: FlBorderData(
                                        show: true,
                                        border: Border.all(
                                            color: const Color(0xff37434d)),
                                      ),
                                    ),
                                  ),
                                )
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

      if (nullChecker == null || navData.elevations?[i] < 0) {
        continue;
      } else {
        chartData.add(ChartData(
            navData.elevations![i] ?? 0, (i == 0) ? 0 : distanceSum / 1000));
      }

      distanceSum = (distanceSum + distance);
    }

    return chartData;
  }

  FlDotPainter calculateColor(FlSpot spot) {
    if (spot.y > 0 && spot.y <= 30) {
      return FlDotCirclePainter(
        radius: 1,
        color: Colors.green,
        strokeWidth: 0.2,
        strokeColor: Colors.green,
      );
    } else if (spot.y > 30 && spot.y <= 70) {
      return FlDotCirclePainter(
        radius: 1,
        color: Colors.yellow,
        strokeWidth: 0.2,
        strokeColor: Colors.green,
      );
    } else if (spot.y > 70 && spot.y <= 150) {
      return FlDotCirclePainter(
        radius: 1,
        color: Colors.orange,
        strokeWidth: 0.1,
        strokeColor: Colors.green,
      );
    } else if (spot.y > 150) {
      return FlDotCirclePainter(
        radius: 1,
        color: Colors.red,
        strokeWidth: 0.2,
        strokeColor: Colors.green,
      );
    } else {
      return FlDotCirclePainter(
        radius: 0,
        color: Colors.white,
        strokeWidth: 0.5,
        strokeColor: Colors.white,
      );
    }
  }
}

Widget leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.black,
    fontSize: 13,
  );
  return SideTitleWidget(
    space: 10,
    axisSide: meta.axisSide,
    child: Text('${value.round()}', style: style),
  );
}

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.black,
    fontSize: 13,
  );

  return SideTitleWidget(
    axisSide: meta.axisSide,
    angle: 1.0,
    child: Text('${value.round()}', style: style),
  );
}

BoxDecoration boxDeco() {
  return BoxDecoration(
      border: Border.all(
        color: Colors.red,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(20)));
}

class ChartData {
  ChartData(this.elevation, this.distance);

  final num elevation; // asse y
  final num distance; // asse x
}
