import 'dart:async';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => MapState();
}

class MapState extends State<Map> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final ref = FirebaseDatabase.instance.ref();
  Set<Marker> markers = {};

  final _auth = FirebaseAuth.instance;
  late User loggedinUser;
  bool lockLock = false;

  void initState() {
    super.initState();
    getCurrentUser();
  }

  //using this function you can use the credentials of the user
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedinUser = user;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {return false;},
      child: Scaffold(
        body: StreamBuilder(
          stream: ref.child('Location').onValue,
          builder: (context, snap) {
            if (snap.hasError) {
              return Text('Something went wrong');
            }
            if (snap.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            double lat = double.parse(snap.data!.snapshot.child("Latitude").value.toString());
            double long = double.parse(snap.data!.snapshot.child("Longitude").value.toString());

            final latLng = LatLng(double.parse(snap.data!.snapshot.child("Latitude").value.toString()), double.parse(snap.data!.snapshot.child("Longitude").value.toString()));

            // Add new marker with markerId.
            markers.add(Marker(markerId: const MarkerId("Location"), position: latLng));

            // If google map is already created then update camera position with animation
            // final GoogleMapController mapController = await _controller.future;
            // mapController.animateCamera(CameraUpdate.newCameraPosition(
            //   CameraPosition(
            //     target: latLng,
            //     zoom: 15.8746,
            //   ),
            // ));

            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(lat, long),
                zoom: 15.8746,
              ),

              // Markers to be pointed
              markers: markers,
              onMapCreated: (GoogleMapController controller) {
                // Assign the controller value to use it later
                _controller.complete(controller);
              },
            );
          },
        ),
        floatingActionButton: StreamBuilder(
          stream: ref.child('Location').onValue,
          builder: (context, snap) {
            if (snap.hasError) {
              return const Text('Something went wrong');
            }
            if (snap.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }

            String lock = snap.data!.snapshot.child("lock").value.toString();

            return Padding(
              padding: const EdgeInsets.only(right: 39.0),
              child: FloatingActionButton.extended(
                backgroundColor: Colors.white,
                onPressed: (){
                    ref.child('Location').update(
                      {"lock": 1}
                    );
                },
                label: lock=='0'
                    ? const Text('Lock',style: TextStyle(color: Colors.green),)
                    : const Text('Locked',style: TextStyle(color: Colors.redAccent)),
                icon: const Icon(Icons.lock, color: Colors.black54,),
              ),
            );
          }
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(0),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black54,
                
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('PBS Sri Lanka', style: TextStyle(color: Colors.black87),),
        ),
      ),
    );
  }
}