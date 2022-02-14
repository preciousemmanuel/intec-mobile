import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intechpro/model/currency.dart';
import 'package:intechpro/model/service.dart';
import 'package:intechpro/providers/service_provider.dart';
import 'package:provider/provider.dart';

class ServiceOtherCardHome extends StatefulWidget {
  final Function onTap;
  Function? onLongPress;
  final String type;
  final service;
  int numberTask;
  bool? isSelected = false;
  int? indexCount;
  ServiceOtherCardHome(
      {Key? key,
      required this.onTap,
      required this.service,
      this.onLongPress,
      this.isSelected,
      this.indexCount,
      required this.numberTask,
      this.type = "service"})
      : super(key: key);

  @override
  _ServiceOtherCardHomeState createState() => _ServiceOtherCardHomeState();
}

class _ServiceOtherCardHomeState extends State<ServiceOtherCardHome> {
  List<int> _num_services = [];
  int selected_num_services = 1;
  void initState() {
    super.initState();

    for (var i = 1; i <= 100; i++) {
      _num_services.add(i);
    }
  }

 void onSelectedTaskCount(val) {
    print("sher@##");
    
   // setState(() {
      
     context.read<ServiceProvider>().numberOfTaskSelected(widget.indexCount,val);
      
  //  });
    
  }

  _showDropdown() {
    if (widget.isSelected == true) {
      return DropdownButton(
          value: widget.numberTask,
          items: _num_services.map((e) {
            return DropdownMenuItem(
              child: Text(e.toString()),
              value: e,
            );
          }).toList(),
          onChanged: onSelectedTaskCount);
    }
  }

  Widget _buildImage() {
    if (widget.type == "service") {
      if (widget.service.name == "Home Service") {
        return Image.asset(
          widget.type == "subservice"
              ? "assets/images/customer-service.png"
              : "assets/images/house-repair.png",
          width: 30,
          height: 30,
        );
      } else if (widget.service.name == "Truck Service") {
        return Image.asset(
          widget.type == "subservice"
              ? "assets/images/customer-service.png"
              : "assets/images/tow-truck.png",
          width: 30,
          height: 30,
        );
      } else if (widget.service.name == "Materials Suppliers") {
        return Image.asset(
          widget.type == "subservice"
              ? "assets/images/customer-service.png"
              : "assets/images/supplier.png",
          width: 30,
          height: 30,
        );
      } else {
        return Image.asset(
          widget.type == "subservice"
              ? "assets/images/customer-service.png"
              : "assets/images/service.png",
          width: 30,
          height: 30,
        );
      }
    } else {
      return Image.asset(
        widget.type == "subservice"
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
              color: widget.isSelected != null && widget.isSelected!
                  ? Colors.grey
                  : Colors.white,
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
            onLongPress: () => widget.onLongPress!(),
            onTap: () => widget.onTap(),
            leading: _buildImage(),
            trailing: _showDropdown(),
            subtitle: widget.service.cost==0?Container():Text("Cost: "+currency.symbol+widget.service.cost.toString()),
            title: widget.service.cost==0
                ? Text(widget.service.name, style: TextStyle(color: Colors.red))
                : Text(
                    widget.service.name,
                  ),
          )),
    );
  }
}
