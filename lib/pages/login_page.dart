import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_ui/common/theme_helper.dart';
import 'package:login_ui/pages/reset_password_page.dart';
import 'package:login_ui/pages/widgets/pass.dart';
import 'package:login_ui/pages/widgets/home.dart';
import 'package:login_ui/pages/widgets/personal_info.dart';
import 'package:login_ui/utils/sharedprefs.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  var profileData;

  getSuggestion(String UID) => FirebaseFirestore.instance
      .collection('user')
      .where('email', isEqualTo: email)
      .snapshots();

  double _headerHeight = 75;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();

  // String phoneNumber = "";
  final TextEditingController phone = TextEditingController();
  final TextEditingController passw = TextEditingController();

  final _auth = FirebaseAuth.instance;

  void signIn(String email, String pass) async {
    if (_formKey.currentState.validate()) {
      await _auth.signInWithEmailAndPassword(email: email, password: pass)
          .then((uid) => {
      print("User details:::${uid.user.uid}"),
      addUIDToSF(uid.user.uid),
          Fluttertoast.showToast(msg: "Login Successful"),
    Navigator.pushAndRemoveUntil(context,
    MaterialPageRoute(builder: (context) => Home()),
    (route) => false)
    }).catchError((e){
    Fluttertoast.showToast(msg: e.message);
    });
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Image.asset('assets/images/ev.png',
          fit: BoxFit.contain,
          height: 250,
        ),
        toolbarHeight: 185,
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
            Container(
              height: _headerHeight,
            ),
            SafeArea(
              child: Container( //this is login form
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: [
                    Text(
                      'Welcome',
                      style: TextStyle(
                          fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [

                          TextFormField(
                            decoration: ThemeHelper().textInputDecoration(
                                'Email', 'Enter your email'),
                            autofocus: false,
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value.isEmpty) {
                                return ("Please enter your email");
                              }
                              if (!RegExp(
                                  "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                  .hasMatch(value)) {
                                return ("Please enter valid email");
                              }
                              return null;
                            },
                            onSaved: (value) {
                              email.text = value;
                            },
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: 30.0),
                          TextFormField(
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration(
                                'Password', 'Enter password'),
                            autofocus: false,
                            controller: passw,
                            validator: (value) {
                              RegExp regex = new RegExp(r'^.{6,}$');
                              if (value.isEmpty) {
                                return ("Password is required for login");
                              };
                              if (!regex.hasMatch(value)) {
                                return ("Please enter valid password(Min. 6 characters)");
                              }
                            },
                            onSaved: (value) {
                              passw.text = value;
                            },
                            textInputAction: TextInputAction.done,
                          ),
                          SizedBox(height: 15.0),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                            alignment: Alignment.topRight,
                            //child: Text('Forgot password?', style: TextStyle(fontSize: 16)),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Forgot password?',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _bottomSheet(context);
                                      },

                                    style: TextStyle(fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Theme
                                            .of(context)
                                            .primaryColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            decoration: ThemeHelper().buttonBoxDecoration(
                                context),

                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              onPressed: () {
                                signIn(email.text, passw.text);
                              }, //after login redirect to homepage
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text('Sign In'.toUpperCase(),
                                    style: TextStyle(fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 30, 20, 30),
                            //child: Text("Don't have an account? Sign Up"),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(text: "Don\'t have an account?"),
                                  TextSpan(
                                    text: ' Sign Up',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PersonalInfo()));
                                      },
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme
                                            .of(context)
                                            .primaryColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),

      ),

    );
  }


  _bottomSheet(context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0)),
        ),
        isScrollControlled: true,
        builder: (BuildContext c) {
          return Wrap(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                        trailing: Icon(Icons.close),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(height: 0),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Text('Forgot your password?',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 30),
                      new Text(
                          'Enter your email id to reset your password',
                          style: TextStyle(
                              fontSize: 15, color: Colors.grey.shade600)),
                      SizedBox(height: 30),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery
                                .of(context)
                                .viewInsets
                                .bottom
                        ),

                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Email ID',
                            hintText: '',
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                borderSide: BorderSide(color: Colors.grey)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade400)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                borderSide: BorderSide(
                                    color: Colors.red, width: 2.0)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                borderSide: BorderSide(
                                    color: Colors.red, width: 2.0)),
                            prefix: Padding(
                              padding: EdgeInsets.all(4),
                              //child: Text('+91'),
                            ),
                          ),
                          //keyboardType: TextInputType.number,
                          //controller: phone,
                          //maxLength: 10,
                          autofocus: true,
                        ),
                      ),

                      SizedBox(height: 40),
                      Container(
                        decoration: ThemeHelper().buttonBoxDecoration(context),
                        child: ElevatedButton(
                          autofocus: true,
                          style: ThemeHelper().buttonStyle(),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => pass()));
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                            child: Text('Submit'.toUpperCase(),
                                style: TextStyle(fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),

                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),

              ),
            ],
          );
        });
  }
}
