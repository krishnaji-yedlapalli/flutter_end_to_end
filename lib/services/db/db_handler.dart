import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sample_latest/services/utils/enums.dart';
import 'package:sqflite/sqflite.dart';


class SqfLiteDbHandler {

  late Database _db;

  SqfLiteDbHandler._create();

  static Future<SqfLiteDbHandler> initializeDb(DbInfo dbInfo) async {
    var component = SqfLiteDbHandler._create();
    await component._initializeDb(dbInfo.dbName, dbInfo.queryFileName, dbInfo.dbVersion);
    return component;
  }

  Future<void> _initializeDb(String dbName, String queryFileName, int dbVersion) async {
    try {
      String dbPath = join(await getDatabasesPath(), '$dbName.db');
      debugPrint('db path : $dbPath');
      _db = await openDatabase(dbPath,
             version: dbVersion,
             onCreate: (Database db, int version) => _onCreate(db, version, queryFileName),
             onUpgrade: (Database db, int oldVersion, int newVersion) => _onUpgrade(db, oldVersion, newVersion, queryFileName));
    } catch (e, s) {
      rethrow;
    }
  }

  Database get db {
    return _db;
  }

  void _onCreate(Database db, int version, String queryFileName) async {
    // Read SQL queries from file
    String fileContents = await rootBundle.loadString('lib/services/db/queries/$queryFileName.sql');
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
   return await db.insert(tableName, data, conflictAlgorithm: ConflictAlgorithm.replace,
   );
  }

  Future<dynamic> query(String tableName, {String? columnName, List<String>? ids}) async {
    return await db.query(tableName, where: columnName != null ? '$columnName = ?' : null, whereArgs : ids);
  }

  Future<dynamic> rawQueryWithParams(String query, {List<String>? params}) async {
    var a = await db.rawQuery(query, params);
    return a.first['COUNT(*)'];
  }


  Future<int> deleteRecord({required String tableName , required String columnName, required List<dynamic> ids}) async {
    return await db.delete(tableName, where: '$columnName = ?', whereArgs: ids);
  }

  Future<int> deleteTableData(String tableName) async {
    return await db.rawDelete("DELETE FROM $tableName");
  }

  Future<List<Object?>> insertBulkData(String tableName, List<Map<String, dynamic>> bulkData) async {
    Batch batch = db.batch();

    for(var obj in bulkData){
      batch.insert(tableName, obj);
    }

   return await batch.commit(continueOnError: true);
  }

  Future<bool> resetDataBase() async {
    List<Map> maps =
    await db.rawQuery('SELECT * FROM sqlite_master ORDER BY name;');

    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        try {
          if(maps[i]['name'] != null) {
            await deleteTableData(maps[i]['name'].toString());
          }
        } catch (e) {
          rethrow;
        }
      }
    }
    return true;
  }

}
