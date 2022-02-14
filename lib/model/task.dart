class Task {
  final String uid;
  final String serviceId;
  final String subServiceId;
  final String name;
  final bool visible;
  bool? isSelected=false;
  int? numberSelected=1;
  final int cost;
   String? address;
   String? phone;


  Task(
      {
      required this.name,
      required this.uid,
      required this.visible,
      required this.serviceId,
      required this.subServiceId,
      this.numberSelected,
      this.cost=0,
      this.address,
      this.phone,
      this.isSelected
      });
}
