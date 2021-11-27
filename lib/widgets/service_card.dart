import 'package:flutter/material.dart';
import 'package:intechpro/model/service.dart';

class ServiceCard extends StatelessWidget {
  final Function onTap;
  final String type;
  final service;
  ServiceCard(
      {Key? key,
      required this.onTap,
      required this.service,
      this.type = "service"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onTap(),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                )
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                type == "subservice"
                    ? "assets/images/repair-tool.png"
                    : "assets/images/service.png",
                width: 50,
                height: 50,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                service.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
              )
            ],
          ),
        ));
  }
}
