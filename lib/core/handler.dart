import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:wbc_connect_app/models/cart_model.dart';

import '../models/address_model.dart';

class DatabaseHelper {

  static DatabaseHelper? _databaseHelper; // Singleton DatabaseHelper
  static Database? _database; // Singleton Database

  String cartTable = 'cart_table';
  String cartId = 'id';
  String cartCategoryId = 'categoryId';
  String cartProductId = 'productId';
  String cartImg = 'img';
  String cartName = 'name';
  String cartPrice = 'price';
  String cartDiscount = 'discount';
  String cartQuantity = 'quantity';

  String addressTable = 'address_table';
  String addressId = 'id';
  String addressName = 'name';
  String addressNum = 'num';
  String addressPinCode = 'pinCode';
  String addressStreet = 'street';
  String addressSubLocality = 'subLocality';
  String addressCity = 'city';
  String addressState = 'state';
  String addressCountry = 'country';
  String addressAddressType = 'addressType';
  String addressIsSelected = 'isSelected';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String path = '${await getDatabasesPath()}/wbcConnect.db';
    var todosDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return todosDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $cartTable($cartId INTEGER, $cartCategoryId INTEGER, $cartProductId INTEGER, '
        '$cartImg TEXT, $cartName TEXT, $cartPrice REAL, $cartDiscount INTEGER,'
        '$cartQuantity INTEGER)');
    await db.execute(
        'CREATE TABLE $addressTable($addressId INTEGER, $addressName TEXT, $addressNum TEXT, '
        '$addressPinCode TEXT, $addressStreet TEXT, $addressSubLocality TEXT, '
        '$addressCity TEXT, $addressState TEXT, $addressCountry TEXT, '
        '$addressAddressType TEXT, $addressIsSelected INTEGER)');
  }

  //-------------------------
  Future<List<Map<String, dynamic>>> getCartMapList() async {
    Database db = await database;
    var result = await db.query(cartTable);
    return result;
  }

  Future<List<Map<String, dynamic>>> getAddressMapList() async {
    Database db = await database;
    var result = await db.query(addressTable, orderBy: '$addressId ASC');
    return result;
  }

  //-------------------------

//----------------------------------
  Future<int> insertCartData(CartItem cartItem) async {
    Database db = await database;
    var result = await db.insert(cartTable, cartItem.toJson());
    return result;
  }

  Future<int> insertAddress(ShippingAddress address) async {
    Database db = await database;
    var result = await db.insert(addressTable, address.toJson());
    return result;
  }

//----------------------------------

//----------------------------------
  Future<int> updateCartData(CartItem cartItem) async {
    var db = await database;
    var result = await db.update(cartTable, cartItem.toJson(),
        where: '$cartId = ?', whereArgs: [cartItem.id]);
    return result;
  }

  Future<int> updateAddressData(ShippingAddress address) async {
    var db = await database;
    var result = await db.update(addressTable, address.toJson(),
        where: '$addressId = ?', whereArgs: [address.id]);
    return result;
  }

//----------------------------------

//----------------------------------
  Future<int> deleteCartData(int id) async {
    var db = await database;
    var result = await db.delete(cartTable, where: "id = ?", whereArgs: [id]);
    return result;
  }

  Future<int> deleteAddressData(int id) async {
    var db = await database;
    var result = await db.delete(addressTable, where: "id = ?", whereArgs: [id]);
    return result;
  }

//----------------------------------

//----------------------------------
  Future<void> cleanCart() async {
    try {
      var db = await database;
      await db.transaction((txn) async {
        var batch = txn.batch();
        batch.delete(cartTable);
        await batch.commit();
      });
    } catch (error) {
      throw Exception('DbBase.cleanDatabase: $error');
    }
  }
//----------------------------------

//----------------------------------
  Future<List<CartItem>?> getCartDataList() async {
    var todoMapList = await getCartMapList();
    int count = todoMapList.length;
    List<CartItem>? data = [];
    for (int i = 0; i < count; i++) {
      data.add(CartItem.fromJson(todoMapList[i]));
    }
    return data;
  }

  Future<List<ShippingAddress>?> getAddressList() async {
    var todoList = await getAddressMapList();
    int count = todoList.length;
    List<ShippingAddress>? data = [];
    for (int i = 0; i < count; i++) {
      data.add(ShippingAddress.fromJson(todoList[i]));
    }
    return data;
  }

//----------------------------------
}
