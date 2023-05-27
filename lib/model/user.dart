class Profile {
  final String uid;
  final int userType;
   Map<String, dynamic> location;
  final String name;
  final String email;
  final String token;
  final String phone;
  final String serviceId;
  final String subServiceId;
  bool? busy;
  String address;
  String? state;
  String? imageUrl;

  bool expired;
  bool hasSubscribed;
  bool active;
  bool blocked;
  bool verified;


  Profile(
      {required this.name,
      required this.email,
      required this.token,
      required this.uid,
       this.location=const {"lon":0.00,"lang":0.00},
      required this.userType,
      required this.phone,
      this.serviceId = "",
      this.subServiceId = "",
      this.address = "",
      this.imageUrl="",
      this.busy,
      this.active=true,
      this.expired=false,
      this.hasSubscribed=false,
      this.state,
      this.blocked=false,
      this.verified=false

      
      });
}
