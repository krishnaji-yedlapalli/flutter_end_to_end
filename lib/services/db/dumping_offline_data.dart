part of 'offline_handler.dart';

class _DumpingOfflineData with BaseService {
  static final _DumpingOfflineData _singleton = _DumpingOfflineData._internal();

  factory _DumpingOfflineData() {
    return _singleton;
  }

  _DumpingOfflineData._internal();

  /// Store offline data from the server
  static Future<void> dumpOfflineData(List<dynamic> args) async {
    SendPort port = args[0];

    BackgroundIsolateBinaryMessenger.ensureInitialized(args[1]);

    port.send((title: 'Extracting Data from Zip', percentage: 40));

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    /// Zip information
    ByteData value = await args[2];
    Uint8List zipData = value.buffer.asUint8List(value.offsetInBytes, value.lengthInBytes);
    InputStream ifs = InputStream(zipData);
    final archive = ZipDecoder().decodeBuffer(ifs);

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

        port.send((title: 'Dumping Schools into Local Data base', percentage: 70));

        if (data != null) {
          await _SchoolsDbHandler().performCrudOperation(RequestOptions(path: Urls.schools, method: RequestType.store.name, data: data));
        }

      } else if (file.path.contains('students')) {

        port.send((title: 'Dumping Schools into Local Data base', percentage: 80));

        if (data != null) {
          await _SchoolsDbHandler().performCrudOperation(RequestOptions(path: Urls.students, method: RequestType.store.name, data: data));
        }
      }
    }
    ifs.close();
    port.send('success');
  }
}
