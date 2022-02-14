import 'package:flutter/material.dart';
import 'package:intechpro/model/service.dart';

class FindArtisanScreen extends StatefulWidget {
  Service? parentService;
   FindArtisanScreen({Key? key,this.parentService}) : super(key: key);

  @override
  _FindArtisanScreenState createState() => _FindArtisanScreenState();
}

class _FindArtisanScreenState extends State<FindArtisanScreen> {

   Widget _buildSearchingArtisan(){
    return Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            ),
            Text(
              widget.parentService!.userType == 2
                  ? "Searching for the best Artisan for you. Please wait..."
                  : widget.parentService!.userType == 3
                      ? "Searching for the best Truck Driver for you. Please wait..."
                      : "Searching for the best Supplier for you. Please wait...",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            )
          ],
        ),
      );
    
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(

        ),
      ),
    );
  }
}
