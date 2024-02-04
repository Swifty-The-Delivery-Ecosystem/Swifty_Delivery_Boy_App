import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swifty_delivery_boy/providers/deliveryBoyProvider.dart';
import 'package:swifty_delivery_boy/providers/ordersProvider.dart';
import 'package:swifty_delivery_boy/providers/updateOrderProvider.dart';
import 'package:swifty_delivery_boy/screens/home.dart';
import 'package:swifty_delivery_boy/screens/login.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => DeliveryBoyProvider()),
      ChangeNotifierProvider(create: (context) => OrdersProvider()),
      ChangeNotifierProvider(create: (context) => UpdateOrderProvider())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => Home());
          case '/login':
            return MaterialPageRoute(builder: (context) => LoginScreen());
        }
      },
    );
  }
}
