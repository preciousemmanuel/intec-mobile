// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intechpro/providers/authentication_service.dart';
import 'package:intechpro/screens/home_screen.dart';
import 'package:intechpro/theme/cusotm_button_style.dart';
import 'package:intechpro/theme/custom_text_style.dart';
import 'package:intechpro/theme/theme_helper.dart';
import 'package:intechpro/widgets/custom_elevated_button.dart';
import 'package:intechpro/widgets/custom_text_field.dart';
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
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();

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
    return CustomElevatedButton(
        onPressed: (() {
          _handleSubmit();
        }),
        isDisabled: _isLogin,
        loading: _isLogin,
        text: "Continue",
        buttonStyle: CustomButtonStyles.none,
        decoration: CustomButtonStyles.gradientIndigoAToPrimaryDecoration);
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: scaffoldkey,
      body: Container(
        height: deviceHeight,
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

                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Forgot your password?",
                        style: CustomTextStyles.titleMediumBlue900Medium,
                      )),

                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Kindly enter your email to reset your password",
                        style: CustomTextStyles.bodyMediumInterBluegray900,
                      )),
                  SizedBox(
                    height: 50.0,
                  ),

                  CustomTextFormField(
                    controller: _emailController,
                    hintText: "Enter email",
                    validator: (value) {
                      if (value == "") {
                        return "Please Enter Email";
                      }
                    },
                    prefix: Icon(
                      Icons.email,
                      color: appTheme.gray200,
                    ),
                  ),

                  SizedBox(
                    height: 40.0,
                  ),

                  _buildSubmitButton(),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, "/login"),
                    child: Text(
                      "Cancel",
                      style: CustomTextStyles.titleSmallRed200,
                    ),
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
    );
  }
}
