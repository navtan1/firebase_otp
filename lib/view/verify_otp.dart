import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_otp/constant.dart';
import 'package:firebase_otp/view/enter_number.dart';
import 'package:firebase_otp/view/todo_notes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({Key? key}) : super(key: key);

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final _verifyCode = TextEditingController();

  Future getOtp() async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verfication!, smsCode: _verifyCode.text);
    if (phoneAuthCredential == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('ERROR')));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TodoNotes(),
          ));
    }

    kFirebaseAuth.signInWithCredential(phoneAuthCredential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _verifyCode,
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Enter Code'),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        prefs.setString("Email", _verifyCode.text);

                        await getOtp();
                      },
                      child: Text('next')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
