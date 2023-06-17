import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class RestoDatabase {
  final String _databaseName = 'resto_database.db';
  final int _databaseVersion = 1;

  // global
  final String id = 'id';
  final String name = 'name';

  // account table
  final String tableAccount = 'tableAccount';
  final String email = 'email';
  final String password = 'password';
  final String role = 'role';
  // menu table
  final String tableMenu = 'tableMenu';
  final String description = 'description';
  final String category = 'category';
  final String price = 'price';
  // order table
  final String tableOrder = 'tableOrder';
  final String menuId = 'menuId';
  final String quantity = 'quantity';
  final String amount = 'amount';
  final String itemName = 'itemName';
  final String status = 'status';

  Database? _database;

  // init database
  Future<Database> database() async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String path = join(
      documentDirectory.path,
      _databaseName,
    );

    return openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  // create table
  Future _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $tableAccount ($id INTEGER PRIMARY KEY, $name TEXT NULL, $email TEXT NULL, $password TEXT NULL, $role TEXT NULL)');

    await db.execute(
        'CREATE TABLE $tableMenu ($id INTEGER PRIMARY KEY, $name TEXT, $description TEXT, $category TEXT, $price TEXT)');
    await db.execute(
        'CREATE TABLE $tableOrder ($id INTEGER PRIMARY KEY, $menuId INTEGER, $quantity INTEGER, $amount TEXT, $itemName TEXT, $status TEXT)');
  }
}
