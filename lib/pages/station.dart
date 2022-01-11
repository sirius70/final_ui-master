import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:login_ui/common/theme_helper.dart';
import 'package:login_ui/model/stationModel.dart';
import 'package:login_ui/pages/widgets/stationdetail.dart';

class station extends StatefulWidget {
  @override
  _stationState createState() => _stationState();
}

class _stationState extends State<station> {
  TextEditingController searchController;
  String searchtxt = '';

  static List<String> stationname = [
    'ChargeGrid',
    'Fortnum',
    'Charzer',
    'PlugNGo',
    'Tata Power'
  ];

  static List url = [
    'https://2.bp.blogspot.com/-OXaiN6n7oXI/T5TZvk0h6jI/AAAAAAAAA8s/_EfDAyzmRAo/s1600/biogas+station.jpg',
    'https://i1.wp.com/mercomindia.com/wp-content/uploads/2019/01/Untitled-design6-3.png?fit=650%2C450&ssl=1',
    'https://i.pinimg.com/originals/f7/0b/77/f70b773ad08365650fa9020ae204de92.jpg',
    'https://evreporter.com/wp-content/uploads/2019/09/Kona-Image-2.jpg',
    'https://cdni.autocarindia.com/Utils/ImageResizer.ashx?n=http%3A%2F%2Fcdni.autocarindia.com%2FExtraImages%2F20170823125520_TataPower.jpg&h=578&w=872&c=0&q=100',
  ];

  static List<String> stationid = [
    'StationID: EVS001',
    'StationID: EVS002',
    'StationID: EVS003',
    'StationID: EVS004',
    'StationID: EVS005'
  ];

  static List<String> stationdesc = [
    'ADDRESS: 1st Main, 1st Cross Rd,Kamakshipalya,Bengaluru, CONNECTOR:TYPE-2 CHARGING',
    'ADDRESS: 1st Main, Richmond Road,Richmond Town,Bengaluru, CONNECTOR: TYPE-1 CHARGING',
    'ADDRESS: 19th C-cross, 7th Block, Jayanagar, Bengaluru, CONNECTOR: TYPE-2 CHARGING',
    'ADDRESS: Block 4,Banashankari Stage 1,Indiranagar,Bengaluru, CONNECTOR: TYPE-3 CHARGING',
    'ADDRESS: 17th Main, KHB colony, Koramangala, Bengaluru, CONNECTOR: TYPE-1 CHARGING'
  ];

  static List<String> stationcontact = [
    'Phone No: 8974563251',
    'Phone No: 9874568952',
    'Phone No: 7584968542',
    'Phone No: 9974586248',
    'Phone No: 8997845689'
  ];

  // final List<StationModel> Stationdata = List.generate(
  //     stationname.length,
  //     (index) => StationModel(
  //         '${stationname[index]}',
  //         '${url[index]}',
  //         '${stationid[index]}',
  //         '${stationdesc[index]}',
  //         '${stationcontact[index]}'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text('EV Charging Station Near me'),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
            child: TextField(
              decoration: ThemeHelper()
                  .textInputDecoration('Search', 'Start typing...'),
              controller: searchController,
              textInputAction: TextInputAction.search,
              textCapitalization: TextCapitalization.words,
              autofocus: true,
              onChanged: (val) {
                setState(() {
                  searchtxt = val;
                });
                print(searchtxt);
              },
            ),
          ),
          SizedBox(height: 30,),
          StreamBuilder(
              stream: (searchtxt != "" && searchtxt != null)
                  ? FirebaseFirestore.instance
                      .collection("stations")
                      .orderBy("stationName")
                      .startAt([searchtxt]).endAt(
                          [searchtxt + '\uf8ff']).snapshots()
                  : FirebaseFirestore.instance
                      .collection("stations")
                      .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Expanded(
                  child: ListView(
                    children: snapshot.data.docs.map((document) {
                      return Card(
                        child: ListTile(
                          title: Text(document['stationName']),
                          leading: SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.network(document['imgUrl']),
                          ),

                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Stationdetail(
                                      stationModel: StationModel(
                                        name: document['stationName'],
                                        id: document['stationId'],
                                        address: document['address'],
                                        availability: document['availability'],
                                        connectorType:
                                            document['connectorType'],
                                        contact: document['stationContact'],
                                        ImageUrl: document['imgUrl'],
                                        workingCondition: document['workingCondition'],
                                      ),
                                    )));
                          },
                        ),
                      );
                    }).toList(),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
