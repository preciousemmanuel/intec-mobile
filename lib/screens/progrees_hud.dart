import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:kabukabu_driver/common/constant/util.dart';
// import 'package:kabukabu_driver/common/themes/app_colors.dart';

class ProgressHUD extends StatelessWidget {
  final Widget? child;
  final bool? inAsyncCall;
  final double? opacity;
  final Color? color;
  final Animation<Color>? valueColor;

  const ProgressHUD({
    Key? key,
    @required this.child,
    @required this.inAsyncCall,
    this.opacity = 0,
    this.color = Colors.white,
    this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = <Widget>[];
    widgetList.add(child!);
    if (inAsyncCall!) {
      final modal = Stack(
        children: [
          Opacity(
            opacity: 0.8,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color:  Color(0xFF161616),
            ),
          ),
          Container(
            child: Center(
              child: Image.asset(
                "assets/images/Loader.gif",
                height: 70.0,
                width: 70.0,
              ),
            ),
          ),
        ],
      );
      widgetList.add(modal);
    }
    return Scaffold(
      body: Stack(
        children: widgetList,
      ),
    );
  }
}
