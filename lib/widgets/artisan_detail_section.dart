import 'package:flutter/material.dart';

class ArtisanDetailSection extends StatelessWidget {
 Map<dynamic,dynamic>? request; 
  ArtisanDetailSection({ Key? key ,this.request}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
         Divider(),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                request?["userType"] == 2
                  ? "Artisan Details"
                  : request?["userType"] == 3
                      ? "Truck Driver Details"
                      : "Supplier Details",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(50)),
                  child: Image.asset(
                    "assets/images/user.png",
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    Text(
                      "Name",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).accentColor),
                    ),
                    Text(request?["artisan"]["name"])
                  ],
                ),
                SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Phone",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).accentColor),
                      ),
                      Text(request?["requestStatus"]<3?"*************" : request?["artisan"]["phone"])
                    ],
                  ),
                )
              ],
            ),
          ),
          Divider()
        ],
      );
   
  }
}