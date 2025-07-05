import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import '../services/firebase_service.dart';

class ReportForm extends StatefulWidget {
  @override
  _ReportFormState createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  final _formKey = GlobalKey<FormState>();
  String _category = 'Pothole';
  String _description = '';
  File? _image;
  Position? _position;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _position = position;
    });
  }

  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate() && _image != null && _position != null) {
      String imageUrl = await FirebaseService.uploadImage(_image!);
      await FirebaseService.addReport({
        'category': _category,
        'description': _description,
        'latitude': _position!.latitude,
        'longitude': _position!.longitude,
        'imageUrl': imageUrl,
        'timestamp': DateTime.now(),
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Report submitted successfully!')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please complete all fields.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Report Issue')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  value: _category,
                  items: ['Pothole', 'Signal Issue', 'Broken Sign', 'Others']
                      .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (value) => setState(() => _category = value!),
                  decoration: InputDecoration(labelText: 'Issue Type'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
                  onChanged: (value) => _description = value,
                ),
                SizedBox(height: 10),
                ElevatedButton(onPressed: _pickImage, child: Text('Add Photo')),
                _image != null ? Image.file(_image!, height: 150) : Container(),
                ElevatedButton(onPressed: _getLocation, child: Text('Get Current Location')),
                SizedBox(height: 10),
                ElevatedButton(onPressed: _submitReport, child: Text('Submit Report')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

