import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';

import 'otp.dart';

class ResetPassword extends StatefulWidget {
  String phone;
  ResetPassword(this.phone);
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String _verificationCode = '';
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: Colors.white38,
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: Colors.black,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text('Reset password'),
        toolbarHeight: 75,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            gradient: LinearGradient(
                colors: [Colors.teal.shade400, Colors.grey],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20),
                      ),
                      Image.asset(
                        'assets/images/otp.png',
                        height: 130,
                      ),
                      SizedBox(height: 20),
                      Text('Type your OTP!',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 21)),
                      SizedBox(height: 30),
                      Text(
                        'Verification code has been sent to your registered mobile number ending with'
                        ' ******${widget.phone[6]}${widget.phone[7]}${widget.phone[8]}${widget.phone[9]}',
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey.shade600),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: PinPut(
                          fieldsCount: 6,
                          textStyle: const TextStyle(
                              fontSize: 25, color: Colors.black),
                          eachFieldWidth: 45,
                          eachFieldHeight: 50,
                          focusNode: _pinPutFocusNode,
                          controller: _pinPutController,
                          submittedFieldDecoration: pinPutDecoration,
                          selectedFieldDecoration: pinPutDecoration,
                          followingFieldDecoration: pinPutDecoration,
                          pinAnimationType: PinAnimationType.fade,
                          onSubmit: (pin) async {
                            try {
                              await FirebaseAuth.instance
                                  .signInWithCredential(
                                      PhoneAuthProvider.credential(
                                          verificationId: _verificationCode,
                                          smsCode: pin))
                                  .then((value) async {
                                if (value.user != null) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OtpScreen()),
                                      (route) => false);
                                }
                              });
                            } catch (e) {
                              FocusScope.of(context).unfocus();
                              _scaffoldkey.currentState.showSnackBar(
                                  SnackBar(content: Text('Invalid OTP')));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.phone}',
        verificationCompleted: (AuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => OtpScreen()),
                  (route) => false);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verificationID, int resendToken) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 90));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }
}
