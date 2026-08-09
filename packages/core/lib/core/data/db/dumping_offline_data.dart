import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:app_core/core/data/urls.dart';
import 'package:app_core/core/data/utils/service_enums_typedef.dart';
import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:schools/data/local/schools_db_handler.dart';

class DumpingOfflineData {
  static final DumpingOfflineData _singleton = DumpingOfflineData._internal();

  factory DumpingOfflineData() {
    return _singleton;
  }

  DumpingOfflineData._internal();

  /// Store offline data from the server
  static Future<void> dumpOfflineData(List<dynamic> args) async {
    SendPort port = args[0];

    BackgroundIsolateBinaryMessenger.ensureInitialized(args[1]);

    port.send((title: 'Extracting Data from Zip', percentage: 40));

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    /// Zip information
    ByteData value = await args[2];
    final archive = ZipDecoder().decodeBytes(value.buffer.asUint8List());

    /// Files paths
    var paths = <String>[];

    for (var file in archive.files) {
      if (file.isFile) {
        String path = '$tempPath/${file.name}';
        final outputStream = OutputFileStream('$tempPath/${file.name}');

        if (!(file.name.split('/').last[0].contains('.'))) {
          paths.add(path);
        }
        file.writeContent(outputStream);
        outputStream.close();
      }
    }

    /// Added delays for smooth experience in UI
    await Future.delayed(const Duration(seconds: 1));
    port.send((title: 'Inserting into Local Data base', percentage: 60));
    await Future.delayed(const Duration(seconds: 1));

    for (var path in paths) {
      var file = File(path);
      var data = jsonDecode(await file.readAsString());

      if (file.path.contains('schools')) {
        port.send(
            (title: 'Dumping Schools into Local Data base', percentage: 70));

        if (data != null) {
          await SchoolsDbHandler().performCrudOperation(RequestOptions(
              path: Urls.schools, method: RequestType.store.name, data: data));
        }
      } else if (file.path.contains('students')) {
        port.send(
            (title: 'Dumping Students into Local Data base', percentage: 80));

        if (data != null) {
          await SchoolsDbHandler().performCrudOperation(RequestOptions(
              path: Urls.students, method: RequestType.store.name, data: data));
        }
      }
    }
    port.send('success');
  }
}
