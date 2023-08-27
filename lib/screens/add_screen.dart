import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:water_where_ah/models/water_cooler.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  // gets the user's current location
  Future<GeoPoint> getUserLocation() async {
    debugPrint("Fetching user location");
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    debugPrint('$position');
    return GeoPoint(position.latitude, position.longitude);
  }

  // add a method to add a new watercooler to the database
  void addWatercooler() async {
    debugPrint("Adding a new watercooler");
    // get the form data
    final isFormValid = _formKey.currentState!.saveAndValidate();
    Map<String, dynamic> formDa = {
      "location": await getUserLocation(),
      "isApproved": 1,
      "isWorking": true,
      "reportCount": 0,
    };

    if (!isFormValid) {
      debugPrint("Form is not valid");
      return;
    }

    // print the form data to the console
    _formKey.currentState!.value.forEach((key, value) {
      debugPrint("$key : $value");
      if (key == "waterTemp") {
        if (value.contains("cold")) {
          formDa["hasCold"] = true;
        }
        if (value.contains("hot")) {
          formDa["hasHot"] = true;
        }
        if (value.contains("roomTemp")) {
          formDa["hasCold"] = true;
          formDa["hasHot"] = true;
        }
      } else {
        formDa[key] = value;
      }
    });

    FirebaseFirestore.instance.collection("waterCooler").add(formDa);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Contribute a new Watercooler'),
          actions: [
            IconButton(
                onPressed: () {
                  // add a call to the add Watercooler method
                  addWatercooler();
                },
                icon: const Icon(Icons.save_rounded))
          ],
        ),
        floatingActionButton:
            // make a button to wipe data
            FloatingActionButton(
          onPressed: () {
            // reset the form
            _formKey.currentState!.reset();
          },
          child: const Icon(Icons.delete_forever_rounded),
        ),
        body: SingleChildScrollView(
            child: FormBuilder(
          key: _formKey,
          child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: "operator",
                    decoration: InputDecoration(
                      labelText: "Building Name",
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w600),
                      helperText:
                          "e.g. SUTD (Level: 1) or East Coast Park (Zone: A)",
                      hintText: "Enter the name of the building",
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const Padding(padding: EdgeInsets.all(8.0)),
                  FormBuilderSwitch(
                      name: "wheelchairFriendly",
                      initialValue: false,
                      decoration: const InputDecoration(
                        helperText:
                            "(This watercooler is around a child height)",
                        // no border
                        border: InputBorder.none,
                      ),
                      title: const Text("Wheelchair Friendly",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w600))),
                  const Padding(padding: EdgeInsets.all(8.0)),
                  FormBuilderSwitch(
                      name: "bottleFriendly",
                      initialValue: false,
                      decoration: const InputDecoration(
                        helperText:
                            "(The watercooler has a top down dispenser)",
                        // no border
                        border: InputBorder.none,
                      ),
                      title: const Text("Is the cooler water bottle friendly?",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w600))),
                  const Padding(padding: EdgeInsets.all(8.0)),
                  FormBuilderCheckboxGroup(
                    name: "waterTemp",
                    decoration: const InputDecoration(
                      labelText:
                          "Temperature of the water (select all that apply)",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                      border: InputBorder.none,
                    ),
                    options: const [
                      FormBuilderFieldOption(
                          value: "cold", child: Text("Cold ❄️")),
                      FormBuilderFieldOption(
                          value: "roomTemp", child: Text("Room Temp 💨")),
                      FormBuilderFieldOption(
                          value: "hot", child: Text("Hot 🔥")),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.all(8.0)),
                  FormBuilderTextField(
                    name: "remarks",
                    maxLines: 2,
                    maxLength: 100,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    decoration: InputDecoration(
                      labelText: "Remarks",
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w600),
                      helperText:
                          "e.g. Turn left after exiting the Lift Lobby A",
                      hintText: "Enter some helpful remarks",
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        )));
  }
}
