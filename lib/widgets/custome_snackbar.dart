import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomSnackbar extends StatelessWidget {
  // final GlobalKey<ScaffoldState> scaffoldkey;
  String title;
  bool status;
  CustomSnackbar({required this.status, required this.title});
  // const CustomSnackbar({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Text(title),
      backgroundColor: status?Colors.green:Colors.red,
    );
  }
}
