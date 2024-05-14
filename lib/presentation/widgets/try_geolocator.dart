import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:greenway/config/themes/first_theme.dart';

class TryAltitude extends StatefulWidget {
  const TryAltitude({super.key});

  @override
  State<TryAltitude> createState() => _TryAltitudeState();
}

class _TryAltitudeState extends State<TryAltitude> {
  double? _elevation;
  double? _lat;
  double? _long;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
        _getElevation();

  }

  Future<void> _getElevation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      
      _elevation = position.altitude;
      _lat = position.latitude;
      _long = position.longitude;

      debugPrint('$_elevation');
    } catch (e) {
      print("Error getting elevation: $e");
    }

    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Altitude: $_elevation',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'Latitude: $_lat',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'Longitude: $_long',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}