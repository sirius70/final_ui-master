import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_ui/common/theme_helper.dart';
import 'package:login_ui/pages/verify_done.dart';

import 'login_page.dart';

class OtpScreen extends StatefulWidget{
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  int count = 3;
  double _headerHeight = 75;
  Key _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  void _showcontent() {
    showDialog(
      context: context, barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('You clicked on'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: [
                new Text('This is a Dialog Box. Click OK to Close.'),
              ],
            ),
          ),
          actions: [
            new FlatButton(
              child: new Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            gradient: LinearGradient(
                colors: [Colors.teal.shade400, Colors.grey],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter
            ),
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
                        margin: EdgeInsets.only(top: 0),
                      ),
                      Image.asset('assets/images/reset.png', height: 250,),

                      Text(
                          'Set New Password',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 21)
                      ),

                SizedBox(height: 50.0),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextField(
                        decoration: ThemeHelper().textInputDecoration('New password', 'Enter new password'),
                      ),
                      SizedBox(height: 30.0),
                      TextField(
                        obscureText: true,
                        decoration: ThemeHelper().textInputDecoration('Confirm password', 'Confirm password'),
                      ),

                      SizedBox(height: 90),
                      Container(
                        decoration: ThemeHelper().buttonBoxDecoration(context),
                        child: ElevatedButton(
                          style: ThemeHelper().buttonStyle(),
                          onPressed: () {
                            final snackBar = SnackBar(
                            content: const Text('Reset successful!'),
                            action: SnackBarAction(
                            label: 'OK',
                            onPressed: () {
                              Navigator.pushNamed(context, '/');
                              },
                              ),
                              );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);


                          }, //after login redirect to homepage
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                            child: Text('Reset password'.toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                      ),
                      ],
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


}