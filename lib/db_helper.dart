import 'package:sqflite/sqflite.dart' as sql;
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Future<void> createaTables(sql.Database database) async {
    await database.execute(
      'CREATE TABLE user(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, desc TEXT, createAt TIME)',
    );
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'database_name.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createaTables(database);
      },
    );
  }

  static Future<int> createData(String title, String desc) async {
    final db = await DBHelper.db();
    final data = {
      'title': title,
      'desc': desc,
      'createAt': DateTime.now().toString(),
    };
    final id = await db.insert(
      'user',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await DBHelper.db();
    return db.query('user', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getSingleData(int id) async {
    final db = await DBHelper.db();
    return db.query('user', where: 'id = ?', whereArgs: [id], limit: 1);
  }

  static Future<int> updateData(int id, String title, String desc) async {
    final db = await DBHelper.db();
    final data = {
      'title': title,
      'desc': desc,
      'createAt': DateTime.now().toString(),
    };

    final result = await db.update(
      'user',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result;
  }

  static Future<void> deleteData(int id) async {
    final db = await DBHelper.db();
    try {
      await db.delete('user', where: 'id = ?', whereArgs: [id]);
    } catch (e) {}
  }
}
