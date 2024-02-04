import "dart:convert";
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swifty_delivery_boy/models/deliveryBoyModel.dart';
import 'package:swifty_delivery_boy/models/orderModel.dart';

class OrdersProvider extends ChangeNotifier {
  List<Order> orders = []; // Updated to a list of orders

  final String baseUrl =
      'https://order-service-peach.vercel.app/api/v1/order_service';

  Future<int> getOrders(String deliveryBoyId, String token) async {
    try {
      print('order token $token');
      print('deliveryBoyId $deliveryBoyId');
      final response = await http.get(
        Uri.parse(
            'https://order-service-peach.vercel.app/api/v1/order_service/delivery_boy/orders/$deliveryBoyId'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> ordersJson = jsonDecode(response.body)['orders'];

        orders = ordersJson.map((order) => Order.fromJson(order)).toList();

        print(
            "kbwelw euh;ohgquohw4ouh heroghoerhoer hgoher[ ogq832075893579874598 hello]");
        print(orders);

        // Notify listeners about the change
        notifyListeners();
      } else {
        print('Error getting orders1: ${response.statusCode}');
        // Handle errors as needed
      }
      return response.statusCode;
    } catch (error) {
      print('Error getting orders2: $error');
      // Handle errors as needed
      return 404;
    }
  }

  List<String> getAvailableOrderStatuses(String currentStatus) {
    // Return a list with the current status, 'Arrived', and 'Delivered'
    return [currentStatus, 'Arrived', 'Delivered'].toSet().toList();
  }
}
