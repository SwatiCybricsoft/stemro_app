import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stemro_app/auth/login_screen.dart';
import 'package:stemro_app/form/visit_page.dart';
import 'package:stemro_app/view/ImageUploader.dart';
import 'package:stemro_app/view/home_screen.dart';
import '../auth/AuthService.dart';

class LabPicture extends StatefulWidget {
  const LabPicture({Key? key}) : super(key: key);

  @override
  State<LabPicture> createState() => _LabPictureState();
}

class _LabPictureState extends State<LabPicture> {
  File? _image;
  var imageUploader = ImageUploader();

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "File Upload",
              style: TextStyle(color: Colors.teal),
            ),
            content: SingleChildScrollView(
              // child: ListBody(
              //   children: [
              //     Divider(
              //       height: 1,
              //       color: Colors.teal,
              //     ),
              //     ListTile(
              //       onTap: () {
              //         // imageUploader.openGallery(context, "Lab Pictures");
              //       },
              //       title: Text("Gallery"),
              //       leading: Icon(
              //         Icons.account_box,
              //         color: Colors.teal,
              //       ),
              //     ),
              //     // Divider(
              //     //   height: 1,
              //     //   color: Colors.teal,
              //     // ),
              //     // ListTile(
              //     //   onTap: () {
              //     //     imageUploader.openCamera(context, "Lab Pictures");
              //     //   },
              //     //   title: Text("Camera"),
              //     //   leading: Icon(
              //     //     Icons.camera,
              //     //     color: Colors.teal,
              //     //   ),
              //     // ),
              //   ],
              // ),
            ),
          );
        });
  }

  // assets...............
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    print("Image List Length:" + imageFileList!.length.toString());
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.teal,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) =>Home()));
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.white,
            )),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/stemrobo.png',
              fit: BoxFit.contain,
              height: 32,
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.tealAccent, Colors.teal]),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Text(
              "Lab Pictures",
              textAlign: TextAlign.center,
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 20,
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(width: 3.0, color: Colors.black26),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  gradient: LinearGradient(
                      colors: [
                        Colors.tealAccent,
                        Colors.teal
                      ]
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey ,
                        blurRadius: 2.0,
                        offset: Offset(2.0,2.0)
                    )
                  ]

              ),
              child: GestureDetector(
                onTap: () {
                  // _showChoiceDialog(context);
                  selectImages();
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      size: 70,
                      color: Colors.black54,
                    ),
                    Text(
                      "File Upload",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: GridView.builder(
                    itemCount: imageFileList!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      return Image.file(
                        File(imageFileList![index].path),
                        fit: BoxFit.cover,
                      );
                    }),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                new Container(
                    padding: const EdgeInsets.only(top: 30),
                    child: RaisedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Home()));
                        },
                        icon: Icon(Icons.cancel),
                        label: Text(
                          "CANCEL",
                          style: TextStyle(color: Colors.red),
                        ))),
                Spacer(),
                new Container(
                    padding: const EdgeInsets.only(top: 30),
                    child: RaisedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>Home()));
                        },
                        icon: Icon(Icons.save),
                        label: Text(
                          "SAVE",
                          style: TextStyle(color: Colors.teal),
                        ))),
              ],
            )
          ],
        ),
      ),
    );
  }

  void loadImages(){
    var uid = AuthService().getUser()!.uid;//Show only items who have the same uid
    DatabaseReference reference = FirebaseDatabase.instance.ref('Users/$uid/Images/');
    reference.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        //Show only who's category Lab Picture
        final data = event.snapshot.value;
        print(data);
      } else {
        print('No data available.');
      }
    });
  }
}