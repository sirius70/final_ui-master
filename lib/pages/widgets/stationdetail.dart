import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_ui/common/theme_helper.dart';
import 'package:login_ui/model/stationModel.dart';
import 'package:login_ui/pages/widgets/slot.dart';

class Stationdetail extends StatelessWidget {
  final StationModel stationModel;

  const Stationdetail({key, this.stationModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(stationModel.name),
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
        stream: FirebaseFirestore.instance.collection('feedback').where('stationId',isEqualTo: stationModel.id).where('workingCondition',isEqualTo: false).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          print('Length of snapshot:::${snapshot.data.docs.length}');
          return Column(
            children: [
              Image.network(stationModel.ImageUrl),
              Text('Station ID :::: ${stationModel.id}'),
              Text('Station Address :::: ${stationModel.address}'),
              Text('Connetor Type :::: ${stationModel.connectorType}'),
              Text('Contact :::: ${stationModel.contact}'),
              Text('Slots Available :::: ${stationModel.availability}'),
              Text('Working Condition :::: ${stationModel.workingCondition}'),
              SizedBox(height: 50),
              Container(
                decoration: ThemeHelper().buttonBoxDecoration(context),
                child: ElevatedButton(
                  style: ThemeHelper().buttonStyle(),
                  onPressed:
                      stationModel.workingCondition && stationModel.availability > 0
                          ? () async {
                       // if(snapshot.data.docs.length<3)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => slot(
                                          id: stationModel.id,
                                        )
                                ),
                              );
                        // else{
                        //   QuerySnapshot querySnap = await FirebaseFirestore.instance.collection('stations').where('stationId', isEqualTo: stationModel.id).get();
                        //   QueryDocumentSnapshot doc = querySnap.docs[0];  // Assumption: the query returns only one document, THE doc you are looking for.
                        //   DocumentReference docRef = doc.reference;
                        //   // await FirebaseFirestore.instance.collection('stations').doc(docRef.id).update({"workingCondition": false});
                        //   final snackBar = SnackBar(
                        //     content:
                        //     const Text('EV Station currently Out of Order'),
                        //     action: SnackBarAction(
                        //       label: 'OK',
                        //       onPressed: () {Navigator.pop(context);},
                        //     ),
                        //   );
                        //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        // }
                            }
                          : () {
                              final snackBar = SnackBar(
                                content:
                                    const Text('EV Station currently Out of Order'),
                                action: SnackBarAction(
                                  label: 'OK',
                                  onPressed: () {Navigator.pop(context);},
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }, //after login redirect to homepage
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                    child: Text('Book Slot'.toUpperCase(),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
              ),
              SizedBox(height: 70,),
              Text('FEEDBACK',style: TextStyle(fontSize: 20),),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('feedback')
                      .where('stationId', isEqualTo: stationModel.id)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (!streamSnapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: streamSnapshot.data.docs.map((document) {
                          return Card(
                            child: ListTile(
                              title: Text(document['feed']),
                              subtitle: Text(document['date']),
                            ),
                          );
                        }).toList(),
                      ),
                      // ListView.builder(
                      //   itemCount: streamSnapshot.data.docs.length,
                      //   itemBuilder: (ctx, index) {
                      //         return Text(streamSnapshot.data.docs[index]['feed']);
                      //   }
                      // ),
                    );
                  },
                ),
              )
            ],
          );
        }
      ),
    );
  }
}
