import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqfLiteDbHandler {
  late Database _db;

  SqfLiteDbHandler._create();

  static Future<SqfLiteDbHandler> create(String dbName, String queryFileName) async {
    var component = SqfLiteDbHandler._create();
    await component._initializeDb(dbName, queryFileName);
    return component;
  }

  Future<void> _initializeDb(String dbName, String queryFileName) async {
    try {
      String dbPath = join(await getDatabasesPath(), '$dbName.db');
      debugPrint('db path : $dbPath');
      _db = await openDatabase(dbPath, version: 4, onCreate: (Database db, int version) => _onCreate(db, version, queryFileName), onUpgrade: (Database db, int oldVersion, int newVersion) => _onUpgrade(db, oldVersion, newVersion, queryFileName));
    } catch (e, s) {
      rethrow;
    }
  }

  Database get db {
    return _db;
  }

  void _onCreate(Database db, int version, String queryFileName) async {
    // Read SQL queries from file
    String fileContents = await rootBundle.loadString('lib/data/db/queries/$queryFileName.sql');
    fileContents = fileContents.trim().replaceAll('\n', '');
    List<String> queries = fileContents.split(';');

    // Execute each query
    Batch batch = db.batch();

    for (String query in queries) {
      if (query.trim().isNotEmpty) {
        batch.execute(query.trim());
      }
    }

    await batch.commit();
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion, String queryFileName){

  }

  Future<int> insertData(String tableName, dynamic data) async {
   return await db.insert(tableName, data);
  }

  Future<dynamic> query() async {
    await db.query('appointments',);
  }
}
