import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login_ui/common/theme_helper.dart';
import 'package:login_ui/pages/widgets/personal_info.dart';

import '../tnc_page.dart';
import 'drawer.dart';

class RegistrationPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState(){
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage>{

  double _headerHeight = 25;
  final Key _formKey = GlobalKey<FormState>();
  bool agree = true;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,

        toolbarHeight: 185,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            gradient: LinearGradient(
                colors: [Colors.teal.shade400,Colors.grey],
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
              child: Container(  //this is login form
                padding: EdgeInsets.fromLTRB(25, 50, 25, 10),
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: new Column(

                  children: [
                    new Text(
                      'Enter your mobile number',
                      style: TextStyle(fontSize: 23),
                      textAlign: TextAlign.end,
                    ),
                    SizedBox(height: 10,),
                    new Text(
                      'We will send an SMS to verify this mobile number',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 65.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextField(
                            decoration: ThemeHelper().textInputDecoration('Mobile No.', ''),
                          ),
                        SizedBox(height: 180),
                        Row(
                          children: [
                            Material(
                              child: Checkbox(
                                value: agree,
                                onChanged: (value){
                                  setState((){
                                    agree = value ?? false;
                                  });
                                },
                              ),
                            ),

                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(text: "I agree to the"),
                                  TextSpan(
                                    text: ' Terms and Conditions',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => TnCPage()));
                                      },
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                                  ),
                                ],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                          SizedBox(height: 10),
                          Container(
                            decoration: ThemeHelper().buttonBoxDecoration(context),
                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              onPressed: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PersonalInfo()));
                              }, //after login redirect to homepage
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text('Continue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
          ],
        ),
      ),
    );
  }

}