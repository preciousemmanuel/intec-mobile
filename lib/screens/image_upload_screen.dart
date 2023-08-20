import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intechpro/providers/profile_provider.dart';


import 'package:intechpro/screens/home_screen.dart';

import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class ImageUploadScreen extends StatefulWidget {
  final int userType;
  final String? fromNav;
  const ImageUploadScreen({Key? key, required this.userType, this.fromNav = ""})
      : super(key: key);

  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _image;
  bool _loadingImage = false;
  bool isSubmitting = false;
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   setProfile();
    // });
  }

  void ShowSnackBar(String title, bool status) {
    final snackbar = SnackBar(
      content: Text(title),
      backgroundColor: status ? Colors.green : Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  onSubmit() async {
    try {
      if (_image == null) {
        ShowSnackBar("Please take a photo", false);
      }
      setState(() {
        isSubmitting=true;
      });
      Reference _firebaseStorage = FirebaseStorage.instance.ref();
      String uniqueId = Uuid().v4();

      var snapshot =
          await _firebaseStorage.child('${uniqueId}').putFile(_image!);
      print("succsss####");
      final imageUrl = "https://firebasestorage.googleapis.com/v0/b/" +
          snapshot.ref.bucket +
          "/o/" +
          snapshot.ref.fullPath +
          "?alt=media";
      Map<String, dynamic> data =
          await context.read<ProfileProvider>().updateprofileImage(imageUrl);
      print(snapshot.ref.bucket);
setState(() {
        isSubmitting=false;
      });
//call api to store playtore
      if (data["status"]) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("SUCCESS"),
                content: Text("Image Upload Successfull"),
                actions: [
                  TextButton(
                      onPressed: () {
                        // if (widget.fromNav == "") {
                        //   Navigator.of(context).pushReplacement(
                        //     MaterialPageRoute(
                        //       builder: (_) => CompleteProfileScreen(
                        //         userType: widget.userType,
                        //       ),
                        //     ),
                        //   );
                        // } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => HomeScreen(),
                            ),
                          );
                        // }
                      },
                      child: Text("OK"))
                ],
              );
            });
      } else {
        setState(() {
        isSubmitting=false;
      });
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("ERROR"),
                content: Text("Failed to Save Image"),
              );
            });
      }

      //  var fileURL=  await _firebaseStorage.getDownloadURL();
      //  print("down###");
      //  print(fileURL);

    } on FirebaseException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("ERROR"),
              content: Text(e.message.toString()),
            );
          });
      print(e.message);
    }
  }

  Future takePhoto() async {
    try {
      setState(() {
        _loadingImage = true;
      });
      final image = await ImagePicker().pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front);

      if (image == null) {
        setState(() {
          _loadingImage = false;
        });
        return;
      }

      final imageTemp = File(image.path);
      setState(() {
        _loadingImage = false;
        _image = imageTemp;
      });
    } on PlatformException catch (e) {
      print(e.toString());
      ShowSnackBar(e.message.toString(), false);
    }

    // Map<String, dynamic> response =
    //     await context.read<ProfileProvider>().fetch_user();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      key: scaffoldkey,
      child: Container(
        color: Theme.of(context).primaryColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Text(
                "Put a face to the name",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontSize: 16,
                    color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Upload a live picture",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 40,
              ),
              _image == null
                  ? Image.asset(
                      "assets/images/profile.png",
                      width: 170,
                      height: 170,
                    )
                  : _loadingImage
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white))
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(200.0),
                          child: Image.file(
                            _image!,
                            width: 300,
                            height: 300,
                            fit: BoxFit.cover,
                          )),
              SizedBox(
                height: 120,
              ),
        
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isSubmitting
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white))
                        : OutlinedButton(
                            onPressed: () {
                              takePhoto();
                            },
                            child: Text(
                              "Take Photo",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(width: 1.0, color: Colors.white),
                            )),
                    isSubmitting
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white))
                        : ElevatedButton(
                            onPressed: () {
                              onSubmit();
                            },
                            child: Text("Continue"),
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).accentColor),
                          )
                  ],
                ),
              )
              //   SizedBox(
              //     height: 30,
              //   ),
              //  widget.userType==1? Text(
              //     "You have recieved ${currency.symbol}1000 into your walllet.",
              //     style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),
              //   ):Container(),
            ],
          ),
        ),
      ),
    );
  }
}
