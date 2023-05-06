import 'dart:async';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();
  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _tblFavoriteList = 'restaurant_favorite';
  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/restaurant_app.db';

    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tblFavoriteList (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        pictureId TEXT,
        city TEXT,
        rating INTEGER
      );
    ''');
  }

  Future<int> insertRestaurant(Restaurant restaurant) async {
    final db = await database;
    return await db!.insert(_tblFavoriteList, restaurant.toJson());
  }

  Future<int> removeRestaurant(Restaurant restaurant) async {
    final db = await database;
    return await db!.delete(
      _tblFavoriteList,
      where: 'id = ?',
      whereArgs: [restaurant.id],
    );
  }

  Future<Map<String, dynamic>?> getRestaurantById(String id) async {
    final db = await database;
    final results = await db!.query(
      _tblFavoriteList,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getListRestaurant() async {
    final db = await database;
    final List<Map<String, dynamic>> results =
        await db!.query(_tblFavoriteList);
    return results;
  }
}
