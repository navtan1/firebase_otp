import 'dart:io';
import 'dart:math';

import 'package:firebase_otp/firebase_services.dart';
import 'package:firebase_otp/view/log_in_screen.dart';
import 'package:firebase_otp/view/todo_notes.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _fName = TextEditingController();
  final _lName = TextEditingController();
  final _email = TextEditingController();
  final _passWord = TextEditingController();

  File? _image;

  final picker = ImagePicker();

  Future getImage() async {
    var imagePicker = await picker.getImage(source: ImageSource.gallery);

    if (imagePicker != null) {
      setState(() {
        _image = File(imagePicker.path);
      });
    }
  }

  Future<String?> uploadImage({File? file, String? filename}) async {
    print("File_Path$file");
    try {
      var response = await storage.ref("user_image/$filename").putFile(file!);
      return response.storage.ref("user_image/$filename").getDownloadURL();
    } on firebase_storage.FirebaseException catch (e) {
      print(e);
    }
  }

  Future addUserId() async {
    String? imageUrl = await uploadImage(
        file: _image!,
        filename:
            "${Random().nextInt(1000)}${kFirebaseAuth.currentUser!.email}");

    collectionReference.doc(kFirebaseAuth.currentUser!.uid).set({
      "email": _email.text,
      "password": _passWord.text,
      "avatar": imageUrl
    }).catchError((e) {
      print("ERROR====>>>>$e");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: Container(
                      height: 110,
                      width: 130,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey),
                      child: ClipOval(
                        child: _image == null
                            ? Icon(Icons.camera)
                            : Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _fName,
                    decoration: InputDecoration(hintText: 'First Name'),
                  ),
                  TextField(
                    controller: _lName,
                    decoration: InputDecoration(hintText: 'Last Name'),
                  ),
                  TextField(
                    controller: _email,
                    decoration: InputDecoration(hintText: 'Email ID'),
                  ),
                  TextField(
                    controller: _passWord,
                    decoration: InputDecoration(hintText: 'Password'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        bool status = await FirebaseServices.signUp(
                            email: _email.text, password: _passWord.text);
                        if (status == true) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          await addUserId();

                          prefs
                              .setString("Email", _email.text)
                              .then((value) => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TodoNotes(),
                                  )));
                        }
                      },
                      child: Text('Register Your account')),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("You have already Account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LogInScreen(),
                                ));
                          },
                          child: Text("Log In"))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
