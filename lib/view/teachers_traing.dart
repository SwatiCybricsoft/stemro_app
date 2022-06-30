import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stemro_app/view/ImageUploader.dart';
import '../auth/AuthService.dart';
import '../auth/home_page.dart';

class TeachersTraining extends StatefulWidget {
  const TeachersTraining({Key? key}) : super(key: key);

  @override
  State<TeachersTraining> createState() => _TeachersTrainingState();
}
class _TeachersTrainingState extends State<TeachersTraining> {
  var imageUploader = ImageUploader();

  Future<void>_showChoiceDialog(BuildContext context)
  {
    return showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
        title: const Text("File Upload",style: TextStyle(color: Colors.teal),),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              const Divider(height: 1,color: Colors.teal,),
              ListTile(
                onTap: (){
                  imageUploader.openGallery(context, "Teachers Training");
                },
                title: const Text("Gallery"),
                leading: const Icon(Icons.account_box,color: Colors.teal,),
              ),

              const Divider(height: 1,color: Colors.teal,),
              ListTile(
                onTap: (){
                  imageUploader.openCamera(context, "Teachers Training");
                },
                title: const Text("Camera"),
                leading: const Icon(Icons.camera,color: Colors.teal,),
              ),
            ],
          ),
        ),);
    });
  }
   final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];
  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    print("Image List Length:${imageFileList!.length}");
    setState(() {

    });

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        centerTitle: true,
        leading: IconButton(onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
        },
            icon:const Icon(Icons.arrow_back_ios,size: 20,color: Colors.white,)),
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
        ), systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Text("Teacher's Training",textAlign: TextAlign.center,style: TextStyle(
              decoration: TextDecoration.underline,fontSize: 20,
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 3.0,
                      color: Colors.black26
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  gradient: const LinearGradient(
                      colors: [
                        Colors.tealAccent,
                        Colors.teal
                      ]
                  ),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.grey ,
                        blurRadius: 2.0,
                        offset: Offset(2.0,2.0)
                    )
                  ]

              ),
              child: GestureDetector(
                onTap: (){
                   _showChoiceDialog(context);
                     // selectImages();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_circle_outline,size: 70,color: Colors.white,),
                    Text("File Upload",style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: GridView.builder(
                    itemCount: imageFileList!.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      return Image.file(File(imageFileList![index].path), fit: BoxFit.cover,);
                    }
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                    padding: const EdgeInsets.only(top: 30),
                    child: RaisedButton.icon(onPressed:(){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>MyHomePage()));
                    },
                        icon: const Icon(Icons.cancel), label:const Text("CANCEL",style: TextStyle(color: Colors.red),))
                ),
                const Spacer(),
                Container(
                    padding: const EdgeInsets.only(top: 30),
                    child: RaisedButton.icon(onPressed:(){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>MyHomePage()));
                    },
                        icon: const Icon(Icons.save), label:const Text("SAVE",style: TextStyle(color: Colors.teal),))
                ),
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
        //Show only who's category Component Verification
        final data = event.snapshot.value;
        print(data);
      } else {
        print('No data available.');
      }
    });
  }
}

