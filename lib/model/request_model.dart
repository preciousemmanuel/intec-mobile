// ignore_for_file: non_constant_identifier_names

class Request {
  final String uid;
  final String customer_id;
  final String customer_name;
  final String customer_phone;
  late String artisan_name;
  late String artisan_phone;
  final Map<String,dynamic> customer_location;
  late Map<String,dynamic> artisan_location;
  final int paymentMode;
  final int userType;
  final int requestStatus;
  final double amount;
  final String service_id;
  final String parent_service_id;
  final String service_name;
  String? request_address;
  String? destination_address;
  String? createdTime;

  Request(
      {
        required this.uid,
        required this.customer_id,
      required this.service_id,
      required this.customer_name,
      required this.customer_phone,
       this.artisan_name="",
       this.artisan_phone="",
      required this.customer_location,
       this.artisan_location=const {},
      required this.paymentMode,
      required this.requestStatus,
      required this.amount,
      required this.service_name,
      this.request_address,
      this.createdTime,
      required this.userType,
       this.destination_address,
      required this.parent_service_id,
      });
}
