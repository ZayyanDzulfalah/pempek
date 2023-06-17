import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restoku/helpers/models/order_model.dart';
import 'package:sqflite/sqflite.dart';

class OrderDatabase {
  final String _databaseName = 'resto_database.db';
  final int _databaseVersion = 1;
  // order table
  final String tableOrder = 'tableOrder';

  Database? _database;
  List<OrderModel> resultData = [];

  // init database
  Future<List<OrderModel>> database() async {
    if (_database != null){
      return resultData = await selectAllOrder();
    }
    _database = await _initDatabase();
    resultData = await selectAllOrder();
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



  Future<List<OrderModel>> selectAllOrder() async {
    final data = await _database!.query(tableOrder);
    resultData = data.map((e) => OrderModel.fromJson(e)).toList();
    return resultData;
  }

  Future<void> insertOtableOrder(Map<String, dynamic> row) async {
    await _database!.insert(tableOrder, row);
  }

  Future<void> deleteOrder(int? id) async {
    await _database!.delete(tableOrder, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateOrder(OrderModel orderModel) async {
    await _database!.update(tableOrder, orderModel.toMap(),
        where: 'id = ?', whereArgs: [orderModel.id]);
  }
}
