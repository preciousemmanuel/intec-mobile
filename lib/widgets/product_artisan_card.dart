// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intechpro/model/currency.dart';
import 'package:intechpro/model/product.dart';
import 'package:intechpro/model/request_model.dart';
import 'package:intechpro/model/service.dart';
import 'package:intl/intl.dart';

class ProductArtisanCard extends StatelessWidget {
  final Function onTap;
  final String type;
  final Product product;
  ProductArtisanCard({
    Key? key,
    required this.onTap,
    required this.product,
    this.type = "customer",
  }) : super(key: key);

  

   
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            )
          ]),
      child: ListTile(
          onTap: () {
            onTap();
          },
          leading: Icon(
            Icons.import_export,
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            product.name,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
          ),
          subtitle: Text(
            product.description,
            style: TextStyle(fontSize: 10),
          ),
          trailing: 
              Text(
                currency.symbol+
                product.cost.toString(),
                style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
              ),
             
          ),
    );
  }
}
