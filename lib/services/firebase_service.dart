import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FirebaseService {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  /// Upload image to Firebase Storage and return download URL
  Future<String> uploadImage(File imageFile) async {
    final String fileId = const Uuid().v4();
    final ref = _storage.ref().child('issue_images/$fileId.jpg');

    UploadTask uploadTask = ref.putFile(imageFile);
    TaskSnapshot snapshot = await uploadTask;

    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  /// Save report data to Firestore
  Future<void> saveReport({
    required String category,
    required String description,
    required double latitude,
    required double longitude,
    required String imageUrl,
  }) async {
    final report = {
      'category': category,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _firestore.collection('reports').add(report);
  }
}

