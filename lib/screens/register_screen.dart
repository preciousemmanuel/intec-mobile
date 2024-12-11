// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intechpro/data/states.dart';
import 'package:intechpro/providers/authentication_service.dart';
import 'package:intechpro/screens/home_screen.dart';
import 'package:intechpro/screens/registration_succes_screen.dart';
import 'package:intechpro/theme/cusotm_button_style.dart';
import 'package:intechpro/theme/custom_text_style.dart';
import 'package:intechpro/theme/theme_helper.dart';
import 'package:intechpro/utils/size_utils.dart';
import 'package:intechpro/widgets/custom_dropdown.dart';
import 'package:intechpro/widgets/custom_elevated_button.dart';
import 'package:intechpro/widgets/custom_text_field.dart';
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
  final List<String> _listIdentification = [
    "National Identification",
    "International Passport",
    "Drivers Licence",
    "Voters Card"
  ];
  bool isCheckTerms = false;
  String _state = "";
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
  List<String> dropdownItemList = [
    "Customer",
    "Artisan",
    "Supplier",
    "Truck Driver"
  ];

  @override
  initState() {
    super.initState();
    _identification = _listIdentification[0];
    _state = states[0];
  }

  void _handleRadioValueChanged(value) {
    int code = 0;
    if (value == UserType.customer) {
      code = UserType.customerCode;
    } else if (value == UserType.artisan) {
      code = UserType.artisanCode;
    } else if (value == UserType.supplier) {
      code = UserType.supplierCode;
    } else if (value == UserType.truck) {
      code = UserType.truckCode;
    }
    setState(() => _userType = code);
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

        CustomDropDown(
          icon: Container(
              margin: EdgeInsets.fromLTRB(10, 0.v, 10.h, 10.v),
              child: Icon(Icons.arrow_downward)),
          hintText: "Choose Identification Type",
          items: _listIdentification,
          hintStyle: CustomTextStyles.titleSmallBluegray300,
          // prefix: Container(margin: EdgeInsets.only(left: 20)),
          contentPadding: EdgeInsets.symmetric(
            vertical: 19.v,
            horizontal: 10,
          ),
          borderDecoration: DropDownStyleHelper.fillGray,
          onChanged: (value) {
            setState(() {
              _identification = value.toString();
            });
          },
        ),

        SizedBox(
          height: 40,
        ),
        CustomTextFormField(
          textInputType: TextInputType.text,
          controller: _identificationNumberController,
          hintText: "Identification number",
          validator: (value) {
            if (value == "") {
              return "Please Enter Identification Number";
            }
          },
          prefix: Icon(
            Icons.perm_identity,
            color: appTheme.gray200,
          ),
        ),

        SizedBox(
          height: 40,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return CustomElevatedButton(
        onPressed: (() {
          _handleSubmit();
        }),
        isDisabled: _isSignup,
        loading: _isSignup,
        text: "Submit",
        buttonStyle: CustomButtonStyles.none,
        decoration: CustomButtonStyles.gradientIndigoAToPrimaryDecoration);
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: scaffoldkey,
      body: SafeArea(
        child: Container(
          height: deviceHeight,
          color: appTheme.white,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30.0,
                    ),

                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Sign up to IntecPro",
                          style: CustomTextStyles.titleMediumBlue900Medium,
                        )),

                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Sign up to enjoy all the amazing features on intecPro",
                          style: CustomTextStyles.bodyMediumInterBluegray900,
                        )),
                    SizedBox(
                      height: 50.0,
                    ),

                    CustomTextFormField(
                      controller: _nameController,
                      hintText: "Fullname",
                      validator: (value) {
                        if (value == "") {
                          return "Please Enter Fullname";
                        }
                      },
                      prefix: Icon(
                        Icons.person_4_outlined,
                        color: appTheme.gray200,
                      ),
                    ),

                    SizedBox(
                      height: 25.0,
                    ),

                    CustomTextFormField(
                      textInputType: TextInputType.emailAddress,
                      controller: _emailController,
                      hintText: "Email",
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
                      height: 25.0,
                    ),

                    CustomTextFormField(
                      textInputType: TextInputType.phone,
                      controller: _phoneNumberController,
                      hintText: "Phone",
                      validator: (value) {
                        if (value == "") {
                          return "Please Enter Phone";
                        }
                      },
                      prefix: Icon(
                        Icons.phone,
                        color: appTheme.gray200,
                      ),
                    ),

                    SizedBox(
                      height: 25.0,
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
                    SizedBox(
                      height: 25.0,
                    ),

                    CustomDropDown(
                      icon: Container(
                          margin: EdgeInsets.fromLTRB(10, 0.v, 10.h, 10.v),
                          child: Icon(Icons.arrow_downward)),
                      hintText: "Select User Type",
                      items: UserType.userList,
                      hintStyle: CustomTextStyles.titleSmallBluegray300,
                      // prefix: Container(
                      //     margin:
                      //         EdgeInsets.fromLTRB(20.h, 25.v, 10.h, 25.v),
                      //     child: CustomImageView(
                      //         imagePath: ImageConstant.imgPin,
                      //         height: 18.adaptSize,
                      //         width: 18.adaptSize)),
                      //  prefixConstraints: BoxConstraints(maxHeight: 69.v),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 19.v, horizontal: 10),
                      borderDecoration: DropDownStyleHelper.fillGray,

                      onChanged: (value) {
                        _handleRadioValueChanged(value);
                      },
                    ),

                    SizedBox(
                      height: 25.0,
                    ),

                    CustomDropDown(
                      icon: Container(
                          margin: EdgeInsets.fromLTRB(10, 0.v, 10.h, 10.v),
                          child: Icon(Icons.arrow_downward)),
                      hintText: "Select state of residence",
                      items: states,
                      hintStyle: CustomTextStyles.titleSmallBluegray300,

                      // prefix: Container(
                      //     margin:
                      //         EdgeInsets.fromLTRB(20.h, 25.v, 10.h, 25.v),
                      //     child: CustomImageView(
                      //         imagePath: ImageConstant.imgPin,
                      //         height: 18.adaptSize,
                      //         width: 18.adaptSize)),
                      //  prefixConstraints: BoxConstraints(maxHeight: 69.v),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 19.v, horizontal: 10),
                      borderDecoration: DropDownStyleHelper.fillGray,

                      onChanged: (value) {
                        setState(() {
                          _state = value.toString();
                        });
                      },
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    CustomTextFormField(
                      textInputType: TextInputType.text,
                      controller: _addressController,
                      hintText: "Address",
                      validator: (value) {
                        if (value == "") {
                          return "Please Enter Full address";
                        }
                      },
                      prefix: Icon(
                        Icons.pin,
                        color: appTheme.gray200,
                      ),
                    ),

                    SizedBox(
                      height: 40,
                    ),
                    _userType == 1 ? Container() : _buildMoreFields(),
                    SizedBox(
                      height: 10,
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
                        child: Align(
                          alignment: Alignment.center,
                          child: RichText(
                            text: TextSpan(
                                text: "Have an account on intecPro already?",
                                style: CustomTextStyles.bodyMediumBlack500,
                                children: [
                                  TextSpan(
                                      text: " Login",
                                      style: CustomTextStyles.bodyMediumBlack500
                                          .copyWith(
                                        color: appTheme.blue200,
                                      ))
                                ]),
                          ),
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
