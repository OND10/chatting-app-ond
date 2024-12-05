import 'dart:typed_data';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jobseeking/auth/Handlers/auth_provider.dart';
import 'package:jobseeking/auth/pages/login.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  // Uint8List? _imageBytes;
  // final _auth = FirebaseAuth.instance;
  // final _firestore = FirebaseFirestore.instance;
  // final _storage = FirebaseStorage.instance;

  // Future<void> _pickImage() async {
  //   try {
  //     // Step 1: Pick an image
  //     final pickedFile =
  //         await ImagePicker().pickImage(source: ImageSource.gallery);

  //     if (pickedFile == null) {
  //       print("No file selected.");
  //       return; // Exit if no file is picked.
  //     }

  //     // Step 2: Read image bytes
  //     final bytes = await pickedFile.readAsBytes();
  //     setState(() {
  //       _imageBytes = bytes;
  //     });

  //     // Step 3: Validate the bytes
  //     if (_imageBytes == null || _imageBytes!.isEmpty) {
  //       print("Failed to read image bytes.");
  //     } else {
  //       print(
  //           "Image bytes read successfully. Byte count: ${_imageBytes!.length}");
  //     }
  //   } catch (e) {
  //     print("Error during image picking: $e");
  //   }
  // }

  // Future<String> _uploadImage(Uint8List image) async {
  //   final ref = _storage
  //       .ref()
  //       .child('profilePicture')
  //       .child('${_auth.currentUser!.uid}.jpg');
  //   await ref.putData(image);
  //   return await ref.getDownloadURL();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/background.png'),
                        fit: BoxFit.fill)),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 200,
                      child: FadeInUp(
                          duration: Duration(seconds: 1),
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/light-1.png'))),
                          )),
                    ),
                    Positioned(
                      left: 140,
                      width: 80,
                      height: 150,
                      child: FadeInUp(
                          duration: Duration(milliseconds: 1200),
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/light-2.png'))),
                          )),
                    ),
                    Positioned(
                      right: 40,
                      top: 40,
                      width: 80,
                      height: 150,
                      child: FadeInUp(
                          duration: Duration(milliseconds: 1300),
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/clock.png'))),
                          )),
                    ),
                    Positioned(
                      child: FadeInUp(
                          duration: Duration(milliseconds: 1600),
                          child: Container(
                            margin: EdgeInsets.only(top: 50),
                            child: Center(
                              child: Text(
                                "SignUp",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    FadeInUp(
                        duration: Duration(milliseconds: 1800),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Color.fromRGBO(143, 148, 251, 1)),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(143, 148, 251, .2),
                                    blurRadius: 20.0,
                                    offset: Offset(0, 10))
                              ]),
                          child: Column(
                            children: <Widget>[
                              // InkWell(
                              //   onTap: _pickImage,
                              //   child: Container(
                              //       height: 200,
                              //       width: 200,
                              //       decoration: BoxDecoration(
                              //         shape: BoxShape.circle,
                              //         border: Border(
                              //             bottom: BorderSide(
                              //                 color: Color.fromRGBO(
                              //                     143, 148, 251, 1))),
                              //       ),
                              //       child: _imageBytes == null
                              //           ? Center(
                              //               child: Icon(
                              //                 Icons.camera_alt_rounded,
                              //                 size: 50,
                              //                 color: Color.fromRGBO(
                              //                     143, 148, 251, 1),
                              //               ),
                              //             )
                              //           : ClipRRect(
                              //               borderRadius:
                              //                   BorderRadius.circular(100),
                              //               child: Image.memory(
                              //                 _imageBytes!,
                              //                 fit: BoxFit.cover,
                              //               ),
                              //             )),
                              // ),

                              Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Color.fromRGBO(
                                                143, 148, 251, 1)))),
                                child: TextFormField(
                                  controller: username,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "UserName",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[700])),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Enter the userName please";
                                    }
                                    return value;
                                  },
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Color.fromRGBO(
                                              143, 148, 251, 1))),
                                ),
                                child: TextFormField(
                                  controller: email,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[700])),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Enter the email please";
                                    }
                                    if (!value.contains('@')) {
                                      return "Please enter a valid email";
                                    }
                                    return value;
                                  },
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Color.fromRGBO(
                                                143, 148, 251, 1)))),
                                child: TextFormField(
                                    controller: password,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Password",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[700])),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Enter the Password please";
                                      }
                                      if (value.length < 3) {
                                        return "Pawword must be greater than 3 chars";
                                      }

                                      return value;
                                    }),
                              ),
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    FadeInUp(
                        duration: Duration(milliseconds: 1900),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(143, 148, 251, 1),
                                Color.fromRGBO(143, 148, 251, .6),
                              ])),
                          child: Center(
                            child: TextButton(
                              child: Text(
                                "Sign up",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async {
                                final authProvider = Provider.of<AuthsProvider>(
                                    context,
                                    listen: false);
                                try {
                                  // final imageUrl =
                                  //     await _uploadImage(_imageBytes!);
                                  await authProvider.signup(email.text,
                                      password.text, username.text, "ImageUrl");

                                  //shows toast for success
                                  Fluttertoast.showToast(
                                      msg: 'Sign Up Successfully');

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => const Login()));
                                } catch (e) {
                                  print(e);
                                }
                              },
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 70,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
