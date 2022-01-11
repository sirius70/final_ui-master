import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:login_ui/common/theme_helper.dart';
import 'package:login_ui/model/slotModel.dart';
import 'package:login_ui/pages/widgets/qr_scan.dart';


class Slotcont extends StatelessWidget {
  final SlotModel slotModel;
  const Slotcont({key, this.slotModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text('Slot Details'),
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
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('slotDetails').where('stationId',
              isEqualTo: slotModel.stationId).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Column(
              children: [
                Text('User Name :::: ${slotModel.username}'),
                Text('Station ID :::: ${slotModel.stationId}'),
                Text('Slot Timings :::: ${slotModel.slotTiming}'),
                Text('Date :::: ${slotModel.date}'),
                SizedBox(height: 50),
                Container(
                  decoration: ThemeHelper().buttonBoxDecoration(context),
                  child: ElevatedButton(
                    style: ThemeHelper().buttonStyle(),
                    onPressed:(){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => qrCode(
                                slotTiming: slotModel.slotTiming,
                                stationModelid: slotModel.stationId,
                              )));
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                      child: Text('SCAN'.toUpperCase(),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ),
                ),
              ],
            );
          }
      ),
    );
  }
}