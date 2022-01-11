import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:login_ui/Assistants/assistantMethods.dart';
import 'package:login_ui/pages/feedback.dart';
import 'package:login_ui/pages/station.dart';
import 'package:login_ui/pages/widgets/Divider.dart';
import 'package:login_ui/pages/widgets/qr_scan.dart';
import 'drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  // String result = "";
  // Future _scanQR() async {
  //   try {
  //     String qrResult = (await BarcodeScanner.scan()) as String;
  //     setState(() {
  //       result = qrResult;
  //     });
  //   } on PlatformException catch (ex) {
  //     if (ex.code == BarcodeScanner.cameraAccessDenied) {
  //       setState(() {
  //         result = "Camera permission was denied";
  //       });
  //     } else {
  //       setState(() {
  //         result = "Unknown Error $ex";
  //       });
  //     }
  //   } on FormatException {
  //     setState(() {
  //       result = "Slot Claimed!!!";
  //     });
  //   } catch (ex) {
  //     setState(() {
  //       result = "Unknown Error $ex";
  //     });
  //   }
  // }

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  Position currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 0;

  void locatePosition() async {
    Position position = await geoLocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
    new CameraPosition(target: latLatPosition, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    var address = await AssistantMethods.searchCoordinateAddress(position);
    print('This is your Address::' + address);
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final Set<Marker> markers = new Set();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        //leading: IconButton(icon: Icon(Icons.menu), onPressed: (){

        // },),

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => station()));
            },
          ),
        ],
        toolbarHeight: 50,
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
      body: Center(
        child: Stack(
          children: [
            GoogleMap(
              padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              initialCameraPosition: _kGooglePlex,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;

                setState(() {
                  bottomPaddingOfMap = 265.0;
                });
                locatePosition();
              },
              markers: markers.map((e) => e).toSet(),
              //polylines: _polylines,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.teal.shade400,
          icon: Icon(Icons.camera_alt),
          label: Text("Scan"),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => qrCode()));
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  fetchAllContact() async {
    List contactList = [];
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection("collection").get();
    for (int i = 0; i < querySnapshot.size; i++) {
      var a = querySnapshot.docs[i];
      print('Query Snapshot -- ${a.id}');
    }
  }

  List<Marker> markerss = [];
  @override
  void initState() {
    intilize();
    super.initState();
  }

  intilize() {
    Marker firstMarker = Marker(
      //add first marker
      markerId: MarkerId("first"),
      position: LatLng(12.920440, 77.564660), //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: 'ChargeGrid',
        snippet: 'TYPE-2 CHARGING',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRose), //Icon for Marker
    );

    Marker secondMarker = Marker(
      //add second marker
      markerId: MarkerId("second"),
      position: LatLng(12.973826, 77.590591), //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: 'Charzer',
        snippet: 'TYPE-2 CHARGING',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRose), //Icon for Marker
    );

    Marker thirdMarker = Marker(
      //add third marker
      markerId: MarkerId("third"),
      position: LatLng(12.955496, 77.595786), //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: 'PlugNGo',
        snippet: 'TYPE-3 CHARGING',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRose), //Icon for Marker
    );

    Marker fourthMarker = Marker(
      //add fourth marker
      markerId: MarkerId("Fourth"),
      position: LatLng(13.011053, 77.554939), //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: 'Fortnum',
        snippet: 'TYPE-1 CHARGING',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRose), //Icon for Marker
    );
    //add more markers here
    setState(() {
      markers.add(firstMarker);
      markers.add(secondMarker);
      markers.add(thirdMarker);
      markers.add(fourthMarker);
    });
  }
// Set<Marker> getmarkers() { //markers to place on map
//   setState(() {
//     markers.add(Marker( //add first marker
//       markerId: MarkerId(showLocation.toString()),
//       position: showLocation, //position of marker
//       infoWindow: InfoWindow( //popup info
//         title: 'Marker Title First ',
//         snippet: 'My Custom Subtitle',
//       ),
//       icon: BitmapDescriptor.defaultMarker, //Icon for Marker
//     ));
//
//     markers.add(Marker( //add second marker
//       markerId: MarkerId(showLocation.toString()),
//       position: LatLng(27.7099116, 85.3132343), //position of marker
//       infoWindow: InfoWindow( //popup info
//         title: 'Marker Title Second ',
//         snippet: 'My Custom Subtitle',
//       ),
//       icon: BitmapDescriptor.defaultMarker, //Icon for Marker
//     ));
//
//     markers.add(Marker( //add third marker
//       markerId: MarkerId(showLocation.toString()),
//       position: LatLng(27.7137735, 85.315626), //position of marker
//       infoWindow: InfoWindow( //popup info
//         title: 'Marker Title Third ',
//         snippet: 'My Custom Subtitle',
//       ),
//       icon: BitmapDescriptor.defaultMarker, //Icon for Marker
//     ));
//
//     //add more markers here
//   });
//
//   return markers;
// }
}