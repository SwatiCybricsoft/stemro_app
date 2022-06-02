import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FilePickerDemo extends StatefulWidget {
  @override
  _FilePickerDemoState createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  String? _fileName;
  String? _saveAsFileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _isLoading = false;
  bool _userAborted = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void _pickFiles() async {
    _resetState();
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _fileName =
      _paths != null ? _paths!.map((e) => e.name).toString() : '...';
      _userAborted = _paths == null;
    });
  }

  void _clearCachedFiles() async {
    _resetState();
    try {
      bool? result = await FilePicker.platform.clearTemporaryFiles();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: result! ? Colors.green : Colors.red,
          content: Text((result
              ? 'Temporary files removed with success.'
              : 'Failed to clean temporary files')),
        ),
      );
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _selectFolder() async {
    _resetState();
    try {
      String? path = await FilePicker.platform.getDirectoryPath();
      setState(() {
        _directoryPath = path;
        _userAborted = path == null;
      });
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveFile() async {
    _resetState();
    try {
      String? fileName = await FilePicker.platform.saveFile(
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
        type: _pickingType,
      );
      setState(() {
        _saveAsFileName = fileName;
        _userAborted = fileName == null;
      });
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _logException(String message) {
    print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _directoryPath = null;
      _fileName = null;
      _paths = null;
      _saveAsFileName = null;
      _userAborted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _scaffoldMessengerKey,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('File Picker example app'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: DropdownButton<FileType>(
                        hint: const Text('LOAD PATH FROM'),
                        value: _pickingType,
                        items: FileType.values
                            .map((fileType) => DropdownMenuItem<FileType>(
                          child: Text(fileType.toString()),
                          value: fileType,
                        ))
                            .toList(),
                        onChanged: (value) => setState(() {
                          _pickingType = value!;
                          if (_pickingType != FileType.custom) {
                            _controller.text = _extension = '';
                          }
                        })),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(width: 100.0),
                    child: _pickingType == FileType.custom
                        ? TextFormField(
                      maxLength: 15,
                      autovalidateMode: AutovalidateMode.always,
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: 'File extension',
                      ),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                    )
                        : const SizedBox(),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(width: 200.0),
                    child: SwitchListTile.adaptive(
                      title: Text(
                        'Pick multiple files',
                        textAlign: TextAlign.right,
                      ),
                      onChanged: (bool value) =>
                          setState(() => _multiPick = value),
                      value: _multiPick,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                    child: Column(
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () => _pickFiles(),
                          child: Text(_multiPick ? 'Pick files' : 'Pick file'),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => _selectFolder(),
                          child: const Text('Pick folder'),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => _saveFile(),
                          child: const Text('Save file'),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => _clearCachedFiles(),
                          child: const Text('Clear temporary files'),
                        ),
                      ],
                    ),
                  ),
                  Builder(
                    builder: (BuildContext context) => _isLoading
                        ? Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: const CircularProgressIndicator(),
                    )
                        : _userAborted
                        ? Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: const Text(
                        'User has aborted the dialog',
                      ),
                    )
                        : _directoryPath != null
                        ? ListTile(
                      title: const Text('Directory path'),
                      subtitle: Text(_directoryPath!),
                    )
                        : _paths != null
                        ? Container(
                      padding:
                      const EdgeInsets.only(bottom: 30.0),
                      height:
                      MediaQuery.of(context).size.height *
                          0.50,
                      child: Scrollbar(
                          child: ListView.separated(
                            itemCount: _paths != null &&
                                _paths!.isNotEmpty
                                ? _paths!.length
                                : 1,
                            itemBuilder: (BuildContext context,
                                int index) {
                              final bool isMultiPath =
                                  _paths != null &&
                                      _paths!.isNotEmpty;
                              final String name =
                                  'File $index: ' +
                                      (isMultiPath
                                          ? _paths!
                                          .map((e) => e.name)
                                          .toList()[index]
                                          : _fileName ?? '...');
                              final path = kIsWeb
                                  ? null
                                  : _paths!
                                  .map((e) => e.path)
                                  .toList()[index]
                                  .toString();

                              return ListTile(
                                title: Text(
                                  name,
                                ),
                                subtitle: Text(path ?? ''),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context,
                                int index) =>
                            const Divider(),
                          )),
                    )
                        : _saveAsFileName != null
                        ? ListTile(
                      title: const Text('Save file'),
                      subtitle: Text(_saveAsFileName!),
                    )
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
//...............///

// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
//
// void main() {
//   runApp(const MaterialApp(
//     home: HomePage(),
//     debugShowCheckedModeBanner: false,
//   ));
// }
//
// class HomePage extends StatefulWidget {
//   const HomePage({ Key? key }) : super(key: key);
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
//   String _image = 'https://ouch-cdn2.icons8.com/84zU-uvFboh65geJMR5XIHCaNkx-BZ2TahEpE9TpVJM/rs:fit:784:784/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9wbmcvODU5/L2E1MDk1MmUyLTg1/ZTMtNGU3OC1hYzlh/LWU2NDVmMWRiMjY0/OS5wbmc.png';
//   late AnimationController loadingController;
//
//   File? _file;
//   PlatformFile? _platformFile;
//
//   selectFile() async {
//     final file = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['png', 'jpg', 'jpeg']
//     );
//
//     if (file != null) {
//       setState(() {
//         _file = File(file.files.single.path!);
//         _platformFile = file.files.first;
//       });
//     }
//
//     loadingController.forward();
//   }
//
//   @override
//   void initState() {
//     loadingController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 10),
//     )..addListener(() { setState(() {}); });
//
//     super.initState();
//   }
//
//   //////////////////////////////////
//   /// @theflutterlover on Instagram
//   ///
//   /// https://afgprogrammer.com
//   //////////////////////////////////
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             SizedBox(height: 100,),
//             Image.network(_image, width: 300,),
//             SizedBox(height: 50,),
//             Text('Upload your file', style: TextStyle(fontSize: 25, color: Colors.grey.shade800, fontWeight: FontWeight.bold),),
//             SizedBox(height: 10,),
//             Text('File should be jpg, png', style: TextStyle(fontSize: 15, color: Colors.grey.shade500),),
//             SizedBox(height: 20,),
//             GestureDetector(
//               onTap: selectFile,
//               child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
//                   child: DottedBorder(
//                     borderType: BorderType.RRect,
//                     radius: Radius.circular(10),
//                     dashPattern: [10, 4],
//                     strokeCap: StrokeCap.round,
//                     color: Colors.blue.shade400,
//                     child: Container(
//                       width: double.infinity,
//                       height: 150,
//                       decoration: BoxDecoration(
//                           color: Colors.blue.shade50.withOpacity(.3),
//                           borderRadius: BorderRadius.circular(10)
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Iconsax.folder_open, color: Colors.blue, size: 40,),
//                           SizedBox(height: 15,),
//                           Text('Select your file', style: TextStyle(fontSize: 15, color: Colors.grey.shade400),),
//                         ],
//                       ),
//                     ),
//                   )
//               ),
//             ),
//             _platformFile != null
//                 ? Container(
//                 padding: EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Selected File',
//                       style: TextStyle(color: Colors.grey.shade400, fontSize: 15, ),),
//                     SizedBox(height: 10,),
//                     Container(
//                         padding: EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: Colors.white,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.shade200,
//                                 offset: Offset(0, 1),
//                                 blurRadius: 3,
//                                 spreadRadius: 2,
//                               )
//                             ]
//                         ),
//                         child: Row(
//                           children: [
//                             ClipRRect(
//                                 borderRadius: BorderRadius.circular(8),
//                                 child: Image.file(_file!, width: 70,)
//                             ),
//                             SizedBox(width: 10,),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(_platformFile!.name,
//                                     style: TextStyle(fontSize: 13, color: Colors.black),),
//                                   SizedBox(height: 5,),
//                                   Text('${(_platformFile!.size / 1024).ceil()} KB',
//                                     style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
//                                   ),
//                                   SizedBox(height: 5,),
//                                   Container(
//                                       height: 5,
//                                       clipBehavior: Clip.hardEdge,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(5),
//                                         color: Colors.blue.shade50,
//                                       ),
//                                       child: LinearProgressIndicator(
//                                         value: loadingController.value,
//                                       )
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(width: 10,),
//                           ],
//                         )
//                     ),
//                     SizedBox(height: 20,),
//                     // MaterialButton(
//                     //   minWidth: double.infinity,
//                     //   height: 45,
//                     //   onPressed: () {},
//                     //   color: Colors.black,
//                     //   child: Text('Upload', style: TextStyle(color: Colors.white),),
//                     // )
//                   ],
//                 ))
//                 : Container(),
//             SizedBox(height: 150,),
//           ],
//         ),
//       ),
//     );
//   }
// }