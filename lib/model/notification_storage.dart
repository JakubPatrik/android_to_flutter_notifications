import 'package:sqflite/sqflite.dart';

import 'notification_model.dart';

class NotificationStorage {
  Database db;

  static const String _table = "notificationTable";
  static const String _id = "id";
  static const String _title = "title";
  static const String _body = "body";
  static const String _image = "image";

  initialize() async {
    db = await openDatabase(
      'notification_storage.db',
      version: 1,
      onCreate: (db, version) async {
        db.execute('''
          create TABLE $_table (
            $_id text not null,
            $_title text not null,
            $_body text not null,
            $_image text not null,
          )
          ''');
      },
    );
  }

  Future<void> insert(NotificationModel n) async {
    await db.insert("$_table", n.toJson());
  }

  Future<void> delete(NotificationModel n) async {
    await db.delete("$_table", where: "$_id = ${n.id}");
  }

  close() async {
    await db.close();
  }
}
