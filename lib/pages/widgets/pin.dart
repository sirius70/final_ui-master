import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_ui/common/theme_helper.dart';

class pin extends StatefulWidget{
  @override
  State<StatefulWidget> createState(){
    return _pinState();
  }
}

class _pinState extends State<pin> {
  String newPin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text('Edit PIN Code'),
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
              child: Container( //this is login form
                padding: EdgeInsets.fromLTRB(25, 50, 25, 10),
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  children: [
                    SizedBox(height: 30.0),
                    Text(
                      'PIN Code',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(6),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 0,
                            horizontal: 10),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey),
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)
                        ),
                      ),
                      onChanged: (v){
                        setState(() {
                          newPin = v;
                        });
                      },
                    ),

                    SizedBox(height: 400),
                    Container(
                      decoration: ThemeHelper().buttonBoxDecoration(context),
                      child: ElevatedButton(
                        style: ThemeHelper().buttonStyle(),
                        onPressed: () {
                          Navigator.pop(context,newPin!=''?newPin:null);
                        }, //after login redirect to homepage
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                          child: Text('Update'.toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
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
