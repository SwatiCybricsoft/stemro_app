// import 'dart:io';
// import 'package:iconsax/iconsax.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:open_file/open_file.dart';
// import 'dart:async';
//
// import '../auth/home_page.dart';
// import '../widgets/file_upload.dart';
//
// get engineerName => name;
// get engineerEmail => email;
//
// class FilePickerDemo extends StatefulWidget {
//   @override
//   _FilePickerDemoState createState() => _FilePickerDemoState();
// }
//
// class _FilePickerDemoState extends State<FilePickerDemo> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
//   String? _fileName;
//   String? _saveAsFileName;
//   List<PlatformFile>? _paths;
//   String? _directoryPath;
//   String? _extension;
//   bool _isLoading = false;
//   bool _userAborted = false;
//   bool _multiPick = false;
//   FileType _pickingType = FileType.any;
//   TextEditingController _controller = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _controller.addListener(() => _extension = _controller.text);
//   }
//
//   void _pickFiles() async {
//     _resetState();
//     try {
//       _directoryPath = null;
//       _paths = (await FilePicker.platform.pickFiles(
//         type: _pickingType,
//         allowMultiple: _multiPick,
//         onFileLoading: (FilePickerStatus status) => print(status),
//         allowedExtensions: (_extension?.isNotEmpty ?? false)
//             ? _extension?.replaceAll(' ', '').split(',')
//             : null,
//       ))
//           ?.files;
//     } on PlatformException catch (e) {
//       _logException('Unsupported operation' + e.toString());
//     } catch (e) {
//       _logException(e.toString());
//     }
//     if (!mounted) return;
//     setState(() {
//       _isLoading = false;
//       _fileName =
//       _paths != null ? _paths!.map((e) => e.name).toString() : '...';
//       _userAborted = _paths == null;
//     });
//   }
//
//   void _clearCachedFiles() async {
//     _resetState();
//     try {
//       bool? result = await FilePicker.platform.clearTemporaryFiles();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           backgroundColor: result! ? Colors.green : Colors.red,
//           content: Text((result
//               ? 'Temporary files removed with success.'
//               : 'Failed to clean temporary files')),
//         ),
//       );
//     } on PlatformException catch (e) {
//       _logException('Unsupported operation' + e.toString());
//     } catch (e) {
//       _logException(e.toString());
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   void _selectFolder() async {
//     _resetState();
//     try {
//       String? path = await FilePicker.platform.getDirectoryPath();
//       setState(() {
//         _directoryPath = path;
//         _userAborted = path == null;
//       });
//     } on PlatformException catch (e) {
//       _logException('Unsupported operation' + e.toString());
//     } catch (e) {
//       _logException(e.toString());
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   Future<void> _saveFile() async {
//     _resetState();
//     try {
//       String? fileName = await FilePicker.platform.saveFile(
//         allowedExtensions: (_extension?.isNotEmpty ?? false)
//             ? _extension?.replaceAll(' ', '').split(',')
//             : null,
//         type: _pickingType,
//       );
//       setState(() {
//         _saveAsFileName = fileName;
//         _userAborted = fileName == null;
//       });
//     } on PlatformException catch (e) {
//       _logException('Unsupported operation' + e.toString());
//     } catch (e) {
//       _logException(e.toString());
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   void _logException(String message) {
//     print(message);
//     _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
//     _scaffoldMessengerKey.currentState?.showSnackBar(
//       SnackBar(
//         content: Text(message),
//       ),
//     );
//   }
//
//   void _resetState() {
//     if (!mounted) {
//       return;
//     }
//     setState(() {
//       _isLoading = true;
//       _directoryPath = null;
//       _fileName = null;
//       _paths = null;
//       _saveAsFileName = null;
//       _userAborted = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       scaffoldMessengerKey: _scaffoldMessengerKey,
//       home: Scaffold(
//         key: _scaffoldKey,
//         appBar: AppBar(
//           title: const Text('File Picker example app'),
//         ),
//         body: Center(
//           child: Padding(
//             padding: const EdgeInsets.only(left: 10.0, right: 10.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.only(top: 20.0),
//                     child: DropdownButton<FileType>(
//                         hint: const Text('LOAD PATH FROM'),
//                         value: _pickingType,
//                         items: FileType.values
//                             .map((fileType) => DropdownMenuItem<FileType>(
//                           child: Text(fileType.toString()),
//                           value: fileType,
//                         ))
//                             .toList(),
//                         onChanged: (value) => setState(() {
//                           _pickingType = value!;
//                           if (_pickingType != FileType.custom) {
//                             _controller.text = _extension = '';
//                           }
//                         })),
//                   ),
//                   ConstrainedBox(
//                     constraints: const BoxConstraints.tightFor(width: 100.0),
//                     child: _pickingType == FileType.custom
//                         ? TextFormField(
//                       maxLength: 15,
//                       autovalidateMode: AutovalidateMode.always,
//                       controller: _controller,
//                       decoration: InputDecoration(
//                         labelText: 'File extension',
//                       ),
//                       keyboardType: TextInputType.text,
//                       textCapitalization: TextCapitalization.none,
//                     )
//                         : const SizedBox(),
//                   ),
//                   ConstrainedBox(
//                     constraints: const BoxConstraints.tightFor(width: 200.0),
//                     child: SwitchListTile.adaptive(
//                       title: Text(
//                         'Pick multiple files',
//                         textAlign: TextAlign.right,
//                       ),
//                       onChanged: (bool value) =>
//                           setState(() => _multiPick = value),
//                       value: _multiPick,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
//                     child: Column(
//                       children: <Widget>[
//                         ElevatedButton(
//                           onPressed: () => _pickFiles(),
//                           child: Text(_multiPick ? 'Pick files' : 'Pick file'),
//                         ),
//                         SizedBox(height: 10),
//                         ElevatedButton(
//                           onPressed: () => _selectFolder(),
//                           child: const Text('Pick folder'),
//                         ),
//                         SizedBox(height: 10),
//                         ElevatedButton(
//                           onPressed: () => _saveFile(),
//                           child: const Text('Save file'),
//                         ),
//                         SizedBox(height: 10),
//                         ElevatedButton(
//                           onPressed: () => _clearCachedFiles(),
//                           child: const Text('Clear temporary files'),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Builder(
//                     builder: (BuildContext context) => _isLoading
//                         ? Padding(
//                       padding: const EdgeInsets.only(bottom: 10.0),
//                       child: const CircularProgressIndicator(),
//                     )
//                         : _userAborted
//                         ? Padding(
//                       padding: const EdgeInsets.only(bottom: 10.0),
//                       child: const Text(
//                         'User has aborted the dialog',
//                       ),
//                     )
//                         : _directoryPath != null
//                         ? ListTile(
//                       title: const Text('Directory path'),
//                       subtitle: Text(_directoryPath!),
//                     )
//                         : _paths != null
//                         ? Container(
//                       padding:
//                       const EdgeInsets.only(bottom: 30.0),
//                       height:
//                       MediaQuery.of(context).size.height *
//                           0.50,
//                       child: Scrollbar(
//                           child: ListView.separated(
//                             itemCount: _paths != null &&
//                                 _paths!.isNotEmpty
//                                 ? _paths!.length
//                                 : 1,
//                             itemBuilder: (BuildContext context,
//                                 int index) {
//                               final bool isMultiPath =
//                                   _paths != null &&
//                                       _paths!.isNotEmpty;
//                               final String name =
//                                   'File $index: ' +
//                                       (isMultiPath
//                                           ? _paths!
//                                           .map((e) => e.name)
//                                           .toList()[index]
//                                           : _fileName ?? '...');
//                               final path = kIsWeb
//                                   ? null
//                                   : _paths!
//                                   .map((e) => e.path)
//                                   .toList()[index]
//                                   .toString();
//
//                               return ListTile(
//                                 title: Text(
//                                   name,
//                                 ),
//                                 subtitle: Text(path ?? ''),
//                               );
//                             },
//                             separatorBuilder:
//                                 (BuildContext context,
//                                 int index) =>
//                             const Divider(),
//                           )),
//                     )
//                         : _saveAsFileName != null
//                         ? ListTile(
//                       title: const Text('Save file'),
//                       subtitle: Text(_saveAsFileName!),
//                     )
//                         : const SizedBox(),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// // class MyHomePag extends StatefulWidget {
// //   const MyHomePag({Key? key}) : super(key: key);
// //
// //   @override
// //   State<MyHomePag> createState() => _MyHomePagState();
// // }
// //
// // class _MyHomePagState extends State<MyHomePag> {
// //   String _fileText = "";
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("File Picker"),
// //       ),
// //       body: Center(
// //         child: Padding(
// //           padding: EdgeInsets.all(10),
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             crossAxisAlignment: CrossAxisAlignment.center,
// //             children: [
// //               // ElevatedButton(onPressed: _pickFile, child: Text("Pick File"),),
// //               // SizedBox(height: 10,),
// //               ElevatedButton(onPressed: _pickMultipleFiles, child: Text("Pick Multiple Files"),),
// //               SizedBox(height: 10,),
// //               // ElevatedButton(onPressed: _pickDirectory, child: Text("Pick Directory"),),
// //               // SizedBox(height: 10,),
// //               // ElevatedButton(onPressed: _saveAs, child: Text("Save As"),),
// //               // SizedBox(height: 10,),
// //               Text(_fileText),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   // void _pickFile() async {
// //   //   FilePickerResult? result = await FilePicker.platform.pickFiles(
// //   //     // allowedExtensions: ['jpg', 'pdf', 'doc'],
// //   //   );
// //   //
// //   //   if (result != null && result.files.single.path != null) {
// //   //     /// Load result and file details
// //   //     PlatformFile file = result.files.first;
// //   //     print(file.name);
// //   //     print(file.bytes);
// //   //     print(file.size);
// //   //     print(file.extension);
// //   //     print(file.path);
// //   //
// //   //     /// normal file
// //   //     File _file = File(result.files.single.path!);
// //   //     setState(() {
// //   //       _fileText = _file.path;
// //   //     });
// //   //   } else {
// //   //     /// User canceled the picker
// //   //   }
// //   // }
// //
// //   void _pickMultipleFiles() async {
// //     FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
// //
// //     if (result != null) {
// //       List<File> files = result.paths.map((path) => File(path!)).toList();
// //       setState(() {
// //         _fileText = files.toString();
// //       });
// //     } else {
// //       // User canceled the picker
// //     }
// //   }
// //
// //   // void _pickDirectory() async {
// //   //   String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
// //   //   if (selectedDirectory != null) {
// //   //     setState(() {
// //   //       _fileText = selectedDirectory;
// //   //     });
// //   //   } else {
// //   //     // User canceled the picker
// //   //   }
// //   // }
// //
// //   /// currently only supported for Linux, macOS, Windows
// //   /// If you want to do this for Android, iOS or Web, watch the following tutorial:
// //   /// https://youtu.be/fJtFDrjEvE8
// //   // void _saveAs() async {
// //   //   if (kIsWeb || Platform.isIOS || Platform.isAndroid) {
// //   //     return;
// //   //   }
// //   //
// //   //   String? outputFile = await FilePicker.platform.saveFile(
// //   //     dialogTitle: 'Please select an output file:',
// //   //     fileName: 'output-file.pdf',
// //   //   );
// //   //
// //   //   if (outputFile == null) {
// //   //     // User canceled the picker
// //   //   }
// //   // }
// //
// //   /// save file on Firebase
// //   void _saveOnFirebase() async {
// //     // FilePickerResult? result = await FilePicker.platform.pickFiles();
// //     //
// //     // if (result != null) {
// //     //   Uint8List fileBytes = result.files.first.bytes;
// //     //   String fileName = result.files.first.name;
// //     //
// //     //   // Upload file
// //     //   await FirebaseStorage.instance.ref('uploads/$fileName').putData(fileBytes);
// //     // }
// //   }
// //
// // }
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
class FileList extends StatefulWidget {
  final List<PlatformFile>files;
  final ValueChanged<PlatformFile>onOpenedFile;
  const FileList({Key? key, required this.files, required this.onOpenedFile}) : super(key: key);
  @override
  State<FileList> createState() => _FileListState();
}

class _FileListState extends State<FileList> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: ListView.builder(
            itemCount: widget.files.length,
            itemBuilder:(context,index){
              final files = widget.files[index];
              return buildListFile(files);
            })
    );
  }
  Widget buildListFile(PlatformFile file){
    final kb = file.size / 1024;
    final mb = kb / 1024;
    final size = (mb >= 1)
        ? '${mb.toStringAsFixed(2)} MB'
        : '${kb.toStringAsFixed(2)} KB';
    return InkWell(
      onTap: (){
        widget.onOpenedFile(file);
      },
      child: ListTile(
        title: Text('${file.name}'),
        subtitle: Text('${size}'),
        trailing:  Text('${file.extension}'
        ),
      ),
    );
  }
}