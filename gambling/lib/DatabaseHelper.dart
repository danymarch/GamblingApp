import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'app.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE settings (
        id INTEGER PRIMARY KEY,
        balance INTEGER
      )
    ''');
    // Imposta un saldo iniziale se non esiste già
    await db.insert('settings', {'id': 1, 'balance': 1000});
  }

  Future<int> getBalance() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query('settings', where: 'id = ?', whereArgs: [1]);
    return result.isNotEmpty ? result.first['balance'] : 1000;
  }

  Future<void> updateBalance(int balance) async {
    final db = await database;
    await db.update('settings', {'balance': balance}, where: 'id = ?', whereArgs: [1]);
  }
}
