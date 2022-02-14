class SubService {
  final String uid;
  final String name;
  final bool visible;
  final int cost;
  final String serviceId;
  String? price_guide="";
  bool hasTask;

  SubService(
      {required this.name,
      required this.uid,
      required this.visible,
      required this.serviceId,
      this.cost=0,
      this.hasTask=false,
      this.price_guide
      });
}
