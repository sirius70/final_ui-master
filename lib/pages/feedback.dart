import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_ui/common/theme_helper.dart';
import 'package:login_ui/pages/widgets/home.dart';

class FeedBack extends StatefulWidget {
  final String stationId;
  final String slotTiming;

  const FeedBack({Key key, this.stationId, this.slotTiming}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FeedBackState();
  }
}

class _FeedBackState extends State<FeedBack> {
  double _headerHeight = 25;
  final _formKey = GlobalKey<FormState>();
  bool agree = true;
  final feed = new TextEditingController();
  bool isSwitched = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Image.asset(
          'assets/images/ev.png',
          fit: BoxFit.contain,
          height: 250,
        ),
        toolbarHeight: 175,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container(
            //   height: _headerHeight,
            // ),
            SafeArea(
              child: Container(
                //this is login form
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: [
                    SizedBox(height: 30.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Text(
                            'Please give us your feedback! :)',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 60.0),
                          TextFormField(
                            decoration: ThemeHelper().textInputDecoration(
                                'Feedback', 'Enter your feedback'),
                            autofocus: false,
                            controller: feed,
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              RegExp regex = new RegExp(r'^.{3,}$');
                              if (value.isEmpty) {
                                return ("Feedback is required");
                              }
                              ;
                              if (!regex.hasMatch(value)) {
                                return ("Please enter valid name(Min. 3 characters)");
                              }
                              return null;
                            },
                            onSaved: (value) {
                              feed.text = value;
                            },
                            textInputAction: TextInputAction.next,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Is EV Station working?\t'),
                              Switch(
                                value: isSwitched,
                                onChanged: (value) {
                                  setState(() {
                                    isSwitched = value;
                                    print(isSwitched);
                                  });
                                },
                                activeTrackColor: Colors.lightGreenAccent,
                                activeColor: Colors.green,
                              ),
                            ],
                          ),
                          SizedBox(height: 175),
                          Container(
                            decoration:


                                ThemeHelper().buttonBoxDecoration(context),
                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              onPressed: () async {
                                final user =
                                    await FirebaseAuth.instance.currentUser;
                                //adding into database
                                Map<String, dynamic> data = {
                                  "uid": user.uid,
                                  "userName": user.email,
                                  "feed": feed.text,
                                  "workingCondition": isSwitched,
                                  "stationId": widget.stationId,
                                  "date": DateTime.now().toString(),
                                };
                                FirebaseFirestore.instance
                                    .collection("feedback")
                                    .add(data);

                                QuerySnapshot querySnap =
                                    await FirebaseFirestore.instance
                                        .collection('stations')
                                        .where('stationId',
                                            isEqualTo: widget.stationId)
                                        .get();
                                print('stationID:::${widget.stationId}');
                                QueryDocumentSnapshot doc = querySnap.docs[0];
                                DocumentReference docRef = doc.reference;
                                await FirebaseFirestore.instance
                                    .collection('stations')
                                    .doc(docRef.id)
                                    .update({
                                  "availability": FieldValue.increment(1)
                                });

                                QuerySnapshot querySnap1 =
                                    await FirebaseFirestore.instance
                                        .collection('slotbooking')
                                        .where('stationId',
                                            isEqualTo: widget.stationId)
                                        .get();
                                QueryDocumentSnapshot doc1 = querySnap1.docs[0];
                                DocumentReference docRef1 = doc1.reference;
                                var newItems = [];
                                newItems.add(widget.slotTiming);
                                await FirebaseFirestore.instance
                                    .collection("slotbooking")
                                    .doc(docRef1.id)
                                    .update({
                                  "slotTimings": FieldValue.arrayUnion(newItems)
                                });

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Home()));
                              }, //after login redirect to homepage
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text('submit'.toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
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
