import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void displaySnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message.toString(),
        ),
      ),
    );
}

Future<File?> pickAudio() async {
  try {
    final filePickerRes = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (filePickerRes != null) {
      //return File(filePickerRes.files.first.xFile.path!);
      return File(filePickerRes.files.first.path!);
    }

    return null;
  } catch (e) {
    return null;
  }
}

Future<File?> pickImage() async {
  try {
    final filePickerRes =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (filePickerRes != null) {
      return File(filePickerRes.files.first.path!);
    }
    return null;
  } catch (e) {
    return null;
  }
}
