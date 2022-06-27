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

final canCreateView = ValueNotifier<int>(0);
List<File> selectedFiles = [];

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
    canCreateView.value = 0;
    selectedFiles.clear();
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

  void pickFiles() async {
    FilePickerResult? _filePickerResult = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'pdf', 'pdf', 'doc', 'docx'],
        allowMultiple: true);
    if (_filePickerResult == null) {
      canCreateView.value = 0;
      return;
    }
    selectedFiles.clear();
    selectedFiles = _filePickerResult.paths.map((path) => File(path!)).toList();
    canCreateView.value = 1;
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
                        Text(
                          "Lab Picture",
                          style: TextStyle(
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
                  Text(
                    'Attach Files (Optional)',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'File should be jpg, jpeg, png, pdf, doc OR docx',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: pickFiles,
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
                    valueListenable: canCreateView,
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
                                children: List.generate(selectedFiles.length,
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
                                                    color: Colors.grey.shade200,
                                                    offset: const Offset(0, 1),
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
                                                          selectedFiles[index]
                                                              .path
                                                              .split('/')
                                                              .last,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .black)),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        selectedFiles[index]
                                                            .path,
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors
                                                                .grey.shade500),
                                                      ),
                                                      const SizedBox(height: 5),
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
                                    OpenFile.open(selectedFiles[index].path),
                                    }
                                  );
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

  // void pickFiless() async {
  //   result = await FilePicker.platform.pickFiles(allowMultiple: true);
  //   if (result == null) return;
  //   // uploadImages(result!);
  //   // loadSelectedFile(result!.files);
  // }

  uploadImages() async {
    Iterable<File> imagesListFiles = selectedFiles.where((item) {
      return item.path.endsWith(".jpg") ||
          item.path.endsWith(".jpeg") ||
          item.path.endsWith(".png");
    });
    Iterable<File> documents = selectedFiles.where((item) {
      return item.path.endsWith(".pdf") ||
          item.path.endsWith(".doc") ||
          item.path.endsWith(".docx");
    });

    List<File> labImagesFiles = [];
    for (var imageAsset in images) {
      final filePath =
          await FlutterAbsolutePath.getAbsolutePath(imageAsset.identifier);
      File tempFile = File(filePath);
      labImagesFiles.add(tempFile);
    }
    Iterable<File> imagesExtraList = labImagesFiles.where((item) {
      return item.path.endsWith(".jpg") ||
          item.path.endsWith(".jpeg") ||
          item.path.endsWith(".png");
    });

    Iterable<File> imagesList = List.from(imagesListFiles)
      ..addAll(imagesExtraList);

    List<String> imageUrls = [];
    List<String> documentUrls = [];
    if (imagesList.isNotEmpty) {
      imageUrls = await uploadFiles(imagesList);
    }
    if (documents.isNotEmpty) {
      documentUrls = await uploadFiles(documents);
    }
    writeNewVisit(imageUrls, documentUrls);
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

  void writeNewVisit(List<String> images, List<String> documents) async {
    var uid = AuthService().getUID();
    Map imagesMap = images.asMap();
    Map documentsMap = documents.asMap();
    visitedSchool = schoolController.text;
    selection = options[typeIndex];
    note = noteController.text;
    final visitData = {
      'date': dateController.text,
      'name': nameController.text,
      'email': emailController.text,
      'school': schoolController.text,
      'images': imagesMap,
      'documents': documentsMap,
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
    if (imagesMap.isNotEmpty && documentsMap.isNotEmpty) {
      await sendMailAll(imagesMap, documentsMap);
    } else if (imagesMap.isNotEmpty) {
      await sendMailOne(imagesMap);
    } else if (documentsMap.isNotEmpty) {
      await sendMailOne(documentsMap);
    } else {
      await sendMail();
    }
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

  Future<String> getFileSize(File file) async {
    int bytes = await file.length();
    int decimals = 1;
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

  loadAsset() async {
    List<Asset> resultImages = <Asset>[];
    String error = "something went wrong";
    try {
      resultImages = await MultiImagePicker.pickImages(
          maxImages: 300,
          enableCamera: true,
          selectedAssets: images,
          materialOptions: MaterialOptions(
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
      error = e.toString();
      print(error);
    }
  }

  Widget buildGridView() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(10),
        dashPattern: const [10, 4],
        strokeCap: StrokeCap.round,
        color: Colors.blue.shade400,
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: images.length == 0
                ? Center(
                    child: IconButton(
                        onPressed: () {
                          loadAsset();
                        },
                        icon: Icon(
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

  sendMail() async {
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
          "<h3>Form Details</h3><p>School Name: $visitedSchool<br>Visit Purpose: $selection<br>Note: $note<p><h3>Engineer Details</h3><p>Engineer Name: $engineerName<br>Engineer Email: $engineerEmail<br><br>No Attachments</h3>";
    await send(equivalentMessage, smtpServer);
  }

  sendMailOne(Map map) async {
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
          "<h3>Form Details</h3><p>School Name: $visitedSchool<br>Visit Purpose: $selection<br>Note: $note<p><h3>Engineer Details</h3><p>Engineer Name: $engineerName<br>Engineer Email: $engineerEmail<br><br>Attachments:<br>$map</p>";
    await send(equivalentMessage, smtpServer);
  }

  sendMailAll(Map map1, Map map2) async {
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
          "<h3>Form Details</h3><p>School Name: $visitedSchool<br>Visit Purpose: $selection<br>Note: $note<p><h3>Engineer Details</h3><p>Engineer Name: $engineerName<br>Engineer Email: $engineerEmail<br><br>Attachments:<br>$map1<br>$map2</p>";
    await send(equivalentMessage, smtpServer);
  }
}
