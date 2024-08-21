
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<Uint8List?> pickImage(ImageSource source) async {
  final ImagePicker _imagePiker = ImagePicker();
  final XFile? _file = await _imagePiker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No image selected');
}

ShowSnackBar(String content,BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        content: Text(
         content
        )
    )
  );
}