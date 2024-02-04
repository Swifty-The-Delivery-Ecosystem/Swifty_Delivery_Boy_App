import "dart:convert";
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swifty_delivery_boy/models/orderModel.dart';

class UpdateOrderProvider extends ChangeNotifier {
  List<Order> orders = []; // Updated to a list of orders

  final String baseUrl =
      'https://order-service-peach.vercel.app/api/v1/order_service';

  Future<int> updateOrder(String order_id, String status, String token) async {
    try {
      print('token $token');
      final response = await http.put(
          Uri.parse(
              'https://order-service-peach.vercel.app/api/v1/order_service/delivery_status'),
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token"
          },
          body: jsonEncode({"order_id": order_id, "status": status}));
      print('response ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
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
}
