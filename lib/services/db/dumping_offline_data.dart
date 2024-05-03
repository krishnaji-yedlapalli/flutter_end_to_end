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
    // WidgetsFlutterBinding.ensureInitialized();

    port.send(
        (title: 'Extracting Data from Zip', percentage: 40));

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

      // var a = 10;
      // for (int i = 0; i < 10000000000; i++) {
      //   a += (i / 100).round();
      // }

      ByteData value = await rootBundle.load("asset/school_data.zip");
      // .then((ByteData value) {
      Uint8List wzzip =
      value.buffer.asUint8List(value.offsetInBytes, value.lengthInBytes);
      InputStream ifs = InputStream(wzzip);
      final archive = ZipDecoder().decodeBuffer(ifs);
      var paths = <String>[];

      for (var file in archive.files) {
        if (file.isFile) {
          String path = '$tempPath/${file.name}';
          final outputStream = OutputFileStream('$tempPath/${file.name}');

          if (!(file.name
              .split('/')
              .last[0].contains('.'))) {
            paths.add(path);
          }
          file.writeContent(outputStream);
          outputStream.close();
        }
      }

      await Future.delayed(Duration(seconds: 1));
    port.send(
          (title: 'Inserting into Local Data base', percentage: 70));

      for (var path in paths) {
        var file = File(path);
        var map = jsonDecode(await file.readAsString());

        if (file.path.contains('schools')) {
          if (map != null) {
            await _SchoolsDbHandler().performCrudOperation(RequestOptions(
                path: Urls.schools,
                method: RequestType.store.name,
                data: map));
          }
        } else if (file.path.contains('students')) {
          if (map != null) {
            await _SchoolsDbHandler().performCrudOperation(RequestOptions(
                path: Urls.students,
                method: RequestType.store.name,
                data: map));
          }
        }
      }
      ifs.close();
    await Future.delayed(Duration(seconds: 1));
    port.send('sucess');
  }
}
