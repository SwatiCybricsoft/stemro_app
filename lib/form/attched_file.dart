// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:stemro_app/auth/login_screen.dart';
// class AttachedFile extends StatefulWidget {
//   const AttachedFile({Key? key}) : super(key: key);
//
//   @override
//   State<AttachedFile> createState() => _AttachedFileState();
// }
//
// class _AttachedFileState extends State<AttachedFile> {
//   final ImagePicker imagePicker = ImagePicker();
//   List<XFile>? imageFileList = [];
//
//   void selectImages() async {
//     final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
//     if (selectedImages!.isNotEmpty) {
//       imageFileList!.addAll(selectedImages);
//     }
//     print("Image List Length:" + imageFileList!.length.toString());
//     setState((){});
//   }
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         brightness: Brightness.light,
//         backgroundColor: Colors.teal,
//         centerTitle: true,
//         leading: IconButton(onPressed: (){
//           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage ()));
//         },
//             icon:Icon(Icons.arrow_back_ios,size: 20,color: Colors.white,)),
//         title: Text('User Dashboard',maxLines: 1,style: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.bold
//         ),),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             height: MediaQuery.of(context).size.height,
//             child: Padding(
//               padding: const EdgeInsets.all(18.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 5,bottom: 0,left: 80),
//                     child: Text('Attached File',textAlign: TextAlign.center,style: TextStyle(
//                         decoration: TextDecoration.underline,fontSize: 20,
//                         color: Colors.teal,
//                         fontWeight: FontWeight.bold
//                     ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Lab Picture',textAlign: TextAlign.center,style: TextStyle(
//                           decoration: TextDecoration.underline,fontSize: 15,
//                           color: Colors.teal,
//                           fontWeight: FontWeight.bold,
//                       ),
//                       ),
//                       Container(
//                         margin: const EdgeInsets.all(0.0),
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                             border: Border.all(
//                                 width: 3.0,
//                                 color: Colors.black26
//                             ),
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(10.0),
//                             )
//                         ),
//                         child: GestureDetector(
//                           onTap: (){
//                             selectImages();
//                           },
//                           child: Column(
//                             children: [
//                               Icon(Icons.add_circle_outline,size: 40,color: Colors.black54,),
//                               Text("Upload File",maxLines:2,style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 12,
//                               ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                    SizedBox(
//                     height: 20,
//                   ),
//                    Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Components Verification Docs",textAlign: TextAlign.center,style: TextStyle(
//                         decoration: TextDecoration.underline,fontSize: 15,
//                         color: Colors.teal,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       ),
//                       Container(
//                         margin: const EdgeInsets.all(0.0),
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                             border: Border.all(
//                                 width: 3.0,
//                                 color: Colors.black26
//                             ),
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(10.0),
//                             )
//                         ),
//                         child: GestureDetector(
//                           onTap: (){
//                             selectImages();
//                           },
//                           child: Column(
//                             children: [
//                               Icon(Icons.add_circle_outline,size: 40,color: Colors.black54,),
//                               Text("Upload File",maxLines:2,style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 12,
//                               ),
//                               ),
//
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                    SizedBox(
//               height: 20,
//             ),
//                   GestureDetector(
//                     onTap: (){
//                       selectImages();
//                     },
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("Teacher's Training Report",textAlign: TextAlign.center,style: TextStyle(
//                           decoration: TextDecoration.underline,fontSize: 15,
//                           color: Colors.teal,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         ),
//                         Container(
//                           margin: const EdgeInsets.all(0.0),
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                               border: Border.all(
//                                   width: 3.0,
//                                   color: Colors.black26
//                               ),
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(10.0),
//                               )
//                           ),
//                           child: Column(
//                             children: [
//                               Icon(Icons.add_circle_outline,size: 40,color: Colors.black54,),
//                               Text("Uplaod File",maxLines:2,style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 12,
//                               ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Row(
//                     children: [
//                       new Container(
//                           padding: const EdgeInsets.only(top: 30),
//                           child: RaisedButton.icon(onPressed:(){
//                             Navigator.of(context).push(MaterialPageRoute(builder: (context) =>AttachedFile()));
//                           },
//                               icon: Icon(Icons.cancel), label:Text("Cancel",style: TextStyle(color: Colors.red),))
//                       ),
//                       Spacer(),
//                       new Container(
//                           padding: const EdgeInsets.only(top: 30),
//                           child: RaisedButton.icon(onPressed:(){
//                             Navigator.of(context).push(MaterialPageRoute(builder: (context) =>AttachedFile()));
//                           },
//                               icon: Icon(Icons.save), label:Text("SAVE",style: TextStyle(color: Colors.teal),))
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//
//         ),
//       ),
//     );
//   }
// }
