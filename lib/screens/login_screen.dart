// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intechpro/providers/authentication_service.dart';
import 'package:intechpro/screens/home_screen.dart';
import 'package:intechpro/theme/cusotm_button_style.dart';
import 'package:intechpro/theme/custom_text_style.dart';
import 'package:intechpro/theme/theme_helper.dart';
import 'package:intechpro/utils/size_utils.dart';
import 'package:intechpro/widgets/custom_elevated_button.dart';
import 'package:intechpro/widgets/custom_text_field.dart';
import 'package:intechpro/widgets/custome_snackbar.dart';
import 'package:intechpro/widgets/space.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey();

  String _email = "";
  String _password = "";
  bool _isLogin = false;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

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
        .signIn(_passwordController.text, _emailController.text.trim());
    setState(() {
      _isLogin = false;
    });
    if (data["status"]) {
      print("success");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
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
        // decoration: const BoxDecoration(
        //     color: Colors.white,
        //     image: DecorationImage(
        //         image: AssetImage("assets/images/background-front.jpg"),
        //         fit: BoxFit.cover)

        //     //image: DecorationImage(image: AssetImage("assets/images/backgound.jpg"),fit: BoxFit.cover)
        //     ),
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
                        "Login",
                        style: CustomTextStyles.titleMediumBlue900Medium,
                      )),

                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Welcome back",
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
                  CustomTextFormField(
                    textInputType: TextInputType.text,
                    controller: _passwordController,
                    hintText: "Password",
                    obscureText: _obscureText,
                    validator: (value) {
                      if (value == "") {
                        return "Please Enter Password";
                      }
                    },
                    prefix: Icon(
                      Icons.key_outlined,
                      color: appTheme.gray200,
                    ),
                    suffix: IconButton(
                      icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: appTheme.gray200),
                      onPressed: () => {
                        setState(() {
                          _obscureText = !_obscureText;
                        })
                      },
                    ),
                  ),
                  VSpace(10.v),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      child: Text("Forgot Password?"),
                      onPressed: () =>
                          Navigator.pushNamed(context, "/forgot_password"),
                    ),
                  ),

                  SizedBox(
                    height: 40.0,
                  ),

                  _buildSubmitButton(),
                  SizedBox(
                    height: 20.0,
                  ),
                  GestureDetector(
                      onTap: () => Navigator.pushNamed(context, "/register"),
                      child: Align(
                        alignment: Alignment.center,
                        child: RichText(
                          text: TextSpan(
                              text: "Dont have an accout with IntecPro?",
                              style: CustomTextStyles.bodyMediumBlack500,
                              children: [
                                TextSpan(
                                    text: " Register",
                                    style: CustomTextStyles.bodyMediumBlack500
                                        .copyWith(
                                      color: appTheme.blue200,
                                    ))
                              ]),
                        ),
                      ))

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
