import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

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
                    onImage: (image) {
                      
                    },
                  ),
                ],
              )),
        )));
  }
}
