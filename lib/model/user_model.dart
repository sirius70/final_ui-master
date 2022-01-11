class UserModel {
  String uid;
  String email;
  String name;
  String phone;
  String pin;
  String pass;
  String confirm_pass;

  UserModel({this.uid, this.name, this.email, this.phone, this.pin});
  factory UserModel.fromMap(map){
    return UserModel(
        uid: map['uid'],
        name: map['name'],
        email: map['email'],
        phone: map['phone'],
        pin: map['pin']
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'pin': pin,
    };
  }

}

