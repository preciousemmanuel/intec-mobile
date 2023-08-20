import 'package:flutter/material.dart';

class PaymentMethodSection extends StatelessWidget {
  int paymentMethod;
 
  PaymentMethodSection({Key? key, required this.paymentMethod})
      : super(key: key);


Widget _buildRow(text,context){
 return Row(
        children: [
          Icon(
            Icons.circle_sharp,
            color: Theme.of(context).accentColor,
          ),
          SizedBox(
            width: 20,
          ),
          Text(
           text,
            style: TextStyle(fontWeight: FontWeight.normal),
          )
        ],
      );
}

  Widget _buildView(BuildContext context) {
    if (paymentMethod == 1) {
      return _buildRow("PAYMENT METHOD: ONLINE",context);
    } else if (paymentMethod == 2) {
        return _buildRow("PAYMENT METHOD: WALLET",context);
     
    }else if(paymentMethod == 3){
return _buildRow("PAYMENT METHOD: CASH",context);
    }

    return Container();

    
  }

  @override
  Widget build(BuildContext context) {
    return _buildView(context);
  }
}
