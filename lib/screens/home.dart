import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    String getLocationName(int location) {
      switch (location) {
        case 1:
          return 'Kanhar';
        case 2:
          return 'Indravati';
        case 3:
          return 'MSH';
        case 4:
          return 'Delta';
        default:
          return 'Unknown Location';
      }
    }

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
                          elevation: 4,
                          margin: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.location_on_outlined,
                                            size: 20, color: Colors.grey[600]),
                                        SizedBox(width: 8),
                                        Text(
                                          '${getLocationName(ordersProvider.orders[index].userLocation!)}',
                                          style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Rs ${ordersProvider.orders[index].amount}',
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Order ID: ${ordersProvider.orders[index].orderId}',
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Delivery Items:',
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: ordersProvider.orders[index].items
                                      .map((item) => Text(
                                            '• ${item.name} x ${item.quantity}',
                                            style: GoogleFonts.roboto(
                                              fontSize:
                                                  16, // Increased font size for better readability
                                              color: Colors.grey[700],
                                            ),
                                          ))
                                      .toList(),
                                ),
                                SizedBox(height: 6),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          size: 20,
                                          color: Colors.grey[600],
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Update Order Status:',
                                          style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                    DropdownButton<String>(
                                      value: ordersProvider
                                          .orders[index].orderStatus,
                                      onChanged: (String? newValue) async {
                                        if (newValue != null) {
                                          ordersProvider.orders[index]
                                              .orderStatus = newValue;
                                          ordersProvider.notifyListeners();

                                          if (newValue == 'Arrived' ||
                                              newValue == 'Delivered') {
                                            String orderId = ordersProvider
                                                .orders[index].orderId;
                                            String token = Provider.of<
                                                        DeliveryBoyProvider>(
                                                    context,
                                                    listen: false)
                                                .token;

                                            int responseCode = await Provider
                                                    .of<UpdateOrderProvider>(
                                                        context,
                                                        listen: false)
                                                .updateOrder(
                                                    orderId,
                                                    newValue.toLowerCase(),
                                                    token);

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(responseCode ==
                                                            200 ||
                                                        responseCode == 201
                                                    ? 'Order Updated Successfully'
                                                    : 'Error updating order: $responseCode'),
                                              ),
                                            );

                                            if (newValue == 'Delivered') {
                                              ordersProvider.orders
                                                  .removeAt(index);
                                              ordersProvider.notifyListeners();
                                            }
                                          }
                                        }
                                      },
                                      items: ordersProvider
                                          .getAvailableOrderStatuses(
                                              ordersProvider
                                                  .orders[index].orderStatus)
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        color: Colors.grey[800],
                                      ),
                                      dropdownColor: Colors.white,
                                      elevation: 4,
                                      underline: Container(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
