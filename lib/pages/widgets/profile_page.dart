import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_ui/common/theme_helper.dart';
import 'package:login_ui/pages/widgets/pass.dart';
import 'package:login_ui/pages/widgets/pin.dart';
import 'package:login_ui/pages/widgets/prof.dart';

class Profile extends StatefulWidget {
  final String UID;

  const Profile({Key key, this.UID}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  var profileData;

  getSuggestion(String UID) => FirebaseFirestore.instance
      .collection('user')
      .where('uid', isEqualTo: UID)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Text('My Profile'),
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
        backgroundColor: Colors.white,
        body: StreamBuilder(
          stream: getSuggestion(widget.UID),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var snapshotData = snapshot.data.docs[0];
            return SingleChildScrollView(
              child: Column(
                children: [
                  SafeArea(
                    child: Container(
                      //this is login form
                      padding: EdgeInsets.fromLTRB(25, 50, 25, 10),
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Column(
                        children: [
                          SizedBox(height: 30.0),
                          const Text(
                            'Username',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.normal),
                          ),
                          Card(
                            child: ListTile(
                              title: Text(snapshotData['name']??''),
                              trailing: InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Prof())).then((value) {
                                 if (value != null) {
                                    var collection = FirebaseFirestore.instance
                                        .collection('user');
                                    collection
                                        .doc(widget
                                            .UID) // <-- Doc ID where data should be updated.
                                        .update(
                                            {'name': value}) // <-- Updated data
                                        .then((_) => print('Updated'))
                                        .catchError((error) =>
                                            print('Update failed: $error'));
                                  }
                                }),
                                child: Icon(Icons.arrow_forward_ios),
                              ),
                            ),
                          ),
                          SizedBox(height: 30.0),
                          Text(
                            'Email ID',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.normal),
                          ),
                          Card(
                            child: ListTile(
                              title: Text(snapshotData['email']),
                            ),
                          ),
                          SizedBox(height: 30.0),
                          Text(
                            'Mobile No.',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.normal),
                          ),
                          Card(
                            child: ListTile(
                              title: Text(snapshotData['phone']),
                            ),
                          ),
                          SizedBox(height: 30.0),
                          Text(
                            'PIN Code',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.normal),
                          ),
                          Card(
                            child: ListTile(
                              title: Text(snapshotData['pin']??''),
                              trailing: InkWell(
                                onTap: () async => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => pin())).then((value) {
                                  if (value != null) {
                                    var collection = FirebaseFirestore.instance
                                        .collection('user');
                                    collection
                                        .doc(widget
                                            .UID) // <-- Doc ID where data should be updated.
                                        .update(
                                            {'pin': value}) // <-- Updated data
                                        .then((_) => print('Updated'))
                                        .catchError((error) =>
                                            print('Update failed: $error'));
                                  }
                                }),
                                child: Icon(Icons.arrow_forward_ios),
                              ),
                            ),
                          ),

                          SizedBox(height: 50),
                          Container(
                            decoration: ThemeHelper().buttonBoxDecoration(
                                context),

                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => pass()));
                              }, //after login redirect to homepage
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text('change password'.toUpperCase(),
                                    style: TextStyle(fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
