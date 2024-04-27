import 'package:flutter/material.dart';
import 'package:greenway/presentation/pages/admin_page.dart';

class TabOne extends StatelessWidget {
  const TabOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const AdminPage()
    );
  }
}

class TabTwo extends StatelessWidget {
  const TabTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const Text('Qui vedrai dati su mappa ed elevazione'),
    );
  }
}

class TabTree extends StatelessWidget {
  const TabTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const Text('Qui vedrai un riepilogo ed il rendimento'),
    );
  }
}
