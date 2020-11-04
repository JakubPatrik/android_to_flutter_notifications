import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'notification_model.dart';

class NotificationStorage {
  static const String _table = "notificationTable";
  static const String _id = "message_id";
  static const String _title = "title";
  static const String _body = "body";
  static const String _image = "image";

  // make this a singleton class
  NotificationStorage._privateConstructor();
  static final NotificationStorage instance =
      NotificationStorage._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'notification_storage.db');
    return await openDatabase(
      path,
      onCreate: (db, version) {
        db.execute('''CREATE TABLE $_table(
            $_id STRING,
            $_title STRING,
            $_body STRING,
            $_image STRING
          )''');
      },
      version: 1,
    );
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query("$_table");
  }

  Future<void> insert(NotificationModel n) async {
    Database db = await instance.database;
    final i = await db.insert("$_table", n.toJson());
    print("$i");
  }

  Future<void> delete(NotificationModel n) async {
    Database db = await instance.database;
    await db.delete("$_table", where: "$_id = ${n.id}");
  }

  close() async {
    Database db = await instance.database;
    await db.close();
  }
}
