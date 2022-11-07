import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String?> downloadFile(
    {required String url, required String fileName}) async {
  final status = await Permission.storage.request();

  if (status.isGranted) {
    final savedDir = await getCustomPath('movie');
    return await FlutterDownloader.enqueue(
        url: url, savedDir: savedDir, fileName: fileName);
  } else {
    return null;
  }
}

Future<String> getCustomPath(String type) async {
  Directory rootDir = await getExternalStorageDirectory() ??
      await getApplicationDocumentsDirectory();

  String rootPath = rootDir.path;
  String path = "$rootPath/$type";

  return (await generateDir(path)).path;
}

Future<Directory> generateDir(String path) async {
  if (await Directory(path).exists()) {
    return Directory(path);
  } else {
    final newDir = await Directory(path).create();
    return newDir;
  }
}
