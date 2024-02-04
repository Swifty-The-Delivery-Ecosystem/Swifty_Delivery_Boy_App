import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swifty_delivery_boy/providers/deliveryBoyProvider.dart';
import 'package:swifty_delivery_boy/providers/ordersProvider.dart';
import 'package:swifty_delivery_boy/providers/updateOrderProvider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    // Fetch orders when the widget is built
    Provider.of<OrdersProvider>(context, listen: false).getOrders(
      Provider.of<DeliveryBoyProvider>(context, listen: false).deliveryBoyID,
      Provider.of<DeliveryBoyProvider>(context, listen: false).token,
    );
  }

  @override
  Widget build(BuildContext context) {
    DeliveryBoyProvider deliveryBoyProvider =
        context.read<DeliveryBoyProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Assigned Orders'),
        backgroundColor: Colors.indigo, // Dark blue app bar
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display orders using Card view
            Expanded(
              child: Consumer<OrdersProvider>(
                builder: (context, ordersProvider, _) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      await ordersProvider.getOrders(
                        deliveryBoyProvider.deliveryBoyID,
                        deliveryBoyProvider.token,
                      );
                    },
                    child: ListView.builder(
                      itemCount: ordersProvider.orders.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 3, // Add elevation for a subtle shadow
                          margin: EdgeInsets.all(8),
                          color: Colors.lightBlue[50], // Light blue card color
                          child: ListTile(
                            title: Text(
                              'Order ID: ${ordersProvider.orders[index].orderId}',
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order Amount: ${ordersProvider.orders[index].amount}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Delivery Items:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                // Displaying delivery items
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: ordersProvider.orders[index].items
                                      .map((item) => Text(
                                          '${item.name} x ${item.quantity}'))
                                      .toList(),
                                ),
                                SizedBox(height: 8),
                                Text('Update Order Status:'),
                                DropdownButton<String>(
                                  value:
                                      ordersProvider.orders[index].orderStatus,
                                  onChanged: (String? newValue) async {
                                    if (newValue != null) {
                                      ordersProvider.orders[index].orderStatus =
                                          newValue;
                                      ordersProvider.notifyListeners();

                                      if (newValue == 'Arrived' ||
                                          newValue == 'Delivered') {
                                        String orderId = ordersProvider
                                            .orders[index].orderId;
                                        String token =
                                            Provider.of<DeliveryBoyProvider>(
                                                    context,
                                                    listen: false)
                                                .token;

                                        // Call the UpdateOrderProvider to update the order status
                                        int responseCode = await Provider.of<
                                                    UpdateOrderProvider>(
                                                context,
                                                listen: false)
                                            .updateOrder(orderId,
                                                newValue.toLowerCase(), token);

                                        // Show Snackbar based on the response code
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(responseCode == 200 ||
                                                    responseCode == 201
                                                ? 'Order Updated Successfully'
                                                : 'Error updating order: $responseCode'),
                                          ),
                                        );

                                        // If the order is delivered, remove it from the list
                                        if (newValue == 'Delivered') {
                                          ordersProvider.orders.removeAt(index);
                                          ordersProvider.notifyListeners();
                                        }
                                      }
                                    }
                                  },
                                  items: ordersProvider
                                      .getAvailableOrderStatuses(ordersProvider
                                          .orders[index].orderStatus)
                                      .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            // Add more details as needed
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
