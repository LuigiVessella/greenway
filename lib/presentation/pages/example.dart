import 'package:flutter/material.dart';
import 'package:greenway/components/delivery_status.dart';

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2.0,
        title: const Column(children: [
          Text('Shipping N°'),
          Text("1"),
        ]),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 48,
            bottom: 16,
          ),
          children: const [
            OrderStatusItemView(
              color: Colors.amber,
              title: 'Processing',
              subtitle: 'Your order is being processed.',
              icon: Icons.hourglass_top_outlined,
              showLine: true,
              isActive: true,
            ),
            OrderStatusItemView(
              color: Colors.blue,
              title: 'In Transit',
              subtitle: 'Your order is on it\'s way to you.',
              icon: Icons.local_shipping_outlined,
              showLine: true,
              isActive: true,
            ),
            OrderStatusItemView(
              color: Colors.green,
              title: 'Delivered',
              subtitle: 'Thank you for shopping with us.',
              icon: Icons.task_alt_outlined,
              showLine: false,
              isActive: true,
            ),
          ],
        ),
      ),
    );
  }
}
