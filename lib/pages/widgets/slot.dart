import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_ui/common/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:login_ui/pages/widgets/home.dart';
import 'package:login_ui/pages/widgets/qr_scan.dart';
import 'package:login_ui/pages/widgets/stationdetail.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../feedback.dart';
import '../slotDetail.dart';

class slot extends StatefulWidget {
  slot({Key key, this.id}) : super(key: key);

  @override
  State<slot> createState() => _slotState();
  final String id;
}

class _slotState extends State<slot> {
  int totalAmount = 100;
  Razorpay _razorpay;
  String dropdownvalue = '-----';

  var items = [
    '9AM-10AM',
    '10AM-11AM',
    '11AM-12AM',
    '12AM-1AM',
    '-----',
    '1PM-2PM',
    '2PM-3PM',
    '3PM-4PM',
    '4PM-5PM'
  ];

  final myController = TextEditingController();

  String inputId = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_kOmQ6n4iunyQhQ',
      'amount': totalAmount * 100,
      'name': 'CHARGEMe!!',
      'Description': 'Test Payment',
      'prefill': {'contact': '', 'email': ''},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Fluttertoast.showToast(msg: 'SUCCESS: ' + response.paymentId);
    QuerySnapshot querySnap = await FirebaseFirestore.instance
        .collection('stations')
        .where('stationId', isEqualTo: widget.id)
        .get();
    QueryDocumentSnapshot doc = querySnap.docs[
    0];
    final user = await FirebaseAuth.instance.currentUser;
    // Assumption: the query returns only one document, THE doc you are looking for.
    var slotDetail = {'uid': user.uid,
      'username': user.email,
      'stationId': widget.id,
      'slotTiming': dropdownvalue,
      'date': DateTime.now().toString()};

    DocumentReference docRef = doc.reference;
    await FirebaseFirestore.instance
        .collection('stations')
        .doc(docRef.id)
        .update({"availability": FieldValue.increment(-1)});
    await FirebaseFirestore.instance
        .collection('slotDetails')
        .add(slotDetail);

    QuerySnapshot querySnap1 = await FirebaseFirestore.instance
        .collection('slotbooking')
        .where('stationId', isEqualTo: widget.id)
        .get();
    QueryDocumentSnapshot doc1 = querySnap1.docs[
    0];
    DocumentReference docRef1 = doc1.reference;
    var newItems = [];
    newItems.add(dropdownvalue);
    await FirebaseFirestore.instance.collection("slotbooking")
        .doc(docRef1.id)
        .update({"slotTimings": FieldValue.arrayRemove(newItems)});
    // Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => slotDetails(
    //       slotModel: SlotModel(
    //         uid: document['uid'],
    //         stationId: document['stationId'],
    //         slotTiming: document['slotTiming'],
    //         date: document['Date'],
    //       ),
    //     )));


    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (context) =>
              Home()),
          (route) => false,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: 'ERROR: ' + response.code.toString() + '-' + response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: 'EXTERNAL WALLET: ' + response.walletName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => FeedBack()));
              Navigator.pop(context);
            },
          ),
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Text('BOOK YOUR SLOT'),
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
        body: SafeArea(
          child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Container(
                      width: 200,
                      child: Card(
                        child: ListTile(
                          title: Center(child: Text('Station ID ::: ${widget
                              .id}')),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('slotbooking')
                            .where('stationId', isEqualTo: widget.id)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          } else {
                            return Container(
                              height: 50,
                              child: ListView(
                                children:
                                snapshot.data.docs.map<Widget>((document) {
                                  List<String> data =
                                  document['slotTimings'].cast<String>();
                                  return Center(
                                    child: Container(
                                      child: DropdownButton(
                                        value: dropdownvalue,
                                        icon: Icon(Icons.keyboard_arrow_down),
                                        items: data.map((String items) {
                                          return DropdownMenuItem(
                                              value: items, child: Text(items));
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            dropdownvalue = newValue.toString();
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          }
                        }),
                  ),
                  SizedBox(height: 90),
                  Container(
                      decoration: ThemeHelper().buttonBoxDecoration(context),
                      child: ElevatedButton(
                          style: ThemeHelper().buttonStyle(),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  // Retrieve the text the that user has entered by using the
                                  // TextEditingController.
                                    content: Text(
                                        "Station-ID - ${widget
                                            .id}\nSlot - ${dropdownvalue}"));
                              },
                            );
                          },
                          child: Text("Verify".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)))),
                  SizedBox(height: 90),
                  Container(
                    decoration: ThemeHelper().buttonBoxDecoration(context),
                    child: ElevatedButton(
                      style: ThemeHelper().buttonStyle(),
                      onPressed: () {
                        openCheckout();
                      }, //after login redirect to homepage
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                        child: Text('Pay to confirm slot'.toUpperCase(),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ),
                  )
                ],
              )),
        ));
  }
}
