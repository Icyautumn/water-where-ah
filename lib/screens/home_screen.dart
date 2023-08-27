import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:water_where_ah/models/water_cooler.dart';
import 'package:water_where_ah/screens/add_screen.dart';
import 'package:water_where_ah/screens/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<LatLng> _userLocation;
  final _watercoolerStream = FirebaseFirestore.instance.collection('watercoolers').snapshots();

  // checks if the user has granted access to their location
  Future<LatLng> checkLocationPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.unableToDetermine) {
      permission = await Geolocator.requestPermission();
      LatLng userLocation = await getUserLocation();
      return userLocation;
    } else {
      LatLng userLocation = await getUserLocation();
      return userLocation;
    }
  }

  // gets the user's current location
  Future<LatLng> getUserLocation() async {
    debugPrint("Fetching user location");
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    debugPrint('$position');
    return LatLng(position.latitude, position.longitude);
  }

  navigateToWaterCoolerInfo(WaterCooler watercooler) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DrawerTest(waterCooler: watercooler),
      ),
    );
  }

  navigateToAddScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    debugPrint("Initializing bus stops");
    _userLocation = checkLocationPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: FutureBuilder(
              future: FirebaseFirestore.instance.collection('watercoolers').get(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData) {
                  var waterCoolers =
                      snapshot.data?.docs.map((e) => WaterCooler.fromFirestore(e)).toList();

                  return FutureBuilder(
                      future: _userLocation,
                      builder: (context, AsyncSnapshot<LatLng> snapshot) {
                        // display a loading indicator while the user's location is being fetched
                        if (snapshot.hasData) {
                          // if the user has granted access to their location, display the list of nearby bus stops
                          return SizedBox(
                            height: double.infinity,
                            width: double.infinity,
                            child: FlutterMap(
                                options: MapOptions(
                                  center: snapshot.data,
                                  minZoom: 11,
                                  zoom: 15,
                                  maxZoom: 18,
                                  interactiveFlags: InteractiveFlag.all &
                                      ~InteractiveFlag.pinchMove &
                                      ~InteractiveFlag.rotate,
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        "https://www.onemap.gov.sg/maps/tiles/Default/{z}/{x}/{y}.png",
                                    userAgentPackageName: 'com.example.water_where_ah',
                                  ),
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        width: 80.0,
                                        height: 80.0,
                                        point: snapshot.data!,
                                        builder: (ctx) => Stack(children: [
                                          Icon(
                                            Icons.circle,
                                            color: Colors.blue[600],
                                            shadows: [
                                              Shadow(
                                                blurRadius: 50,
                                                color: Colors.lightBlue.shade300,
                                              )
                                            ],
                                            fill: 1,
                                            size: 28,
                                          ),
                                          const Icon(
                                            Icons.circle_outlined,
                                            color: Colors.white,
                                            size: 28,
                                            opticalSize: 10,
                                          ),
                                        ]),
                                      ),
                                      ...waterCoolers!.map(
                                        (e) {
                                          return Marker(
                                            width: 80.0,
                                            height: 80.0,
                                            point: e.location,
                                            builder: (ctx) => IconButton(
                                                icon: Icon(
                                                  Icons.water_drop,
                                                  color: Colors.blue[800],
                                                  shadows: const [
                                                    Shadow(
                                                      blurRadius: 10,
                                                      color: Colors.white,
                                                      offset: Offset(0, 0),
                                                    )
                                                  ],
                                                  fill: 1,
                                                  size: 32,
                                                ),
                                                onPressed: () => navigateToWaterCoolerInfo(e)),
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                ]),
                          );
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        } else if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(strokeWidth: 3),
                          );
                        } else {
                          return const SizedBox(height: 0);
                        }
                      });
                } else {
                  return const SizedBox(height: 0);
                }
              })),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => navigateToAddScreen(),
        tooltip: 'y e s',
        label: const Text('Contribute a water cooler'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
