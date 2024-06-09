import 'package:flutter/material.dart';
import 'package:greenway/presentation/pages/admin_page.dart';
import 'package:greenway/presentation/pages/web_pages/delivery_web_tab.dart';
import 'package:greenway/presentation/widgets/web_widget/vehicle_list_web.dart';

class TabOne extends StatelessWidget {
  const TabOne({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminPage();
    
  }
}

class TabTwo extends StatelessWidget {
  const TabTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return const VechicleListWeb();
  }
}

class TabTree extends StatelessWidget {
  const TabTree({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: DeliveryWebTab(),
    );
  }
}
