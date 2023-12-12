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
    _database = await initDatabase();
    return _database;
  }

  // データベース接続
  initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // 開発用　DBを削除するとき
  void dropDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // DBを削除するとき
    await deleteDatabase(path);
  }

  Future _onCreate(Database db, int version) async {
    // mst_surveyingテーブルの作成
    await db.execute('''
          CREATE TABLE mst_surveying (
            id INTEGER ,
            scene_name TEXT NOT NULL,
            scene_seq INTEGER NOT NULL ,
            scene_note TEXT,
            person_in_charge TEXT,
            place TEXT,
            upd_date TEXT,
            primary key ("id" , "scene_seq")
          )
          ''');

    await db.execute('''
          CREATE TABLE trn_surveying (
            id INTEGER ,
            scene_seq INTEGER NOT NULL ,
            bm_flg TEXT NOT NULL ,
            list_index INTEGER NOT NULL ,
            bs_number INTEGER,
            fs_number INTEGER,
            ih_number INTEGER,
            gh_number INTEGER,
            upd_date TEXT,
            primary key ("id" , "scene_seq" , "list_index")
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
    // Future<int> dummy = delete();

    return await db!.insert("trn_surveying", row);
  }

  // マスタデータ照会処理
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    return await db!.query("mst_surveying");
  }

  // トランザクション照会処理
  Future<List<Map<String, dynamic>>> readTrn(id, seq) async {
    Database? db = await instance.database;
    return await db!.query("trn_surveying",
        columns: [
          'list_index',
          'bm_flg',
          'bs_number',
          'fs_number',
          'ih_number',
          'gh_number',
        ],
        where: "id = ? and scene_seq = ?",
        whereArgs: [id, seq]);
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
    return await db!.update("mst_surveying", row,
        where: 'id = ? and scene_seq = ?',
        whereArgs: [row['id'], row['scene_seq']]);
  }

  //　マスタ削除処理
  Future<int> deleteMst(int id) async {
    Database? db = await instance.database;
    return await db!.delete("mst_surveying", where: 'id = ?', whereArgs: [id]);
  }

  //　トランザクション削除処理
  Future<int> deleteTrn(int id, int seq) async {
    Database? db = await instance.database;
    return await db!.delete("trn_surveying",
        where: 'id = ? and scene_seq = ?', whereArgs: [id, seq]);
  }

  Future<int> trnDelte(int id, int seq) async {
    Database? db = await instance.database;
    return await db!.delete("trn_surveying",
        where: ' id = ? and scene_seq = ?', whereArgs: [id, seq]);
    // return await db!.delete(table);
  }
}
