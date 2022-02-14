import 'package:flutter/material.dart';

class CancelTile extends StatelessWidget {
 final String title;
 final selected;
 final Function onTap;
 final Function onChanged;

  const CancelTile({ Key? key,required this.title,required this.selected,required this.onTap,required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap:()=>onTap(),
      leading: Radio(value: title, groupValue: selected, onChanged: (e)=>onChanged),
      title:Text(title) ,
    );
  }
}