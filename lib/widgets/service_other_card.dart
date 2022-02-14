import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intechpro/model/service.dart';

class ServiceOtherCard extends StatelessWidget {
  final Function onTap;
   Function? onLongPress;
  final String type;
  final service;
  bool? isSelected=false;
  ServiceOtherCard(
      {Key? key,
      required this.onTap,
      required this.service,
      this.onLongPress,
      this.isSelected,
      this.type = "service"})
      : super(key: key);

      Widget _buildImage(){
        if (type=="service") {
          if (service.name=="Home Service") {
            return  Image.asset(
                type == "subservice"
                    ? "assets/images/customer-service.png"
                    : "assets/images/house-repair.png",
                width: 30,
                height: 30,
              );
          }else if (service.name=="Truck Service") {
            return  Image.asset(
                type == "subservice"
                    ? "assets/images/customer-service.png"
                    : "assets/images/tow-truck.png",
                width: 30,
                height: 30,
              );
          }else if (service.name=="Materials Suppliers") {
            return  Image.asset(
                type == "subservice"
                    ? "assets/images/customer-service.png"
                    : "assets/images/supplier.png",
                width: 30,
                height: 30,
              );
          }
          
           else {
             return  Image.asset(
                type == "subservice"
                    ? "assets/images/customer-service.png"
                    : "assets/images/service.png",
                width: 30,
                height: 30,
              );
          }
        } else {
           return  Image.asset(
                type == "subservice"
                    ? "assets/images/customer-service.png"
                    : "assets/images/service.png",
                width: 30,
                height: 30,
              );
        }
        
      }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color:isSelected!=null && isSelected!?Colors.grey  :Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              )
            ]),
        child: ListTile(
          onLongPress: ()=>onLongPress!(),
          onTap: () => onTap(),
          leading:_buildImage() ,
title:service.name.contains("Not Listed")? Text(service.name,style:TextStyle(color: Colors.red)):Text(service.name,),
        )
      ),
    );
  }
}
