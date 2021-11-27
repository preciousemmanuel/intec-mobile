// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intechpro/providers/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscureText = true;
  bool _isSignup = false;
  String _userType = "1";
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
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
    scaffoldkey.currentState!.showSnackBar(snackbar);
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isSignup = true;
    });

    Map<String, dynamic> data = await context
        .read<AuthenticationService>()
        .signUp(_nameController.text, _passwordController.text,
            _emailController.text.trim(),_userType);
    setState(() {
      _isSignup = false;
    });
    if (data["status"]) {
      if (_userType == 1) {
        //redirect to home
        Navigator.pushNamed(context, '/home');
      } else {
        //redirect to artisn setup
      }
      print("success");
    } else {
      // ignore: deprecated_member_use
      ShowSnackBar(data["message"], false);
    }
    print("signup file");
    print(data);
  }

  Widget _buildSubmitButton() {
    return _isSignup
        ? CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))
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
                  image: AssetImage("assets/images/background-img.jpg"),
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
                      height: 20.0,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).accentColor,
                      ),
                      alignment: Alignment.topLeft,
                    ),
                    SizedBox(
                      height: 40.0,
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
                          labelStyle: TextStyle(color: Color(0xffA0A4A8)),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color(0xffCACCCF),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff52575C))),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Color(0xffCACCCF)))),
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
                          labelStyle: TextStyle(color: Color(0xffA0A4A8)),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Color(0xffCACCCF),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff52575C))),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Color(0xffCACCCF)))),
                    ),

                    SizedBox(
                      height: 40.0,
                    ),
                    Text(
                      "Please choose user type:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Radio(
                            value: 1,
                            groupValue: _userType,
                            onChanged: _handleRadioValueChanged),
                        Text("Customer"),
                        SizedBox(
                          width: 100.0,
                        ),
                        Radio(
                            value: 2,
                            groupValue: _userType,
                            onChanged: _handleRadioValueChanged),
                        Text("Artisan"),
                      ],
                    ),
                    SizedBox(
                      height: 40,
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
                                color: Color(0xffCACCCF)),
                            onPressed: () => {
                              setState(() {
                                _obscureText = !_obscureText;
                              })
                            },
                          ),
                          labelStyle: TextStyle(color: Color(0xffA0A4A8)),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Color(0xffCACCCF),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff52575C))),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Color(0xffCACCCF)))),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),

                    _buildSubmitButton(),
                    SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                        onTap: () {},
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
