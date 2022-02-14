import 'package:flutter/material.dart';
import 'package:intechpro/model/sub_service.dart';
import 'package:intechpro/model/user.dart';
import 'package:intechpro/providers/profile_provider.dart';
import 'package:intechpro/providers/service_provider.dart';
import 'package:provider/provider.dart';

import 'home_artisan_screen.dart';

class CompleteProfileScreen extends StatefulWidget {
  int userType;
  CompleteProfileScreen({Key? key, required this.userType}) : super(key: key);

  @override
  _CompleteProfileScreenState createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  String _selectedService = "";
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<ServiceProvider>(context, listen: false)
          .fetch_service_and_sub_by_userType(widget.userType);
    });
  }

  void _handleRadioValueChanged(value) {
    setState(() => _selectedService = value);
  }

  Widget _buildItemCard(SubService subservice) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Color(0xff6680a1)),
        child: ListTile(
            onTap: () {
              setState(() {
                _selectedService = subservice.uid;
              });
            },
            title: Text(
              subservice.name,
              style: TextStyle(color: Colors.white),
            ),
            leading: Radio(
                value: subservice.uid,
                groupValue: _selectedService,
                onChanged: _handleRadioValueChanged)),
      ),
    );
  }

  void ShowSnackBar(String title, bool status) {
    final snackbar = SnackBar(
      content: Text(title),
      backgroundColor: status ? Colors.green : Colors.red,
    );
    scaffoldkey.currentState!.showSnackBar(snackbar);
  }

  void handleCompleteProfile() async {
    if (_selectedService == "") {
      ShowSnackBar("Please choose your service", false);
      return;
    }
    Map<String, dynamic> response = await context
        .read<ProfileProvider>()
        .saveArtisanWorkCategory(
            Provider.of<ServiceProvider>(context, listen: false).getService.uid,
            _selectedService);
    if (response["status"]) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeArtisanScreen()),
      );
    } else {
      ShowSnackBar(response["message"], false);
    }
    print(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Choose Service",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        actions: [
          context.watch<ProfileProvider>().getSubmitting
              ? CircularProgressIndicator()
              : TextButton(
                  onPressed: () {
                    handleCompleteProfile();
                  },
                  child: Text(
                    "Next",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  image: AssetImage("assets/images/background-img.jpg"),
                  fit: BoxFit.cover)

              //image: DecorationImage(image: AssetImage("assets/images/backgound.jpg"),fit: BoxFit.cover)
              ),
          child: context.watch<ServiceProvider>().getLoading
              ? Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Please Wait...")
                    ],
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(context.watch<ServiceProvider>().getService.name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                          "Please Choose a particular ${context.watch<ServiceProvider>().getService.name} you want to specialize"),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 10,
                            );
                          },
                          itemCount: context
                              .watch<ServiceProvider>()
                              .getSubServices
                              .length,
                          itemBuilder: (BuildContext context, int index) {
                            SubService subservice = context
                                .watch<ServiceProvider>()
                                .getSubServices[index];
                            return _buildItemCard(subservice);
                          }),
                    ),
                    SizedBox(height:100)
                  ],
                ),
        ),
      ),
    );
  }
}
