import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_ui/common/theme_helper.dart';
import 'package:login_ui/pages/verify_done.dart';

import 'home.dart';

class pass extends StatefulWidget {
  @override
  _passState createState() => _passState();
}

class _passState extends State<pass> {
  int count = 3;
  double _headerHeight = 75;
  Key _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String oldPass = '';
  String newPass = '';
  String rePass = '';

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
                        margin: EdgeInsets.only(top: 0),
                      ),
                      Image.asset(
                        'assets/images/reset.png',
                        height: 200,
                      ),
                      Text('Set New Password',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 21)),
                      SizedBox(height: 50.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextField(
                              decoration: ThemeHelper().textInputDecoration(
                                  'Email ID', 'Enter email ID'),
                              onChanged: (v) {
                                setState(() {
                                  oldPass = v;
                                });
                              },
                            ),
                            SizedBox(height: 30.0),
                            TextField(
                              decoration: ThemeHelper().textInputDecoration(
                                  'New password', 'Enter new password'),
                              onChanged: (v) {
                                setState(() {
                                  newPass = v;
                                });
                              },
                            ),
                            SizedBox(height: 30.0),
                            TextField(
                              obscureText: true,
                              decoration: ThemeHelper().textInputDecoration(
                                  'Confirm password', 'Confirm password'),
                              onChanged: (v) {
                                setState(() {
                                  rePass = v;
                                });
                              },
                            ),
//
                            SizedBox(height: 60),
                            Container(
                              decoration:
                                  ThemeHelper().buttonBoxDecoration(context),
                              child: ElevatedButton(
                                style: ThemeHelper().buttonStyle(),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  if (newPass != rePass) {
                                    final snackBar = SnackBar(
                                      content: const Text(
                                          "Password doesn't Matches"),
                                      action: SnackBarAction(
                                        label: 'OK',
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else {
                                    _changePassword(oldPass,newPass);
                                  }
                                }, //after login redirect to homepage
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text('Reset password'.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
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

  void _changePassword(String uEmail, String newPassword) async {
    final user = await FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: uEmail);
    print("checking email :::: ${uEmail.trim()==user.email}");
    if(uEmail.trim()==user.email){
      user.updatePassword(newPassword).then((_) {
        //Success, do something
        final snackBar = SnackBar(
          content: const Text('Reset successful!'),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }).catchError((error) {
        final snackBar = SnackBar(
          content: Text("Password can't be changed ${error.toString()}"),
          action: SnackBarAction(
            label: 'OK',
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }else{
      final snackBar = SnackBar(
        content: Text("err.toString()"),
        action: SnackBarAction(
          label: 'OK',
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    };
  }
}
