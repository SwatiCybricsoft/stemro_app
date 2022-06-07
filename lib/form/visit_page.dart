import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stemro_app/form/submitpage.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import '../auth/AuthService.dart';
import 'package:intl/intl.dart';
import '../auth/home_page.dart';
import 'package:open_file/open_file.dart';

import '../widgets/file_upload.dart';

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);
  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.teal,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MyHomePage()));
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.white,
            )),
        title: Container(
            padding: const EdgeInsets.all(8.0),
            child: Text('School Visit Form')),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.tealAccent, Colors.teal]),
          ),
        ),
      ),
      body: MyCustomForm(),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class. This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  List<PlatformFile> files = [];
  //image picker......//
  File? _image;
  final _picker = ImagePicker();
  // Implementing the image picker
  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  // //filepicker..........//
  // void _pickFile() async {
  //   final result = await FilePicker.platform.pickFiles(allowMultiple: false);
  //   // if no file is picked
  //   if (result == null) return;
  //   // first picked file (if multiple are selected)
  //   print(result.files.first.name);
  //   print(result.files.first.size);
  //   print(result.files.first.path);
  // }

  // file 3rd picker...
  FilePickerResult? result;
  PlatformFile? file;
  String fileType = 'All';
  var fileTypeList = ['All', 'Image', 'Video', 'Audio', 'MultipleFile'];

  // form validation....................///

  late final ValueChanged<PlatformFile> onOpenedFile;
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  int dropDownValue = 0;
  bool isLoading = false;

  String? userEmail = FirebaseAuth.instance.currentUser?.email;

  final dateController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final schoolController = TextEditingController();
  final typeController = TextEditingController();
  final noteController = TextEditingController();

  late String _date, _name, _email, _school, _note;
  late int typeIndex;
  var options = <String>[
    'ComponentVerification',
    'TeachersTraining',
    'RegularVisit',
    'PreSalesDemo/Meeting',
    'Technical/DocumentationSupport'
  ];

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    readOnly: true,
                    keyboardType: TextInputType.datetime,
                    onSaved: (val) => _date = val!,
                    controller: dateController,
                    decoration: InputDecoration(
                      hintText: "Today Date",
                      labelText: 'Date',
                      hintStyle: TextStyle(color: Colors.black),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    onTap: () async {
                      await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2021),
                        lastDate: DateTime(2031),
                      ).then((selectedDate) {
                        if (selectedDate != null) {
                          dateController.text =
                              DateFormat('yyyy-MM-dd').format(selectedDate);
                        }
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter date.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: nameController,
                    onSaved: (val) => _name = val!,
                    // validator: (val) => val!.length < 1  ? "Enter Name" : null ,
                    decoration: InputDecoration(
                      hintText: "Enter Engineer Name",
                      labelText: "Engineer Name",
                      hintStyle: TextStyle(color: Colors.black),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Engineer\s name.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,

                    // validator: (val) => !val!.contains("@") ? "Email Id is not Valid" : null ,
                    // onSaved: (val) => _email = val!,
                    decoration: InputDecoration(
                      hintText: 'Enter Email',
                      fillColor: Colors.black,
                      labelText: ' Email',
                      hintStyle: TextStyle(color: Colors.black),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter  EmailId.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: schoolController,
                    onSaved: (val) => _school = val!,
                    decoration: InputDecoration(
                      hintText: 'Enter  School Name',
                      labelText: 'School Name',
                      hintStyle: TextStyle(color: Colors.black),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter  School Name.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: InputDecoration(filled: false
                        // prefixIcon: Icon(Icons.person),
                        ),
                    hint: Text(
                      'Select Visit Purpose',
                      style: TextStyle(color: Colors.black, letterSpacing: 1.0),
                    ),
                    items: options.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        typeIndex = options.indexOf(value!);
                        print(options[typeIndex]);
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Visit Of Purpose.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    onSaved: (val) => _note = val!,
                    controller: noteController,
                    decoration: InputDecoration(
                      hintText: 'Enter Note',
                      labelText: ' Note',
                      hintStyle: TextStyle(color: Colors.black),
                      labelStyle: TextStyle(color: Colors.black),
                      isDense: true,
                      // Added this
                      contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter  Note.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Flex(
                    direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lab Picture',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 8,
                        width: MediaQuery.of(context).size.width / 4,
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 3.0, color: Colors.black26),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            gradient: LinearGradient(
                                colors: [Colors.grey, Colors.blueGrey]),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 2.0,
                                  offset: Offset(2.0, 2.0))
                            ]),
                        child: GestureDetector(
                          onTap: () {
                            pickFiless();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                size: 40,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        'Component Verification Docs',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 8,
                        width: MediaQuery.of(context).size.width / 4,
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 3.0, color: Colors.black26),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            gradient: LinearGradient(
                                colors: [Colors.grey, Colors.blueGrey]),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 2.0,
                                  offset: Offset(2.0, 2.0))
                            ]),
                        child: GestureDetector(
                          onTap: () async {
                            pickFiless();
                          },

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                size: 40,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        "Teachers's Training Report",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Container(
                        height: MediaQuery.of(context).size.height / 8,
                        width: MediaQuery.of(context).size.width / 4,
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(width: 3.0, color: Colors.black26),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          gradient: LinearGradient(
                              colors: [Colors.grey, Colors.blueGrey]),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 2.0,
                                offset: Offset(2.0, 2.0))
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            pickFiless();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                size: 40,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                        }
                        setState(() {
                          isLoading = true;
                        });
                        Future.delayed(const Duration(seconds: 3), () {
                          setState(() {
                            isLoading = false;
                          });
                        });
                      },
                      child: isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Please Wait...',
                                  style: TextStyle(color: Colors.teal),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Center(
                                  heightFactor: 1,
                                  widthFactor: 1,
                                  child: SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.5,
                                    ),
                                  ),
                                )
                              ],
                            )
                          : Row(
                              children: [
                                RaisedButton(
                                    color: Colors.grey,
                                    child: Text(
                                      "CANCEL",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyHomePage()));
                                    }),
                                Spacer(),
                                RaisedButton(
                                    color: Colors.teal,
                                    child: Text(
                                      "SAVE",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      emailController.text = userEmail!;
                                      // writeNewVisit();
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyHomePage()));
                                    }),
                              ],
                            )),
                ],
              ),
            ),
          ),
        ));
  }

  void writeNewVisit() async {
    var uid = AuthService().getUID();
    final visitData = {
      'date': dateController.text,
      'name': nameController.text,
      'email': emailController.text,
      'school': schoolController.text,
      'type': options[typeIndex],
      'note': noteController.text,
      'uid': uid,
    };
    final newVisitKey = FirebaseDatabase.instance.ref().push().key;
    final Map<String, Map> updates = {};
    updates['/Users/$uid/School Visits/$newVisitKey'] = visitData;
    updates['/School Visits/$newVisitKey'] = visitData;
    FirebaseDatabase.instance.ref().update(updates);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => SubmitPage(
                  title: 'SubmitPage',
                )));
  }

  void openFiles(List<PlatformFile> files) {
    // show(files: files);
  }

  void pickFiless() async {
    result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return;
    loadSelectedFile(result!.files);
  }

  uploadImages(FilePickerResult filePickerResult) async {
    List<File> files = filePickerResult.paths.map((path) => File(path!)).toList();
    Iterable<File> images = files.where((item) {
      return item.path.endsWith(".jpg") ||
          item.path.endsWith(".jpeg") ||
          item.path.endsWith(".png");
    });
    Iterable<File> documents = files.where((item) {
      return item.path.endsWith(".pdf") || item.path.endsWith(".docx");
    });

    if (images.isNotEmpty) {
      print("Uploading images...");
      List<String> urls = await uploadFiles(images);
      print(urls);
    } else {
      print("Images not selected");
    }

    if (documents.isNotEmpty) {
      print("Uploading documents...");
      List<String> urls = await uploadFiles(documents);
      print(urls);
    } else {
      print("Document not selected");
    }
  }

  Future<List<String>> uploadFiles(Iterable<File> files) async {
    showAlertDialog(context);
    List<String> urls =
    await Future.wait(files.map((_files) => uploadFile(_files)));
    Navigator.pop(context);
    return urls;
  }

  Future<String> uploadFile(File file) async {
    var snapshot = await FirebaseStorage.instance
        .ref("Stemro_App/" + file.path)
        .putFile(file);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
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

  void loadSelectedFile(List<PlatformFile> files) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => FileList(
              files: files,
              onOpenedFile: viewFile,
            )));
  }

  void viewFile(PlatformFile file) {
    OpenFile.open(file.path);
  }

  Widget fileDetails(PlatformFile file) {
    final kb = file.size / 1024;
    final mb = kb / 1024;
    final size = (mb >= 1)
        ? '${mb.toStringAsFixed(2)} MB'
        : '${kb.toStringAsFixed(2)} KB';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('File Name: ${file.name}'),
          Text('File Size: $size'),
          // Text('File Extension: ${file.extension}'),
          // Text('File Path: ${file.path}'),
        ],
      ),
    );
  }

  // void pickFiles(String? filetype) async {
  //   switch (filetype) {
  //     case 'Image':
  //       result = await FilePicker.platform.pickFiles(type: FileType.image);
  //       if (result == null) return;
  //       file = result!.files.first;
  //       setState(() {});
  //       break;
  //     case 'Video':
  //       result = await FilePicker.platform.pickFiles(type: FileType.video);
  //       if (result == null) return;
  //       file = result!.files.first;
  //       setState(() {});
  //       break;
  //     case 'Audio':
  //       result = await FilePicker.platform.pickFiles(type: FileType.audio);
  //       if (result == null) return;
  //       file = result!.files.first;
  //       setState(() {});
  //       break;
  //     case 'All':
  //       result = await FilePicker.platform.pickFiles();
  //       if (result == null) return;
  //       file = result!.files.first;
  //       setState(() {});
  //       break;
  //     case 'MultipleFile':
  //       result = await FilePicker.platform.pickFiles(allowMultiple: true);
  //       if (result == null) return;
  //       loadSelectedFiles(result!.files);
  //       break;
  //   }
  // }
  //
  // void loadSelectedFiles(List<PlatformFile> files) {
  //   Navigator.of(context).push(MaterialPageRoute(
  //       builder: (context) => FileList(files: files, onOpenedFile: viewFile))
  //   );
  // }
}
