// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intechpro/data/states.dart';
import 'package:intechpro/providers/authentication_service.dart';
import 'package:intechpro/screens/home_screen.dart';
import 'package:intechpro/screens/registration_succes_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscureText = true;
  bool _isSignup = false;
  int _userType = 1;
  List _listIdentification = [
    "Select type of Identification",
    "National Identification",
    "International Passport",
    "Drivers Licence",
    "Voters Card"
  ];
  bool isCheckTerms = false;
  String _state = states[0];
  String _identification = "";
  String _address = "";
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _phoneNumberController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _identificationNumberController =
      new TextEditingController();

  TextEditingController _passwordController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey();

  void _handleRadioValueChanged(value) {
    setState(() => _userType = value);
  }

  void ShowSnackBar(String title, bool status) {
    final snackbar = SnackBar(
      content: Text(title),
      backgroundColor: status ? Colors.green : Colors.red,
    );
   ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void _handleSubmit() async {
    if (!isCheckTerms) {
      ShowSnackBar("Please check the terms and condition", false);
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isSignup = true;
    });

    Map<String, dynamic> data = await context
        .read<AuthenticationService>()
        .signUp(
            _nameController.text,
            _passwordController.text,
            _phoneNumberController.text,
            _emailController.text.trim(),
            _userType,
            _addressController.text,
            _state,
            _identification,
            _identificationNumberController.text);
    setState(() {
      _isSignup = false;
    });
    if (data["status"]) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (_) => RegistrationSuccessScreen(
                  userType: _userType,
                )),
      );
      // if (_userType == 1) {
      //   //redirect to home

      //   //  Navigator.of(context).push(
      //   //   MaterialPageRoute(builder: (_) => HomeScreen()),
      //   // );
      // } else {
      //   //redirect to artisn setup
      // }
      print("success");
    } else {
      // ignore: deprecated_member_use
      ShowSnackBar(data["message"], false);
    }
    print("signup file");
    print(data);
  }

  Widget _buildMoreFields() {
    return Column(
      children: [
        // SizedBox(height: 20,),

        SizedBox(
          width: MediaQuery.of(context).size.width,
          //padding: EdgeInsets.symmetric(horizontal: 20),
          child: DropdownButton(
              value: _identification,
              hint: Text("Choose Identification Type"),
              items: _listIdentification.map((identity) {
                return DropdownMenuItem(
                  child: Text(identity),
                  value: identity,
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _identification = val.toString();
                });
              }),
        ),

        SizedBox(
          height: 40,
        ),
        TextFormField(
          //  keyboardType: TextInputType.phone,
          controller: _identificationNumberController,
          validator: (value) {
            if (value == "") {
              return "Please Enter Identification Number";
            }
          },
          decoration: InputDecoration(
              labelText:
                  _identificationNumberController.text == _listIdentification[0]
                      ? "Enter Identification Number"
                      : "Enter " + _identification + " Number",
              // filled: true,
              labelStyle: TextStyle(color: Color(0xff52575C)),
              prefixIcon: Icon(
                Icons.book,
                color: Color(0xff52575C),
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).accentColor)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff52575C)))),
        ),

        SizedBox(
          height: 40,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return _isSignup
        ? Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor)),
          )
        : Container(
            height: 50.0,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _handleSubmit(),
              child: Text("Submit"),
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).accentColor),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: scaffoldkey,
      body: SafeArea(
        child: Container(
          height: deviceHeight,
          decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  image: AssetImage("assets/images/background-front.jpg"),
                  fit: BoxFit.cover)),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).accentColor,
                      ),
                      alignment: Alignment.topLeft,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image(
                        image: AssetImage("assets/images/logo.jpg"),
                        width: 100.0,
                        height: 100.0,
                        alignment: Alignment.center,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Registration!",
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18.0,
                              color: Color(0xff25282B)),
                        )),
                    SizedBox(
                      height: 50.0,
                    ),
                    TextFormField(
                      controller: _nameController,
                      validator: (value) {
                        if (value == "") {
                          return "Please Enter Fullname";
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "Fullname",
                          // filled: true,
                          labelStyle: TextStyle(color: Color(0xff52575C)),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color(0xff52575C),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Color(0xff52575C)))),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value == "") {
                          return "Please Enter Email";
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "Email",
                          // filled: true,
                          labelStyle: TextStyle(color: Color(0xff52575C)),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Color(0xff52575C),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Color(0xff52575C)))),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: _phoneNumberController,
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
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Color(0xff52575C)))),
                    ),

                    SizedBox(
                      height: 40.0,
                    ),
                    Text(
                      "Please choose user type:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Radio(
                              value: 1,
                              groupValue: _userType,
                              onChanged: _handleRadioValueChanged),
                          Text("Customer"),
                          SizedBox(
                            width: 30.0,
                          ),
                          Radio(
                              value: 2,
                              groupValue: _userType,
                              onChanged: _handleRadioValueChanged),
                          Text("Artisan"),
                          SizedBox(
                            width: 30.0,
                          ),
                        ],
                      ),
                    ),

                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Radio(
                            value: 3,
                            groupValue: _userType,
                            onChanged: _handleRadioValueChanged),
                        Text("Truck Driver"),
                        SizedBox(
                          width: 30.0,
                        ),
                        Radio(
                            value: 4,
                            groupValue: _userType,
                            onChanged: _handleRadioValueChanged),
                        Text("Supplier"),
                      ],
                    ),

                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      //padding: EdgeInsets.symmetric(horizontal: 20),
                      child: DropdownButton(
                          value: _state,
                          hint: Text("Choose your state of residence"),
                          items: states.map((state) {
                            return DropdownMenuItem(
                              child: Text(state),
                              value: state,
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _state = val.toString();
                            });
                          }),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      //  keyboardType: TextInputType.phone,
                      controller: _addressController,
                      validator: (value) {
                        if (value == "") {
                          return "Please Enter Full address";
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "Address",
                          // filled: true,
                          labelStyle: TextStyle(color: Color(0xff52575C)),
                          prefixIcon: Icon(
                            Icons.place_outlined,
                            color: Color(0xff52575C),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Color(0xff52575C)))),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    _userType == 1 ? Container() : _buildMoreFields(),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: _obscureText,
                      controller: _passwordController,
                      validator: (value) {
                        if (value == "") {
                          return "Please Enter Password";
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "Password",
                          suffixIcon: IconButton(
                            icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Color(0xff52575C)),
                            onPressed: () => {
                              setState(() {
                                _obscureText = !_obscureText;
                              })
                            },
                          ),
                          labelStyle: TextStyle(color: Color(0xff52575C)),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Color(0xff52575C),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Color(0xff52575C)))),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),

                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      value: isCheckTerms,
                      onChanged: (val) {
                        setState(() {
                          isCheckTerms = val ?? true;
                        });
                      },
                      title: TextButton(
                        child: Text(
                            "By checking this you agree to our terms and condition"),
                        onPressed: () {
                          launch(
                              "https://intecglobal.com.ng/wp-content/uploads/2022/02/IntecPRO-Terms-of-Service-2.pdf");
                        },
                      ),
                    ),

                    _buildSubmitButton(),
                    SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/login");
                        },
                        child: Text(
                          "Already have an account? Login",
                        )),
                    SizedBox(
                      height: 50.0,
                    ),

                    // Positioned(
                    //   bottom: 0,
                    //   child: Row(
                    //     children: [
                    //  Text("Dont have an Account?"),
                    //  Text("Register")
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
