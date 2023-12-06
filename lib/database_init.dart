import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseInit {
  static final _databaseName = "Surveying.db";
  static final _databaseVersion = 1;

  DatabaseInit._privateConstructor();

  static final DatabaseInit instance = DatabaseInit._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // データベース接続
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // // DBを削除するとき
    // await deleteDatabase(path);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    // mst_surveyingテーブルの作成
    await db.execute('''
          CREATE TABLE mst_surveying (
            id INTEGER ,
            scene_name TEXT NOT NULL,
            scene_seq INTEGER NOT NULL ,
            scene_note TEXT,
            upd_date TEXT,
            primary key ("id" , "scene_seq")
          )
          ''');
    // trn_surveyingテーブルの作成

    await db.execute('''
          CREATE TABLE trn_surveying (
            id INTEGER ,
            scene_seq INTEGER NOT NULL ,
            category TEXT NOT NULL ,
            list_index INTEGER NOT NULL ,
            number INTEGER,
            upd_date TEXT,
            primary key ("id" , "scene_seq" , "category", "list_index")
          )
          ''');
  }

  // マスタデータ登録処理
  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert("mst_surveying", row);
  }

  //　トランザクション登録処理
  Future<int> insertTrn(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    Future<int> dummy = delete();

    return await db!.insert("trn_surveying", row);
  }

  // マスタデータ照会処理
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    return await db!.query("mst_surveying");
  }

  // トランザクション照会処理
  Future<List<Map<String, dynamic>>> readTrn(id, seq, category) async {
    Database? db = await instance.database;
    return await db!.query("trn_surveying",
        columns: ['list_index', 'number'],
        where: "id = ? and scene_seq = ? and category = ?",
        whereArgs: [id, seq, category]);
  }

  // レコード数を確認
  Future<int?> queryRowCount() async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(
        await db!.rawQuery('SELECT COUNT(*) FROM mst_surveying'));
  }

  // レコード数を確認
  Future<int?> queryMaxId() async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(
        await db!.rawQuery('SELECT max(id) FROM mst_surveying'));
  }

  //　更新処理
  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row["id"];
    return await db!
        .update("mst_surveying", row, where: 'id = ?', whereArgs: [id]);
  }

  //　削除処理
  Future<int> delete() async {
    Database? db = await instance.database;
    // return await db!.delete(table, where: 'id = ?', whereArgs: [id]);
    return await db!.delete("mst_surveying");
  }

  Future<int> trnDelte(int id, int seq) async {
    Database? db = await instance.database;
    return await db!.delete("trn_surveying",
        where: ' id = ? and scene_seq = ?', whereArgs: [id, seq]);
    // return await db!.delete(table);
  }
}
