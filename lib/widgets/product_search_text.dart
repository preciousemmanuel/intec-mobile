import 'package:flutter/material.dart';

class ProductSearch extends StatelessWidget {
  final Function onChange;
  final Function onRefreshed;
  const ProductSearch({Key? key, required this.onChange,required this.onRefreshed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        onChanged: (e)=>onChange(e),
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
              color: Theme.of(context).accentColor)),
            prefixIcon: Icon(
              Icons.search,
              color: Color(0xff52575C),
            ),
            suffixIcon:IconButton(
              onPressed: ()=>onRefreshed(),
              icon: Icon(
                Icons.refresh,
                color: Color(0xff52575C),
              ),
            ) ,
            hintText: "Search Product"),
      ),
    );
  }
}
