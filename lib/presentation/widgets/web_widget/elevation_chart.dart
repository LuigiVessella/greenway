import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:greenway/config/themes/first_theme.dart';
import 'package:greenway/dto/navigation_dto.dart';
import 'package:greenway/presentation/pages/map_page.dart';
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
          title: const Text('Grafico percorso'),
          centerTitle: true,
          bottom: const PreferredSize(
              preferredSize: Size.zero,
              child: Text('Visualizza il grafico e informazioni sul percorso')),
        ),
        body: FutureBuilder<List<NavigationDataDTO>>(
          future: vr.getVehicleRoutes(widget.vehicleID),
          // Chiama la tua funzione che ritorna il Future
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SafeArea(
                  child: Scrollbar(
                    thumbVisibility: true,
                    trackVisibility: true,
                    child: 
                  SingleChildScrollView(
                      child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  'PROFILO STANDARD',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                    width: 400,
                                    child: buildLegend(
                                        snapshot.data![0].elevations!)),
                                const SizedBox(height: 15),
                                SizedBox(
                                    height: kIsWeb ? 400 : 240,
                                    width: kIsWeb ? 1000 : 370,
                                    child: AspectRatio(
                                      aspectRatio: 2,
                                      child: LineChart(
                                        LineChartData(
                                          maxY: _findMax(snapshot
                                                  .data![0].elevations!) +
                                              5,
                                          minY: _findMin(snapshot
                                                  .data![0].elevations!) -
                                              2,
                                          clipData: const FlClipData.all(),
                                          lineBarsData: [
                                            LineChartBarData(
                                              //preventCurveOverShooting: true,

                                              curveSmoothness: 0,
                                              color: const Color.fromARGB(
                                                  255, 162, 178, 239),
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
                                                return calculateColor(
                                                    spot,
                                                    snapshot
                                                        .data![0].elevations!);
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
                                const SizedBox(height: 10),
                                SizedBox(
                                    width: 400,
                                    child: buildLegend(
                                        snapshot.data![1].elevations!)),
                                const SizedBox(height: 15),
                                SizedBox(
                                  height: kIsWeb ? 400 : 240,
                                  width: kIsWeb ? 1000 : 370,
                                  child: LineChart(
                                    LineChartData(
                                      maxY: _findMax(
                                              snapshot.data![1].elevations!) +
                                          5,
                                      minY: _findMin(
                                              snapshot.data![1].elevations!) -
                                          2,
                                      clipData: const FlClipData.all(),
                                      lineBarsData: [
                                        LineChartBarData(
                                          //preventCurveOverShooting: true,

                                          curveSmoothness: 0,
                                          color: const Color.fromARGB(
                                              255, 162, 178, 239),
                                          spots: processJsonForChart(
                                                  snapshot.data![1])
                                              .map((point) => FlSpot(
                                                  point.distance.toDouble(),
                                                  point.elevation.toDouble()))
                                              .toList(),
                                          isCurved: true,
                                          dotData: FlDotData(getDotPainter:
                                              (spot, percent, barData, index) {
                                            return calculateColor(spot,
                                                snapshot.data![0].elevations!);
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
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                        child: Card(
                                            child: Column(
                                      children: [
                                        const AutoSizeText(
                                            maxLines: 1,
                                            'Informazioni sul sentiero'),
                                        const Icon(Icons
                                            .hiking), // Icona di un escursionista
                                        const AutoSizeText(
                                            maxLines: 1,
                                            'Altezza massima standard:'),
                                        AutoSizeText(
                                            maxLines: 1,
                                            '${_findMax(snapshot.data![0].elevations!)} m'),
                                        const AutoSizeText(
                                            maxLines: 1,
                                            'Distanza viaggio standard:'),
                                        AutoSizeText(
                                            maxLines: 1,
                                            calculateDurance(
                                                snapshot.data![0])),
                                      ],
                                    ))),
                                    Expanded(
                                      child: Card(
                                          child: Column(
                                        children: [
                                          const AutoSizeText(
                                            maxLines: 1,
                                            'Dati di elevazione:',
                                          ),
                                          const Icon(Icons
                                              .bar_chart), // Icona di un grafico a barre
                                          const AutoSizeText(
                                              maxLines: 1,
                                              'Altezza massima elevazione:'),
                                          Text(
                                              '${_findMax(snapshot.data![1].elevations!)} m'),
                                          const AutoSizeText(
                                              maxLines: 1,
                                              'Distanza viaggio elevazione:'),
                                          Text(calculateDurance(
                                              snapshot.data![1])),
                                        ],
                                      )),
                                    )
                                  ],
                                )
                              ])))));
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
                return const Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                      Icon(
                        Icons.info_outline_rounded,
                        color: Colors.orange,
                        size: 60,
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                            'Nessun dato presente. Verifica che sia in transito'),
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

  FlDotPainter calculateColor(FlSpot spot, List<dynamic> values) {
    // Find minimum and maximum values
    final minValue = _findMin(values);
    final maxValue = _findMax(values);

    // Calculate range (avoid division by zero)
    final range = maxValue > minValue ? maxValue - minValue : 1.0;

    // Calculate proportional thresholds based on desired ranges (adjust as needed)
    const lowThreshold = 0.25; // 25% of the range
    const midThreshold1 = 0.50; // 50% of the range
    const midThreshold2 = 0.75; // 75% of the range

    // Calculate proportional y values
    final lowY = minValue + lowThreshold * range;
    final midY1 = minValue + midThreshold1 * range;
    final midY2 = minValue + midThreshold2 * range;

    // Check spot value and assign color based on range
    if (spot.y > minValue && spot.y <= lowY) {
      return FlDotCirclePainter(
        radius: 1,
        color: Colors.green, // Adjust color for low range
        strokeWidth: 0.2,
        strokeColor: Colors.green,
      );
    } else if (spot.y > lowY && spot.y <= midY1) {
      return FlDotCirclePainter(
        radius: 1,
        color: Colors.yellow, // Adjust color for mid range 1
        strokeWidth: 0.2,
        strokeColor: Colors.green,
      );
    } else if (spot.y > midY1 && spot.y <= midY2) {
      return FlDotCirclePainter(
        radius: 1,
        color: Colors.orange, // Adjust color for mid range 2
        strokeWidth: 0.1,
        strokeColor: Colors.green,
      );
    } else if (spot.y > midY2) {
      return FlDotCirclePainter(
        radius: 1,
        color: Colors.red, // Adjust color for high range
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

// Helper functions to find min and max values (assuming numeric values)
  double _findMin(List<dynamic> values) {
    return values.reduce((min, value) => min < value ? min : value);
  }

  double _findMax(List<dynamic> values) {
    return values.reduce((max, value) => max > value ? max : value);
  }

  List<ChartData> processJsonForChart(NavigationDataDTO navData) {
    List<ChartData> chartData = [];
    List<num> distances = [];
    List<List<num>> points = decodePolyline(navData.routes![0].geometry!);
    double distanceSum = 0.0;

    for (int i = 0; i < points.length - 1; i++) {
      List<num> firstPoint = points[i];
      List<num> secondPoint = points[i + 1];

      num distance = Geolocator.distanceBetween(
          firstPoint[0].toDouble(),
          firstPoint[1].toDouble(),
          secondPoint[0].toDouble(),
          secondPoint[1].toDouble());

      distances.add(distance);

      num? nullChecker = navData.elevations?[i];

      if (nullChecker == null || navData.elevations![i] < 0) {
        continue;
      } else {
        chartData.add(ChartData(
            navData.elevations![i] ?? 0, (i == 0) ? 0 : distanceSum / 1000));
      }

      distanceSum = (distanceSum + distance);
    }

    return chartData;
  }

  Widget buildLegend(List<dynamic> values) {
    // Find minimum and maximum values
    final double minValue = _findMin(values);
    final double maxValue = _findMax(values);

    // Calculate range (avoid division by zero)
    final double range = maxValue > minValue ? maxValue - minValue : 1.0;

    // Calculate proportional thresholds
    const double lowThreshold = 0.25; // 25% of the range
    const double midThreshold1 = 0.50; // 50% of the range
    const double midThreshold2 = 0.75; // 75% of the range

    // Calculate proportional y values
    final double lowY = minValue + lowThreshold * range;
    final double midY1 = minValue + midThreshold1 * range;
    final double midY2 = minValue + midThreshold2 * range;

    // Build legend row
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
            ),
            child: Text(
              '< ${(lowY).round()}m',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.yellow,
            child: Text(
              '< ${(midY1).round()}m',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.orange,
            child: Text(
              '< ${(midY2).round()}m',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Text(
              '> ${maxValue.round()}m',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  /* FlDotPainter calculateColor(FlSpot spot, List<dynamic> values) {
    if (spot.y > 0 && spot.y <= (25 / 100 * (_findMax(values))).round()) {
      return FlDotCirclePainter(
        radius: 1,
        color: Colors.green,
        strokeWidth: 0.2,
        strokeColor: Colors.green,
      );
    } else if (spot.y > (25 / 100 * (_findMax(values))).round() &&
        spot.y <= (25 / 100 * (_findMax(values))).round() * 2) {
      return FlDotCirclePainter(
        radius: 1,
        color: Colors.yellow,
        strokeWidth: 0.2,
        strokeColor: Colors.green,
      );
    } else if (spot.y > (25 / 100 * (_findMax(values))).round() * 2 &&
        spot.y <= (25 / 100 * (_findMax(values))).round() * 3) {
      return FlDotCirclePainter(
        radius: 1,
        color: Colors.orange,
        strokeWidth: 0.1,
        strokeColor: Colors.green,
      );
    } else if (spot.y > (25 / 100 * (_findMax(values))).round() * 3) {
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
  }*/

  String calculateDurance(NavigationDataDTO data) {
    return '${Duration(seconds: data.routes![0].duration!.floor()).inHours}h e '
        '${Duration(seconds: data.routes![0].duration!.floor() % 3600).inMinutes}min'
        ' (${(data.routes![0].distance!.round() / 1000).toStringAsFixed(2)}km)';
  }
}

Widget leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.black,
    fontSize: 13,
  );
  return SideTitleWidget(
    space: 12,
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
    angle: 0.6,
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
