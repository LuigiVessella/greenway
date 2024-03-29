import 'package:http/http.dart' as http;

class HttpDeliveryResponse {
    var client = http.Client();

    Future<void> addDelivery(Delivery delivery){
      var response = await client.post(
        Uri.http('authority'),
        body: {''}
      );
      

    }
    Future<void> deleteDelivery(Delivery delivery){

    }
    Future<void> updateDelivery(Delivery delivery){

    }
    Future<List<Delivery>> getDelivery(){
      
    }

    factory DeliveryRepositories.fromJSon(Map<String, dynamic> data) {
      return 
    }
}