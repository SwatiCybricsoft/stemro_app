import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stemro_app/form/submitpage.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import '../auth/AuthService.dart';
import 'package:intl/intl.dart';
import '../auth/home_page.dart';
import 'package:open_file/open_file.dart';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import '../widgets/file_upload.dart';

final canCreateViewComponent = ValueNotifier<int>(0);
final canCreateViewTeacher = ValueNotifier<int>(0);
List<File> componentFiles = [];
List<File> teacherFiles = [];

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);
  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.teal,
    ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.teal.shade300,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.white,
            )),
        title: Container(
            padding: const EdgeInsets.all(8.0),
            child: const Text('School Visit Form')),
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
  get engineerName => name;
  get engineerEmail => email;

  var visitedSchool = "";
  var selection = "";
  var note = "";

  @override
  void dispose() {
    emailController.dispose();
    canCreateViewComponent.value = 0;
    canCreateViewTeacher.value = 0;
    componentFiles.clear();
    teacherFiles.clear();
  }

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

  void pickComponentFiles() async {
    FilePickerResult? _filePickerResult = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'pdf', 'pdf', 'doc', 'docx'],
        allowMultiple: true);
    if (_filePickerResult == null) {
      canCreateViewComponent.value = 0;
      return;
    }
    componentFiles.clear();
    componentFiles =
        _filePickerResult.paths.map((path) => File(path!)).toList();
    canCreateViewComponent.value = 1;
    // selectedImages = selectedFiles
    //     .where((file) =>
    //         file.path.split('/').last.contains(".jpeg") ||
    //         file.path.split('/').last.contains(".jpg") ||
    //         file.path.split('/').last.contains(".png"))
    //     .toList();
    // selectedDocuments = selectedFiles
    //     .where((file) =>
    //         file.path.split('/').last.contains(".pdf") ||
    //         file.path.split('/').last.contains(".doc") ||
    //         file.path.split('/').last.contains(".docx"))
    //     .toList();
    // uploadImages(result!);
    // loadSelectedFile(result!.files);
  }

  void pickTeacherFiles() async {
    FilePickerResult? _filePickerResult = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'pdf', 'pdf', 'doc', 'docx'],
        allowMultiple: true);
    if (_filePickerResult == null) {
      canCreateViewTeacher.value = 0;
      return;
    }
    teacherFiles.clear();
    teacherFiles = _filePickerResult.paths.map((path) => File(path!)).toList();
    canCreateViewTeacher.value = 1;
    // selectedImages = selectedFiles
    //     .where((file) =>
    //         file.path.split('/').last.contains(".jpeg") ||
    //         file.path.split('/').last.contains(".jpg") ||
    //         file.path.split('/').last.contains(".png"))
    //     .toList();
    // selectedDocuments = selectedFiles
    //     .where((file) =>
    //         file.path.split('/').last.contains(".pdf") ||
    //         file.path.split('/').last.contains(".doc") ||
    //         file.path.split('/').last.contains(".docx"))
    //     .toList();
    // uploadImages(result!);
    // loadSelectedFile(result!.files);
  }

  ImagePicker image = ImagePicker();

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

  late final ValueChanged<PlatformFile> onOpenedFile;
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
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

  List<Asset> images = <Asset>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => setDetails());
  }

  setDetails() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    dateController.text = formattedDate;
    nameController.text = name;
    emailController.text = email;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.teal,
    ));

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
                    decoration: const InputDecoration(
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
                    autofillHints: [name],
                    keyboardType: TextInputType.text,
                    controller: nameController,
                    onSaved: (val) => _name = val!,
                    // validator: (val) => val!.length < 1  ? "Enter Name" : null ,
                    decoration: const InputDecoration(
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
                    autofillHints: [email],
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,

                    // validator: (val) => !val!.contains("@") ? "Email Id is not Valid" : null ,
                    // onSaved: (val) => _email = val!,
                    decoration: const InputDecoration(
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
                    decoration: const InputDecoration(
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
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: const InputDecoration(filled: false
                        // prefixIcon: Icon(Icons.person),
                        ),
                    hint: const Text(
                      'Select Visit Purpose',
                      style: TextStyle(color: Colors.black, letterSpacing: 1.0),
                    ),
                    items: options.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
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
                    decoration: const InputDecoration(
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
                  const SizedBox(
                    height: 30,
                  ),

                  Container(
                    height: 250,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Lab Picture",
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        // ElevatedButton(onPressed: (){
                        //   loadAsset();
                        // }, child:Text('Pick Images'),
                        // ),
                        Expanded(child: buildGridView()),
                      ],
                    ),
                  ),

                  //Component Verification Docs
                  Text(
                    'Component Verification Docs',
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'File should be jpg, jpeg, png, pdf, doc OR docx',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: pickComponentFiles,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 20.0),
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          color: Colors.blue.shade400,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                                color: Colors.blue.shade50.withOpacity(.3),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Select your file',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade400),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),
                  ValueListenableBuilder(
                    valueListenable: canCreateViewComponent,
                    builder: (context, value, widget) {
                      if (value == 1) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Selected File',
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: List.generate(componentFiles.length,
                                    (index) {
                                  return GestureDetector(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 10),
                                          Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color:
                                                          Colors.grey.shade200,
                                                      offset:
                                                          const Offset(0, 1),
                                                      blurRadius: 3,
                                                      spreadRadius: 2,
                                                    )
                                                  ]),
                                              child: Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            componentFiles[
                                                                    index]
                                                                .path
                                                                .split('/')
                                                                .last,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Colors
                                                                        .black)),
                                                        const SizedBox(
                                                            height: 5),
                                                        Text(
                                                          componentFiles[index]
                                                              .path,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.grey
                                                                  .shade500),
                                                        ),
                                                        const SizedBox(
                                                            height: 5),
                                                        Container(
                                                            height: 5,
                                                            clipBehavior:
                                                                Clip.hardEdge,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              color: Colors
                                                                  .blue.shade50,
                                                            ),
                                                            child:
                                                                const LinearProgressIndicator(
                                                              value: 50,
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                ],
                                              )),
                                        ],
                                      ),
                                      onTap: () => {
                                            OpenFile.open(
                                                componentFiles[index].path),
                                          });
                                }),
                              )
                            ]);
                      } else {
                        return const Text(
                          "Nothing selected",
                          style: const TextStyle(color: Colors.grey),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  //Teacher's Training Report
                  Text(
                    "Teacher's Training Report",
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'File should be jpg, jpeg, png, pdf, doc OR docx',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: pickTeacherFiles,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 20.0),
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          color: Colors.blue.shade400,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                                color: Colors.blue.shade50.withOpacity(.3),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Select your file',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade400),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),
                  ValueListenableBuilder(
                    valueListenable: canCreateViewTeacher,
                    builder: (context, value, widget) {
                      if (value == 1) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Selected File',
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children:
                                    List.generate(teacherFiles.length, (index) {
                                  return GestureDetector(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 10),
                                          Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color:
                                                          Colors.grey.shade200,
                                                      offset:
                                                          const Offset(0, 1),
                                                      blurRadius: 3,
                                                      spreadRadius: 2,
                                                    )
                                                  ]),
                                              child: Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            teacherFiles[index]
                                                                .path
                                                                .split('/')
                                                                .last,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Colors
                                                                        .black)),
                                                        const SizedBox(
                                                            height: 5),
                                                        Text(
                                                          teacherFiles[index]
                                                              .path,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.grey
                                                                  .shade500),
                                                        ),
                                                        const SizedBox(
                                                            height: 5),
                                                        Container(
                                                            height: 5,
                                                            clipBehavior:
                                                                Clip.hardEdge,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              color: Colors
                                                                  .blue.shade50,
                                                            ),
                                                            child:
                                                                const LinearProgressIndicator(
                                                              value: 50,
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                ],
                                              )),
                                        ],
                                      ),
                                      onTap: () => {
                                            OpenFile.open(
                                                teacherFiles[index].path),
                                          });
                                }),
                              )
                            ]);
                      } else {
                        return const Text(
                          "Nothing selected",
                          style: const TextStyle(color: Colors.grey),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  // Flex(
                  //   direction: Axis.vertical,
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     const Text(
                  //       'Lab Picture',
                  //       textAlign: TextAlign.start,
                  //       style: TextStyle(
                  //         decoration: TextDecoration.underline,
                  //         fontSize: 16,
                  //         color: Colors.teal,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //     Container(
                  //       height: MediaQuery.of(context).size.height / 8,
                  //       width: MediaQuery.of(context).size.width / 4,
                  //       margin: const EdgeInsets.all(10.0),
                  //       padding: const EdgeInsets.all(8),
                  //       decoration: BoxDecoration(
                  //           border:
                  //               Border.all(width: 3.0, color: Colors.black26),
                  //           borderRadius: const BorderRadius.all(
                  //             const Radius.circular(10.0),
                  //           ),
                  //           gradient: const LinearGradient(
                  //               colors: [Colors.grey, Colors.blueGrey]),
                  //           boxShadow: const [
                  //             BoxShadow(
                  //                 color: Colors.grey,
                  //                 blurRadius: 2.0,
                  //                 offset: Offset(2.0, 2.0))
                  //           ]),
                  //       child: GestureDetector(
                  //         onTap: () {
                  //           pickFiless();
                  //         },
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: const [
                  //             Icon(
                  //               Icons.add_circle_outline,
                  //               size: 40,
                  //               color: Colors.black,
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //     const Text(
                  //       'Component Verification Docs',
                  //       textAlign: TextAlign.start,
                  //       style: TextStyle(
                  //         decoration: TextDecoration.underline,
                  //         fontSize: 16,
                  //         color: Colors.teal,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //     Container(
                  //       height: MediaQuery.of(context).size.height / 8,
                  //       width: MediaQuery.of(context).size.width / 4,
                  //       margin: const EdgeInsets.all(10.0),
                  //       padding: const EdgeInsets.all(8),
                  //       decoration: BoxDecoration(
                  //           border:
                  //               Border.all(width: 3.0, color: Colors.black26),
                  //           borderRadius: const BorderRadius.all(
                  //             const Radius.circular(10.0),
                  //           ),
                  //           gradient: const LinearGradient(
                  //               colors: [Colors.grey, Colors.blueGrey]),
                  //           boxShadow: const [
                  //             BoxShadow(
                  //                 color: Colors.grey,
                  //                 blurRadius: 2.0,
                  //                 offset: Offset(2.0, 2.0))
                  //           ]),
                  //       child: GestureDetector(
                  //         onTap: () async {
                  //           pickFiless();
                  //         },
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: const [
                  //             Icon(
                  //               Icons.add_circle_outline,
                  //               size: 40,
                  //               color: Colors.black,
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //     const Text(
                  //       "Teachers's Training Report",
                  //       textAlign: TextAlign.start,
                  //       style: const TextStyle(
                  //         decoration: TextDecoration.underline,
                  //         fontSize: 16,
                  //         color: Colors.teal,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //     Container(
                  //       height: MediaQuery.of(context).size.height / 8,
                  //       width: MediaQuery.of(context).size.width / 4,
                  //       margin: const EdgeInsets.all(10.0),
                  //       padding: const EdgeInsets.all(8),
                  //       decoration: BoxDecoration(
                  //         border: Border.all(width: 3.0, color: Colors.black26),
                  //         borderRadius: const BorderRadius.all(
                  //           const Radius.circular(10.0),
                  //         ),
                  //         gradient: const LinearGradient(
                  //             colors: [Colors.grey, Colors.blueGrey]),
                  //         boxShadow: const [
                  //           BoxShadow(
                  //               color: Colors.grey,
                  //               blurRadius: 2.0,
                  //               offset: Offset(2.0, 2.0))
                  //         ],
                  //       ),
                  //       child: GestureDetector(
                  //         onTap: () async {
                  //           pickFiless();
                  //         },
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: const [
                  //             Icon(
                  //               Icons.add_circle_outline,
                  //               size: 40,
                  //               color: Colors.black,
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
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
                              children: const [
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
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  color: Colors.grey,
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                const Spacer(),
                                MaterialButton(
                                  onPressed: () {
                                    uploadImages();
                                  },
                                  color: Colors.black,
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            )),
                  // ElevatedButton(onPressed: (){
                  //   pickFiless();
                  // }, child:Text('PickFile')),
                ],
              ),
            ),
          ),
        ));
  }

  uploadImages() async {
    List<File> labImagesFile = [];
    for (var imageAsset in images) {
      final filePath =
          await FlutterAbsolutePath.getAbsolutePath(imageAsset.identifier);
      File tempFile = File(filePath);
      labImagesFile.add(tempFile);
    }
    Iterable<File> imagesLab = labImagesFile.where((item) {
      return item.path.endsWith(".jpg") ||
          item.path.endsWith(".jpeg") ||
          item.path.endsWith(".png");
    });
    Iterable<File> imagesComponent = componentFiles.where((item) {
      return item.path.endsWith(".jpg") ||
          item.path.endsWith(".jpeg") ||
          item.path.endsWith(".png");
    });
    Iterable<File> imagesTeacher = teacherFiles.where((item) {
      return item.path.endsWith(".jpg") ||
          item.path.endsWith(".jpeg") ||
          item.path.endsWith(".png");
    });

    Iterable<File> documentsComponent = componentFiles.where((item) {
      return item.path.endsWith(".pdf") ||
          item.path.endsWith(".doc") ||
          item.path.endsWith(".docx");
    });
    Iterable<File> documentsTeacher = teacherFiles.where((item) {
      return item.path.endsWith(".pdf") ||
          item.path.endsWith(".doc") ||
          item.path.endsWith(".docx");
    });

    List<String> imageLabUrls = [];
    List<String> imageComponentUrls = [];
    List<String> imageTeacherUrls = [];
    List<String> documentComponentUrls = [];
    List<String> documentTeacherUrls = [];

    if (imagesLab.isNotEmpty) {
      imageLabUrls = await uploadFiles(imagesLab);
    }
    if (imagesComponent.isNotEmpty) {
      imageComponentUrls = await uploadFiles(imagesComponent);
    }
    if (imagesTeacher.isNotEmpty) {
      imageTeacherUrls = await uploadFiles(imagesTeacher);
    }
    if (documentsComponent.isNotEmpty) {
      documentComponentUrls = await uploadFiles(documentsComponent);
    }
    if (documentsTeacher.isNotEmpty) {
      documentTeacherUrls = await uploadFiles(documentsTeacher);
    }
    writeNewVisit(imageLabUrls, imageComponentUrls, imageTeacherUrls,
        documentComponentUrls, documentTeacherUrls);
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

  void writeNewVisit(
      List<String> imageLabUrls,
      List<String> imageComponentUrls,
      List<String> imageTeacherUrls,
      List<String> documentComponentUrls,
      List<String> documentTeacherUrls) async {
    var uid = AuthService().getUID();
    Map labImages = imageLabUrls.asMap();
    Map componentImages = imageComponentUrls.asMap();
    Map teacherImages = imageTeacherUrls.asMap();
    Map componentDocument = documentComponentUrls.asMap();
    Map teacherDocument = documentTeacherUrls.asMap();
    final imagesData = {
      'Lab': labImages,
      'Component': componentImages,
      'Teacher': teacherImages
    };
    final documentsData = {
      'Component': componentDocument,
      'Teacher': teacherDocument
    };
    visitedSchool = schoolController.text;
    selection = options[typeIndex];
    note = noteController.text;
    final visitData = {
      'date': dateController.text,
      'name': nameController.text,
      'email': emailController.text,
      'school': schoolController.text,
      'images': imagesData,
      'documents': documentsData,
      'type': options[typeIndex],
      'note': noteController.text,
      'uid': uid,
    };
    final newVisitKey = FirebaseDatabase.instance.ref().push().key;
    final Map<String, Map> updates = {};
    var userReference = '/Users/$uid/School Visits/$newVisitKey';
    var adminReference = '/School Visits/$newVisitKey';
    updates[userReference] = visitData;
    updates[adminReference] = visitData;
    FirebaseDatabase.instance.ref().update(updates);
    showAlertDialog(context);
    String attachments = "No attachments.";
    if (imagesData.isNotEmpty || documentsData.isNotEmpty) {
      attachments = "Attachments:<br>" +
          imagesData.toString() +
          "<br>" +
          documentsData.toString();
    }
    await sendMail(attachments);
    Navigator.pop(context);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const SubmitPage(title: 'SubmitPage')),
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

  loadAsset() async {
    List<Asset> resultImages = <Asset>[];
    try {
      resultImages = await MultiImagePicker.pickImages(
          maxImages: 300,
          enableCamera: true,
          selectedAssets: images,
          materialOptions: const MaterialOptions(
            actionBarColor: "#00a693",
            statusBarColor: "#00a693",
            actionBarTitle: "Stemrobo Help Desk",
            allViewTitle: "All Photos",
            useDetailsView: false,
            selectCircleStrokeColor: "#008080",
          ));
      setState(() {
        images = resultImages;
      });
    } catch (e) {
      String error = e.toString();
      print(error);
    }
  }

  Widget buildGridView() {
    return Padding(
      padding: const EdgeInsets.all(35.0),
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(10),
        dashPattern: const [10, 4],
        strokeCap: StrokeCap.round,
        color: Colors.blue.shade400,
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.blue.shade50.withOpacity(.3),
                borderRadius: BorderRadius.circular(10)),
            child: images.length == 0
                ? Center(
                    child: IconButton(
                        onPressed: () {
                          loadAsset();
                        },
                        icon: const Icon(
                          Icons.add,
                          size: 40,
                        )),
                  )
                : GridView.count(
                    crossAxisCount: 4,
                    children: List.generate(images.length, (index) {
                      Asset asset = images[index];
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Card(
                            child: AssetThumb(
                                asset: asset, width: 180, height: 180)),
                      );
                    }))),
      ),
    );
  }

  sendMail(String attachment) async {
    String username = 'jugendrabhati658@gmail.com';
    String password = 'adftgrbtahkktzct';

    final smtpServer = gmail(username, password);
    final equivalentMessage = Message()
      ..from = Address(username, '$engineerName')
      ..recipients.add(Address('jugendra.bhati@cybricsoft.com'))
      // ..recipients.add(Address('helpdesk@stemrobo.com'))
      // ..ccRecipients.addAll(['dharmendra@stemrobo.com','atul.mishra@stemrobo.com'])
      // ..bccRecipients.add('jugendra.bhati@cybricsoft.com')
      ..subject = 'School form filled on ${DateTime.now()}'
      ..text = ''
      ..html =
          "<h3>Form Details</h3><p>School Name: $visitedSchool<br>Visit Purpose: $selection<br>Note: $note<p><h3>Engineer Details</h3><p>Engineer Name: $engineerName<br>Engineer Email: $engineerEmail<br><br>" +
              attachment +
              "</h3>";
    await send(equivalentMessage, smtpServer);
  }
}
