import 'package:flutter/material.dart';

class VSpace extends StatelessWidget {
  const VSpace(this.length, {Key? key}) : super(key: key);

  final double length;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: length,
    );
  }
}

class HSpace extends StatelessWidget {
  const HSpace(this.length, {Key? key}) : super(key: key);

  final double length;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: length,
    );
  }
}
