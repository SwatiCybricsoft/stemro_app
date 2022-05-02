import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class ImagePage extends StatefulWidget {
  const ImagePage({Key? key}) : super(key: key);
  @override
  State<ImagePage> createState() => _ImagePageState();
}
class _ImagePageState extends State<ImagePage> {
  File? imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image'),
      ),
      body: Padding(padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 640,
              height: 400,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(width: 8,color: Colors.blue),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const Text('Image should appear her'),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(child:ElevatedButton(
                  onPressed: ()=>getImage(source: ImageSource.camera),
                  child: const Text("Capture Image"),
                )),
                const SizedBox(
                  width: 20,
                ),
                Expanded(child: ElevatedButton(
                  onPressed: () =>getImage(source: ImageSource.gallery),
                  child: const Text("Select Image"),
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
  void getImage({required ImageSource source})async{
    final file = await ImagePicker().pickImage(source: source);
    if(file?.path != null){
      setState(() {
        imageFile = File(file!.path);
      });
    }

  }
}


