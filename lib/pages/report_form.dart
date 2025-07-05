// report_form.dart placeholder
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

class ReportForm extends StatefulWidget {
  const ReportForm({super.key});

  @override
  State<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  final _formKey = GlobalKey<FormState>();
  String _category = 'Pothole';
  String _description = '';
  File? _image;
  Position? _location;

  final List<String> _categories = [
    'Pothole',
    'Broken Signal',
    'Blocked Sign',
    'Flooded Road',
    'Other'
  ];

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  Future<void> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _location = pos;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _image != null && _location != null) {
      _formKey.currentState!.save();

      import '../services/firebase_service.dart';

...

final firebaseService = FirebaseService();

String imageUrl = await firebaseService.uploadImage(_image!);

await firebaseService.saveReport(
  category: _category,
  description: _description,
  latitude: _location!.latitude,
  longitude: _location!.longitude,
  imageUrl: imageUrl,
);

      print('Category: $_category');
      print('Description: $_description');
      print('Image Path: ${_image!.path}');
      print('Location: Lat=${_location!.latitude}, Long=${_location!.longitude}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Report submitted successfully!')),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete all fields and capture photo + location')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Report an Issue')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _category,
                items: _categories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _category = val!;
                  });
                },
                decoration: InputDecoration(labelText: 'Select Category'),
              ),
              SizedBox(height: 10),
              TextFormField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                onSaved: (val) {
                  _description = val ?? '';
                },
                validator: (val) =>
                    val == null || val.isEmpty ? 'Please enter description' : null,
              ),
              SizedBox(height: 10),
              _image != null
                  ? Image.file(_image!, height: 200)
                  : Text('No image selected'),
              ElevatedButton.icon(
                icon: Icon(Icons.camera_alt),
                label: Text('Capture Image'),
                onPressed: _pickImage,
              ),
              SizedBox(height: 10),
              _location != null
                  ? Text(
                      'Location: ${_location!.latitude}, ${_location!.longitude}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : Text('Fetching location...'),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.upload),
                label: Text('Submit Report'),
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

