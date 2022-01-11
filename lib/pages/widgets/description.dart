// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:flutter/material.dart';
// import 'package:login_ui/common/theme_helper.dart';
//
// class desc extends StatefulWidget {
//
//   @override
//   State<desc> createState() => _descState();
// }
//
// class _descState extends State<desc> {
//   late final dref=FirebaseDatabase.instance.reference();
//   late DatabaseReference databaseReference;
//   setData(){
//     dref.child("Info").set(
//         {
//           'name': "PlugNGo",
//           'description': "1st Main, 1st Cross Rd,Kamakshipalya,Bengaluru, TYPE-2 CHARGING",
//           'station_id' : "EVS099",
//           'status' : "Available"
//
//         }
//     ).asStream();
//     dref.child("Info1").set(
//         {
//           'name': "ChargeGrid",
//           'description': "1st main, Richmond Road,Richmond Town,Bengaluru, TYPE-1 CHARGING",
//           'station_id' : "EVS087",
//           'status' : "Busy"
//
//         }
//     ).asStream();
//     dref.child("Info2").set(
//         {
//           'name': "Fortnum",
//           'description': "19th 'C' cross, 7th Block,Jayanagar, Bengaluru, TYPE-3 CHARGING",
//           'station_id' : "EVS025",
//           'status' : "Available"
//
//         }
//     ).asStream();
//     dref.child("Info3").set(
//         {
//           'name': "Charzer",
//           'description': "46, Dr Rajkumar Road, Prakash Nagar, Rajajinagar, Bengaluru, TYPE-3 CHARGING",
//           'station_id' : "EVS032",
//           'status' : "Available"
//
//         }
//     ).asStream();
//
//   }
//
//   showData(){
//     dref.once().then((snapshot){
//       print("hi");
//     });
//   }
//   @override
//
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     databaseReference = dref;
//   }
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//
//         appBar: AppBar(
//           brightness: Brightness.dark,
//           backgroundColor: Colors.transparent,
//           elevation: 0.0,
//           centerTitle: true,
//           title: Text('EV Station near me'),
//           toolbarHeight: 75,
//           flexibleSpace: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),
//                   bottomRight: Radius.circular(20)),
//               gradient: LinearGradient(
//                   colors: [Colors.teal.shade400, Colors.grey],
//                   begin: Alignment.bottomCenter,
//                   end: Alignment.topCenter
//               ),
//             ),
//           ),
//         ),
//         body: Column(
//             children:[
//               TextButton(
//                   onPressed: setData,
//                   child:Text(
//                     "Fetch Data",style: TextStyle(
//                       color:Colors.grey),)),
//
//               FirebaseAnimatedList(
//                   shrinkWrap: true,
//                   query: databaseReference,
//                   itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation animation, int index){
//                     return ListTile(
//                         leading: Text(["station_id"].toString()),
//                         title: Text(['name'].toString()),
//                         subtitle:   Text(['description'].toString()),
//                         trailing: Text(['status'].toString())
//                     );
//
//                   }),
//               SizedBox(height: 90),
//               Container(
//                 decoration: ThemeHelper().buttonBoxDecoration(context),
//                 child: ElevatedButton(
//                   style: ThemeHelper().buttonStyle(),
//                   onPressed: () {
//                     // Navigator.pushAndRemoveUntil(context,
//                     //     MaterialPageRoute(builder: (context) => slot()),
//                     //         (route) => false);
//                   }, //after login redirect to homepage
//                   child: Padding(
//                     padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
//                     child: Text('Book Slot'.toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
//                   ),
//                 ),
//               )
//             ]
//         )
//     );
//   }
// }