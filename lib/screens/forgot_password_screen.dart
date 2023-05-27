// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intechpro/providers/authentication_service.dart';
import 'package:intechpro/screens/home_screen.dart';
import 'package:intechpro/widgets/custome_snackbar.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool _obscureText = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldkey =  GlobalKey();

  String _email = "";
 
  bool _isLogin = false;
  TextEditingController _emailController = new TextEditingController();
  

  void ShowSnackBar(String title, bool status) {
    final snackbar = SnackBar(
      content: Text(title),
      backgroundColor: status ? Colors.green : Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLogin = true;
    });
    print(_email);
    Map<String, dynamic> data = await context
        .read<AuthenticationService>()
        .resetPassword(_emailController.text.trim());
    setState(() {
      _isLogin = false;
    });
    if (data["status"]) {
      print("success");
       ShowSnackBar(data["message"], true);
    } else {
      // ignore: deprecated_member_use
      ShowSnackBar(data["message"], false);
    }
    print("login file");
    print(data);
  }

  Widget _buildSubmitButton() {
    return _isLogin
        ? CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
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
      body: Container(
        height: deviceHeight,
        decoration: const BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage("assets/images/background-front.jpg"),
                fit: BoxFit.cover)

            //image: DecorationImage(image: AssetImage("assets/images/backgound.jpg"),fit: BoxFit.cover)
            ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 100.0,
                  ),
                  Image(
                    image: AssetImage("assets/images/logo.jpg"),
                    width: 100.0,
                    height: 100.0,
                    alignment: Alignment.center,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Forgot your Password!",
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18.0,
                        color: Color(0xff25282B)),
                  ),
                  SizedBox(
                    height: 50.0,
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
                              borderSide: BorderSide(color: Theme.of(context).accentColor)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Color(0xff52575C)))),
                      onSaved: (value) => _email = value!),


                  SizedBox(
                    height: 40.0,
                  ),

                  _buildSubmitButton(),
                  SizedBox(
                    height: 20.0,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(onPressed: ()=>Navigator.pushNamed(context, "/login"), child: Text("Remembered Password? Login"),
                  ),
                        GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, "/register"),
                            child: Text(
                              "Create new Account",
                            )),
                      ],
                    ),
                  )

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
    );
  }
}
