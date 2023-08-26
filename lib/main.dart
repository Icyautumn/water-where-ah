import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:water_where_ah/firebase_options.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 500,
          width: 400,
          child: FlutterMap(
              options: MapOptions(
                center: LatLng(1.333800, 103.918037), // TODO: replace with current user location
                minZoom: 11,
                zoom: 17,
                maxZoom: 18,
                interactiveFlags:
                    InteractiveFlag.all & ~InteractiveFlag.pinchMove & ~InteractiveFlag.rotate,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://maps-a.onemap.sg/v3/Night/{z}/{x}/{y}.png",
                  userAgentPackageName: 'com.example.water_where_ah',
                ),
              ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
