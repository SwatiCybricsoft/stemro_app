import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploader {
  void openGallery(BuildContext context, String category) async {
    String subcategory = "Gallery";
    String destination = "$category/$subcategory";
    final firebaseStorage = FirebaseStorage.instance;
    PickedFile? image =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (image != null) {
      showAlertDialog(context);
      var file = File(image.path);
      var snapshot = await firebaseStorage
          .ref("$destination/${file.path}")
          .putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      print(downloadUrl);
      SaveDatabase(context, category, subcategory, downloadUrl);
    } else {
      print('No Image Path Received');
    }
  }

  void openCamera(BuildContext context, String category) async {
    String subcategory = "Camera";
    String destination = "$category/$subcategory";
    final firebaseStorage = FirebaseStorage.instance;
    PickedFile? image =
        await ImagePicker().getImage(source: ImageSource.camera);
    if (image != null) {
      showAlertDialog(context);
      var file = File(image.path);
      var snapshot = await firebaseStorage
          .ref("$destination/${file.path}")
          .putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      print(downloadUrl);
      SaveDatabase(context, category, subcategory, downloadUrl);
    } else {
      print('No Image Path Received');
    }
  }

  void SaveDatabase(BuildContext context, String category, String subcategory,
      String downloadUrl) {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    final imageData = {
      'imageURL': downloadUrl,
      'Category': category,
      'Subcategory': subcategory,
    };

    final newVisitKey = FirebaseDatabase.instance.ref().push().key;

    final Map<String, Map> updates = {};
    updates['/Users/$uid/Images/$newVisitKey'] = imageData;

    FirebaseDatabase.instance.ref().update(updates);

    Navigator.pop(context);
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 8),
              child: const Text("Uploading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
