class OrderItem {
  String name;
  String menuItemId;
  int quantity;

  OrderItem({
    required this.name,
    required this.menuItemId,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: json['name'],
      menuItemId: json['menu_item_id'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'menu_item_id': menuItemId,
      'quantity': quantity,
    };
  }
}

class RazorpayPayment {
  String id;
  double amount;
  int amountPaid;
  int amountDue;
  String currency;
  String receipt;
  String entity;
  String offerId;
  String status;
  int attempts;
  List<String> notes;
  int createdAt;

  RazorpayPayment({
    required this.id,
    required this.amount,
    required this.amountPaid,
    required this.amountDue,
    required this.currency,
    required this.receipt,
    required this.entity,
    required this.offerId,
    required this.status,
    required this.attempts,
    required this.notes,
    required this.createdAt,
  });

  factory RazorpayPayment.fromJson(Map<String, dynamic> json) {
    return RazorpayPayment(
      id: json['id'],
      amount: json['amount'],
      amountPaid: json['amount_paid'],
      amountDue: json['amount_due'],
      currency: json['currency'],
      receipt: json['receipt'],
      entity: json['entity'],
      offerId: json['offer_id'],
      status: json['status'],
      attempts: json['attempts'],
      notes: List<String>.from(json['notes']),
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'amount_paid': amountPaid,
      'amount_due': amountDue,
      'currency': currency,
      'receipt': receipt,
      'entity': entity,
      'offer_id': offerId,
      'status': status,
      'attempts': attempts,
      'notes': notes,
      'created_at': createdAt,
    };
  }
}

class Order {
  String vendorId;
  List<OrderItem> items;
  String paymentStatus;
  String? orderPaymentDetailId;
  String orderId;
  double amount;
  String userId;
  String orderStatus;
  String? delivery_boy_id;
  String? orderInstructions;
  RazorpayPayment? razorpayPayment;
  String? vendorName;
  String? vendorImage;
  int? userLocation;

  Order({
    required this.vendorId,
    required this.items,
    required this.paymentStatus,
    this.orderPaymentDetailId,
    required this.orderId,
    required this.amount,
    required this.userId,
    required this.orderStatus,
    this.delivery_boy_id,
    this.orderInstructions,
    this.razorpayPayment,
    this.vendorName,
    this.vendorImage,
    this.userLocation,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      vendorId: json['vendor_id'],
      items: List<OrderItem>.from(
          json['items'].map((item) => OrderItem.fromJson(item))),
      paymentStatus: json['payment_status'],
      orderPaymentDetailId: json['order_payment_detail_id'],
      orderId: json['order_id'],
      amount: json['amount'].toDouble(),
      userId: json['user_id'],
      orderStatus: json['order_status'],
      delivery_boy_id: json['delivery_boy_id'],
      orderInstructions: json['order_instructions'],
      razorpayPayment: json['razorpay_payment'] != null
          ? RazorpayPayment.fromJson(json['razorpay_payment'])
          : null,
      vendorName: json['vendor_name'],
      vendorImage: json['vendor_image'],
      userLocation: json['user_location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vendor_id': vendorId,
      'items': items.map((item) => item.toJson()).toList(),
      'payment_status': paymentStatus,
      'order_payment_detail_id': orderPaymentDetailId,
      'order_id': orderId,
      'amount': amount,
      'user_id': userId,
      'order_status': orderStatus,
      'delivery_boy_id': delivery_boy_id,
      'order_instructions': orderInstructions,
      'razorpay_payment': razorpayPayment?.toJson(),
      'vendor_name': vendorName,
      'vendor_image': vendorImage,
      'user_location': userLocation,
    };
  }
}
