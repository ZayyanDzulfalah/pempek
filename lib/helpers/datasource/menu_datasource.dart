import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restoku/helpers/models/menu_model.dart';
import 'package:sqflite/sqflite.dart';

class MenuDatabase {
  final String _databaseName = 'resto_database.db';
  final int _databaseVersion = 1;
  // menu table
  final String tableMenu = 'tableMenu';

  Database? _database;
  List<MenuModel> resultData = [];

  // init database
  Future<List<MenuModel>> database() async {
    if (_database != null){
      return resultData = await selectAllMenu();
    }
    _database = await _initDatabase();
    resultData = await selectAllMenu();
    return resultData;
  }

  _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String path = join(
      documentDirectory.path,
      _databaseName,
    );

    return openDatabase(path, version: _databaseVersion);
  }


  Future<List<MenuModel>> selectAllMenu() async {
    final data = await _database!.query(tableMenu);
    resultData = data.map((e) => MenuModel.fromJson(e)).toList();
    return resultData;
  }

  Future<void> insertMenu(Map<String, dynamic> row) async {
    await _database!.insert(tableMenu, row);
  }

  Future<void> deleteMenu(int? id) async {
    await _database!.delete(tableMenu, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateAccount(MenuModel menuModel) async {
    await _database!.update(tableMenu, menuModel.toMap(),
        where: 'id = ?', whereArgs: [menuModel.id]);
  }
}
