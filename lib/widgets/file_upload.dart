import 'dart:io';

import 'package:file_picker/src/platform_file.dart';
import 'package:flutter/material.dart';

Widget show({
  required List<PlatformFile> files,
}) {
  return ListView.builder(
    itemCount: files.length,
    itemBuilder: (context, index) {
      final file = files[index];
      return buildFile(file);
    },
  );}
Widget buildFile(PlatformFile file) {
  final kb = file.size / 1024;
  final mb = kb / 1024;
  final size =
  (mb >= 1) ? '${mb.toStringAsFixed(2)} MB' : '${kb.toStringAsFixed(2)} KB';
  return Container(
    color: Colors.amber,
    child: InkWell(
      onTap: () => null,
      child: Container(
        height: 100,
        width: 200,
        color: Colors.red,
        child: ListTile(
          leading: (file.extension == 'jpg' || file.extension == 'png')
              ? Image.file(
            File(file.path.toString()),
            width: 80,
            height: 80,
          )
              : Container(
            width: 80,
            height: 80,
          ),
          title: Text('${file.name}'),
          subtitle: Text('${file.extension}'),
          trailing: Text(
            '$size',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    ),);}