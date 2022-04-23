import 'dart:async';

import 'package:firebase_otp/view/info_screen.dart';
import 'package:firebase_otp/view/todo_notes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? userId;

  @override
  void initState() {
    getData().whenComplete(() => Timer(Duration(seconds: 3), () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    userId == null ? InfoScreen() : TodoNotes(),
              ));
        }));
    super.initState();
  }

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? data = prefs.getString('Email');
    setState(() {
      userId = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Splash Screen',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
