import 'package:flutter/material.dart';

class TrackStatus extends StatelessWidget {
  final String title;
  final bool status;
  const TrackStatus({Key? key,required this.status,required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
              color: status? Colors.green:Color(0xff52575C),
              borderRadius: BorderRadius.circular(50)),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
         title,
          style: TextStyle(
              color: status? Colors.green:Color(0xff52575C),
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
