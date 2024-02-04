import "dart:convert";
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swifty_delivery_boy/models/deliveryBoyModel.dart';

class DeliveryBoyProvider extends ChangeNotifier {
  late DeliveryBoyModel deliveryboy;
  late String deliveryBoyID = '';
  late String token = '';

  // Initialize deliveryboy with an empty object
  DeliveryBoyProvider()
      : deliveryboy = DeliveryBoyModel(name: '', phone: '', isAvailable: false);

  final String baseUrl =
      'https://auth-six-pi.vercel.app/api/v1/auth/delivery_partner';

  Future<int> login(String phone, int otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'otp': otp,
          'phone': phone,
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        token = responseData['data']['token'];
        deliveryBoyID = responseData['data']['userId'];
        print('Login successful');
        print('Token: $token');
        print('UserID: $deliveryBoyID');
        deliveryboy = DeliveryBoyModel(
            name: responseData['data']['name'],
            phone: responseData['data']['phone'],
            isAvailable: responseData['data']['isAvailable']);
      } else {
        print('Error logging in: ${response.statusCode}');
        // Handle errors as needed
      }
      return response.statusCode;
    } catch (error) {
      print('Error logging in: $error');
      // Handle errors as needed
      return 404;
    }
  }
}
