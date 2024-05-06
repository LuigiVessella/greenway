import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:greenway/dto/elevation_data_dto.dart';

/*class ElevationChart extends StatelessWidget {
  final List<ElevationDataDTO> data;

  const ElevationChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TimeSeriesChart(
      sortedData: data
          .map((datum) => TimeSeriesDatum<ElevationData>(
                datum,
                DateTime.fromMillisecondsSinceEpoch(
                    (datum.latitude * 100000).round()),
                elevation: datum.elevation,
              ))
          .toList(),
      domainAxis: NumericAxis(
        label: const Text('Distanza (m)'),
      ),
      mainAxis: NumericAxis(
        label: const Text('Elevazione (m)'),
      ),
      series: [
        LineSeries<ElevationData>(
          data: data
              .map((datum) => TimeSeriesDatum<ElevationData>(
                    datum,
                    DateTime.fromMillisecondsSinceEpoch(
                        (datum.latitude * 100000).round()),
                    elevation: datum.elevation,
                  ))
              .toList(),
          color: Colors.blue,
          displayName: 'Elevazione del terreno',
        ),
      ],
      animationDuration: const Duration(milliseconds: 500),
    );
  }
}
*/