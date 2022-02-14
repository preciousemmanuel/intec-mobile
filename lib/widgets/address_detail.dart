import 'package:flutter/material.dart';

class AddressDetail extends StatelessWidget {
  int userType;
  String startAddress;
  String? destinationAdress;
  AddressDetail(
      {Key? key,
      required this.userType,
      required this.startAddress,
      this.destinationAdress})
      : super(key: key);

  Widget _buildAdress(context) {
    if (userType == 3) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Pickup Location",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        SizedBox(
          height: 5.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.home,
              color: Theme.of(context).accentColor,
            ),
            Expanded(child: Text(startAddress,style:TextStyle(color: Color(0xff52575C)))),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Text("Destination Location",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        SizedBox(
          height: 5.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.place,
              color: Theme.of(context).accentColor,
            ),
            Expanded(child: Text(destinationAdress ?? "",style: TextStyle(color: Color(0xff52575C)),)),
          ],
        )
      ]);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text("Location",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      SizedBox(
        height: 10.0,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.location_city,
            color: Theme.of(context).accentColor,
          ),
          Expanded(child: Text(startAddress,style:TextStyle(color: Color(0xff52575C)))),
        ],
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return _buildAdress(context);
  }
}
