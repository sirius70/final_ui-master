import 'package:flutter/material.dart';

class VehicleProfile extends StatefulWidget {

  @override
  _VehicleProfileState createState() => _VehicleProfileState();
}

class _VehicleProfileState extends State<VehicleProfile> {
  bool isObscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text('Vehicle Details'),
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
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                            border: Border.all(width: 4, color: Colors.white),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1)
                              )
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    'https://cdn.pixabay.com/photo/2016/04/01/09/11/car-1299198_960_720.png'
                                )
                            )

                        )
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 4,
                                  color: Colors.white),
                              color: Colors.blue
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        )
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              buildTextFeild("Connectore Type", "Actype2",false),
              buildTextFeild("Company", "hyundai",false),
              buildTextFeild("Model", "kona",false),
              buildTextFeild("Vehicle Register Number", "MH1234",false),
              buildTextFeild("VIN", "MA7MFCD2CCD974271",false),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildTextFeild(String labelText, String placeholder,  bool isPasswordTextField){
    return Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: TextField(
          obscureText: isPasswordTextField ? isObscurePassword : false,
          decoration: InputDecoration(
              suffixIcon : isPasswordTextField ?
              IconButton(
                  icon: Icon(Icons.remove_red_eye,color: Colors.grey),
                  onPressed: () {
                    setState((){
                      isObscurePassword = !isObscurePassword;
                    }
                    );
                  }
              ): null,
              contentPadding: EdgeInsets.only(bottom: 5),
              labelText: labelText,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: placeholder,
              hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              )
          ),
        )
    );
  }
}