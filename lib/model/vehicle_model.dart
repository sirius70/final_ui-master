import 'package:cloud_firestore/cloud_firestore.dart';

class vehicle {
  String vid;
  String make;
  String model;
  String connector;
  String veh_regno;
  String vin;

  vehicle.fromMap(Map<String, dynamic> data){
    vid=data["vid"];
    make=data["make"];
    model=data["model"];
    connector=data["connector"];
    veh_regno=data["veh_regno"];
    vin=data["vin"];
}
}

