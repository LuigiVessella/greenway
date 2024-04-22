import 'package:flutter/material.dart';

class WebDashboard extends StatelessWidget {
  const WebDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web Dashboard'),
      ),
      body: const Center(
        child: Text('Web Dashboard'),
      ),
    );
  }
}