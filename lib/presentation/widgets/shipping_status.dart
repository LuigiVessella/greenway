import 'package:flutter/material.dart';
import 'package:greenway/components/delivery_status.dart';
import 'package:greenway/dto/delivery_dman_dto.dart';

class ShippingStatus extends StatelessWidget {
  const ShippingStatus({super.key, required this.delivery});
  final DeliveryDTO delivery; 
  

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 500,
      child: ListView(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 48,
          bottom: 16,
        ),
        children:  [
          OrderStatusItemView(
            color: Colors.amber,
            title: 'Ritiro',
            subtitle: 'In attesa del ritiro del corriere',
            icon: Icons.hourglass_top_outlined,
            showLine: true,
            isActive: delivery.inTransit! ? false : true,
          ),
          OrderStatusItemView(
            color: Colors.blue,
            title: 'In Transito',
            subtitle: 'Il tuo pacco è in viaggio',
            icon: Icons.local_shipping_outlined,
            showLine: true,
            isActive: delivery.inTransit! ? true : false,
          ),
           OrderStatusItemView(
            color: Colors.green,
            title: 'Consegnata',
            subtitle: 'Consegnata',
            icon: Icons.task_alt_outlined,
            showLine: false,
            isActive: (delivery.deliveryTime!=null) ? true : false,
          ),
        ],
      ),
    );
  }
}
