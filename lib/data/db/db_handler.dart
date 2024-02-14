
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class DbHandler {
  static final _singleton = DbHandler._internal();

  static const String _dbName = 'school';

  factory DbHandler() {
    return _singleton;
  }

  DbHandler._internal();

  Database? _db;

  Future<void> initializeDb() async {

    assert(_db == null, 'Db already initialized');

    try{
    String dbPath = join(await getDatabasesPath(), '$_dbName.db');
    _db = await openDatabase(dbPath, version: 1, onCreate: onCreate);
    }catch(e,s){

    }
  }

  Future<Database> get db async {
    if(_db == null) await initializeDb();
    return _db!;
  }

  void onCreate(Database db, int version) async {
    // Read SQL queries from file
    String fileContents = await rootBundle.loadString('');
    List<String> queries = fileContents.split(';'); // Assuming queries are separated by semicolon

    // Execute each query
    Batch batch = db.batch();
    for (String query in queries) {
      if (query.trim().isNotEmpty) {
        batch.execute(query.trim());
      }
    }
  }
}
