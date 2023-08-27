import 'dart:io';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as image_lib;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:water_where_ah/helper/image_classification_helper.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  ImageClassificationHelper? imageClassificationHelper;
  Map<String, double>? classification;
  double classificationOfWaterCoolerPercent = 0.0;

  @override
  void initState() {
    imageClassificationHelper = ImageClassificationHelper();
    imageClassificationHelper!.initHelper();
    super.initState();
  }

  @override
  void dispose() {
    imageClassificationHelper?.close();
    super.dispose();
  }

  // add a method to add a new watercooler to the database
  void addWatercooler() {
    debugPrint("Adding a new watercooler");
    // get the form data
    final formData = _formKey.currentState!.saveAndValidate();

    // print the form data to the console
    debugPrint(_formKey.currentState!.value['remarks']);
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
        body: SingleChildScrollView(
            child: FormBuilder(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  FormBuilderImagePicker(
                    name: 'image',
                    maxImages: 1,
                    bottomSheetPadding: const EdgeInsets.all(16),
                    availableImageSources: const [ImageSourceOption.camera],
                    onChanged: (value) async {
                      if (value?.isEmpty == true) return;
                      var file = value?[0] as XFile?;
                      if (file == null) return;
                      var bytes = await file.readAsBytes();
                      var image = image_lib.Image.fromBytes(
                        width: 250,
                        height: 250,
                        bytes: bytes.buffer,
                      );
                      var classification = await imageClassificationHelper!
                          .inferenceImage(image);
                      var percentOfNot = classification['Class 2'];
                      var percentOfYes = classification['Class 1'];
                      setState(() {
                        classificationOfWaterCoolerPercent =
                            percentOfNot == null
                                ? percentOfYes!
                                : 1 - percentOfNot;
                      });
                    },
                  ),
                  Text(
                      'Is a watercooler: ${classificationOfWaterCoolerPercent * 100}')
                ],
              )),
        )));
  }
}
