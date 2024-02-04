class DeliveryBoyModel {
  late String name;
  late String? vendor_id;
  late String phone;
  late int? otp; // Marking OTP as nullable
  bool isAvailable;

  DeliveryBoyModel(
      {required this.name,
      required this.phone,
      this.otp,
      required this.isAvailable,
      this.vendor_id});

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone": phone,
      "vendor_id": vendor_id,
      "otp": otp,
      "isAvailable": isAvailable
    };
  }
}
