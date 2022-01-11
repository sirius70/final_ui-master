import 'package:shared_preferences/shared_preferences.dart';

addUIDToSF(String UID) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('UID', UID);
}

getUIDValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String stringValue = prefs.getString('UID');
  return stringValue;
}
