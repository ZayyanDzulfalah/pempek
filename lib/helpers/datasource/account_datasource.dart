import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/account_model.dart';

class AccountDatabase {
  final String _databaseName = 'resto_database.db';
  final int _databaseVersion = 1;

  // account table
  final String tableAccount = 'tableAccount';

  Database? _database;
  List<AccountModel> resultData = [];

  // init database
  Future<List<AccountModel>> database() async {
    if (_database != null){
      return resultData = await selectAllAccount();
    }
    _database = await _initDatabase();
    resultData = await selectAllAccount();
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


  Future<List<AccountModel>> selectAllAccount() async {
    // print(_database);
    final data = await _database!.query(tableAccount);
    resultData =
        data.map((e) => AccountModel.fromJson(e)).toList();
    return resultData;
  }

  Future<void> insertAccount(Map<String, dynamic> row) async {
    await _database!.insert(tableAccount, row);
  }

  Future<void> deleteAccount(int? id) async {
    await _database!.delete(tableAccount, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateAccount(AccountModel accountModel) async {
    await _database!.update(tableAccount, accountModel.toMap(),
        where: 'id = ?', whereArgs: [accountModel.id]);
  }
}
