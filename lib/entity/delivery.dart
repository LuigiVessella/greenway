import 'package:greenway/entity/delivery_man.dart';
import 'package:greenway/entity/delivery_package.dart';
import 'package:greenway/entity/vehicle.dart';

class Delivery{
  Vehicle vehicle;
  DeliveryMan deliveryMan;
  Set<DeliveryPackage> deliveryPackages;
  

  Delivery(this.vehicle, this.deliveryMan, this.deliveryPackages);
}