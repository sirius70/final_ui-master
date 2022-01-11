import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_ui/common/theme_helper.dart';
import 'package:login_ui/model/user_model.dart';

import 'home.dart';

class PersonalInfo extends StatefulWidget{
  @override
  State<StatefulWidget> createState(){
    return _PersonalInfoState();
  }
}

class _PersonalInfoState extends State<PersonalInfo> {
  double _headerHeight = 25;
  final _formKey = GlobalKey<FormState>();
  bool agree = true;
  final phoneController = new TextEditingController();
  final  passController = new TextEditingController();
  final  emailController = new TextEditingController();
  final  pinController = new TextEditingController();
  final  nameController = new TextEditingController();
  final  confirm_passController = new TextEditingController();

  final _auth = FirebaseAuth.instance;

  void signUp(String email, String pass) async{
    if(_formKey.currentState.validate()){
      await _auth.createUserWithEmailAndPassword(email: email, password: pass)
          .then((value)=>{
        postDetailsToFirestore(),
      }).catchError((e){
        Fluttertoast.showToast(msg: e.message);
      });
    }
  }
  postDetailsToFirestore() async{
    //calling firestore, user model and sending these values
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User user = _auth.currentUser;
    UserModel userModel = UserModel();

    //writing all values
    userModel.name = nameController.text;
    userModel.email = user.email;
    userModel.phone = phoneController.text;
    userModel.pin = pinController.text;
    userModel.uid = user.uid;

    await firebaseFirestore
        .collection("user")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg:"Account created successfully!!");

    Navigator.pushAndRemoveUntil((context),
        MaterialPageRoute(builder: (context)=>Home()),
            (route) => false);

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
        toolbarHeight: 150,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
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
            // Container(
            //   height: _headerHeight,
            // ),
            SafeArea(
              child: Container(  //this is login form
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: [

                    //SizedBox(height: 30.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Text(
                            'Enter your Personal Information',
                            style: TextStyle(fontSize: 20,),
                          ),
                          SizedBox(height: 30.0),
                          TextFormField(
                            decoration: ThemeHelper().textInputDecoration('Name', 'Enter your name'),
                            autofocus: false,
                            controller: nameController,
                            keyboardType: TextInputType.name,
                            validator: (value){
                              RegExp regex = new RegExp(r'^.{3,}$');
                              if(value.isEmpty){
                                return("Name is required for sign up");
                              };
                              if(!regex.hasMatch(value)){
                                return("Please enter valid name(Min. 3 characters)");
                              }
                              return null;
                            },
                            onSaved: (value){
                              nameController.text = value;
                            },
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: 15.0),
                          TextFormField(
                            decoration: ThemeHelper().textInputDecoration('Email', 'Enter your email'),
                            autofocus: false,
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value){
                              if(value.isEmpty){
                                return("Please enter your email");
                              }
                              if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                                return("Please enter valid email");
                              }
                              return null;
                            },
                            onSaved: (value){
                              emailController.text = value;
                            },
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: 15.0),
                          TextFormField(
                            decoration: ThemeHelper().textInputDecoration('Mobile No.', 'Enter your mobile number'),
                            autofocus: false,
                            controller: phoneController,
                            keyboardType: TextInputType.number,
                            validator: (value){
                              if(value.isEmpty){
                                return("Please enter your mobile number");
                              }
                              if(!RegExp("^[0-9]").hasMatch(value)){
                                return("Please enter valid mobile number");
                              }
                              return null;
                            },
                            onSaved: (value){
                              phoneController.text = value;
                            },
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            decoration: ThemeHelper().textInputDecoration('PIN Code of your address', 'Enter your PINCODE'),
                            autofocus: false,
                            controller: pinController,
                            keyboardType: TextInputType.number,
                            validator: (value){
                              if(value.isEmpty){
                                return("Please enter PIN Code");
                              }
                              if(!RegExp("^[0-9]").hasMatch(value)){
                                return("Please enter valid PIN Code");
                              }
                              return null;
                            },
                            onSaved: (value){
                              pinController.text = value;
                            },
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration('Password', 'Enter your password'),
                            autofocus: false,
                            controller: passController,
                            validator: (value){
                              RegExp regex = new RegExp(r'^.{6,}$');
                              if(value.isEmpty){
                                return("Password is required for login");
                              };
                              if(!regex.hasMatch(value)){
                                return("Please enter valid password(Min. 6 characters)");
                              }
                            },
                            onSaved: (value){
                              passController.text = value;
                            },
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration('Confirm Password', 'Confirm your password'),
                            autofocus: false,
                            controller: confirm_passController,
                            validator: (value){
                              if(confirm_passController.text!= passController.text){
                                return("Password doesn't match");
                              }
                              return null;
                            },
                            onSaved: (value){
                              confirm_passController.text = value;
                            },
                            textInputAction: TextInputAction.done,
                          ),

                          SizedBox(height: 50),
                          Container(
                            decoration: ThemeHelper().buttonBoxDecoration(context),
                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              onPressed: (){
                                signUp(emailController.text, passController.text);
                              }, //after login redirect to homepage
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text('Sign Up'.toUpperCase(),
                                    style: TextStyle(fontSize: 20,
                                        fontWeight: FontWeight.bold, color: Colors.white)),
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
}
