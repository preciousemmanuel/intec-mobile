

import 'package:flutter/material.dart';
import 'package:intechpro/providers/profile_provider.dart';
import 'package:provider/provider.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({ Key? key }) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}




class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey();
   TextEditingController _phoneController = new TextEditingController();
   TextEditingController _nameController = new TextEditingController();
   TextEditingController _addressController = new TextEditingController();
   TextEditingController _emailAddressController = new TextEditingController();

@override
  initState(){
  super.initState();
WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    _nameController.text=  Provider.of<ProfileProvider>(context, listen: false).profile.name;
    _emailAddressController.text=  Provider.of<ProfileProvider>(context, listen: false).profile.email;
    _phoneController.text=  Provider.of<ProfileProvider>(context, listen: false).profile.phone;
    _addressController.text=  Provider.of<ProfileProvider>(context, listen: false).profile.address;
          
    });
  

}

 void ShowSnackBar(String title, bool status) {
    final snackbar = SnackBar(
      content: Text(title),
      backgroundColor: status ? Colors.green : Colors.red,
    );
    scaffoldkey.currentState!.showSnackBar(snackbar);
  }

void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
  
    
    Map<String, dynamic> data = await context
        .read<ProfileProvider>()
        .updateprofile(_nameController.text, _phoneController.text.trim(),_addressController.text);
   
    if (data["status"]) {
      print("success");
      ShowSnackBar(data["message"], true);
       Navigator.of(context).pop(
                       
                      );
    } else {
      // ignore: deprecated_member_use
      ShowSnackBar(data["message"], false);
    }
    print("login file");
    print(data);
  }

  
 Widget _buildSubmitButton() {
    return
    
     context.watch<ProfileProvider>().getSubmitting
        ? CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))
        :
         Container(
            height: 50.0,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (){
                _handleSubmit();
              },
              child: Text("Update Now"),
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor),
            ),
          );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Update Profile"),
      ),
      body: SingleChildScrollView(child: 
      Container(
         height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  image: AssetImage("assets/images/background-front.jpg"),
                  fit: BoxFit.cover)

              //image: DecorationImage(image: AssetImage("assets/images/backgound.jpg"),fit: BoxFit.cover)
              ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
          
              children: [
                SizedBox(
                  height: 20,
                ),
                Text("Update  your profile details",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),
                SizedBox(
                  height: 20,
                ),
          
                TextFormField(
                  
                 //initialValue: context.watch<ProfileProvider>().profile.name,
                           controller: _nameController,
                            validator: (value) {
                              if (value == "") {
                                return "Please Enter Fullname";
                              }
                            },
                            decoration: InputDecoration(
                              
                                labelText: "Full Name",
                                // filled: true,
                                labelStyle: TextStyle(color: Color(0xff52575C)),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Color(0xff52575C),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).accentColor)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff52575C)))),
                           // onSaved: (value) => _email = value!
                            ),
                             SizedBox(height: 20,),
          
                  TextFormField(
                   // initialValue: context.watch<ProfileProvider>().profile.email,
                           controller: _emailAddressController,
                            validator: (value) {
                              if (value == "") {
                                return "Please Enter Email";
                              }
                            },
                            decoration: InputDecoration(
                              enabled: false,
                                labelText: "Email",
                                // filled: true,
                                labelStyle: TextStyle(color: Color(0xff52575C)),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Color(0xff52575C),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).accentColor)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff52575C)))),
                           // onSaved: (value) => _email = value!
                            ),
          
                            SizedBox(height: 20,),
          
                            TextFormField(
                             // initialValue: context.watch<ProfileProvider>().profile.phone,
                           controller: _phoneController,
                            validator: (value) {
                              if (value == "") {
                                return "Please Enter Phone Number";
                              }
                            },
                            decoration: InputDecoration(
          
                                labelText: "Phone Number",
                                // filled: true,
                                labelStyle: TextStyle(color: Color(0xff52575C)),
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Color(0xff52575C),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).accentColor)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff52575C)))),
                           // onSaved: (value) => _email = value!
                            ),
                             SizedBox(height: 20,),
          
                            TextFormField(
                             // initialValue: context.watch<ProfileProvider>().profile.address,
                          controller: _addressController,
                            validator: (value) {
                              if (value == "") {
                                return "Please Enter Your Residentcial Address";
                              }
                            },
                            decoration: InputDecoration(
                                labelText: "Location(City/State/ Country)",
                                // filled: true,
                                labelStyle: TextStyle(color: Color(0xff52575C)),
                                prefixIcon: Icon(
                                  Icons.place,
                                  color: Color(0xff52575C),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color:Theme.of(context).accentColor)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff52575C)))),
                           // onSaved: (value) => _email = value!
                            ),
          
                            SizedBox(height: 40,),
                            _buildSubmitButton(),
              ],
            ),
          ),
        ),
      )
      ,),
    );
  }
}