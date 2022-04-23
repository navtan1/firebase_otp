import 'package:firebase_otp/constant.dart';
import 'package:firebase_otp/view/verify_otp.dart';
import 'package:flutter/material.dart';

String? verfication;

class EnterNumber extends StatefulWidget {
  const EnterNumber({Key? key}) : super(key: key);

  @override
  State<EnterNumber> createState() => _EnterNumberState();
}

class _EnterNumberState extends State<EnterNumber> {
  final _phoneNumber = TextEditingController();

  Future sendOtp() async {
    await kFirebaseAuth.verifyPhoneNumber(
      phoneNumber: "+91" + _phoneNumber.text,
      verificationCompleted: (phoneAuthCredential) {
        print("Verification Completed");
      },
      verificationFailed: (error) {
        print("$error");
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      codeSent: (String verificationId, int? forceResendingToken) {
        setState(() {
          verfication = verificationId;
        });
      },
    );
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
                    controller: _phoneNumber,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Enter Number'),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await collectionReference
                            .doc(kFirebaseAuth.currentUser!.uid)
                            .set({"phone number": _phoneNumber.text});

                        await sendOtp().then((value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VerifyOtp(),
                            )));
                      },
                      child: Text('Send Code')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
