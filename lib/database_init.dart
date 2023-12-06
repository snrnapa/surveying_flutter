import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseInit {
  static final _databaseName = "Surveying.db"; // DB名
  static final _databaseVersion = 1; // スキーマのバージョン指定

  static final table = 'mst_surveying'; // テーブル名
  static final columnId = 'id';
  static final columnSceneName = 'scene_name';
  static final columnSceneSeq = 'scene_seq';
  static final columnSceneNote = 'scene_note';
  static final columnUpdDate = 'upd_date';

  // DatabaseInit クラスを定義
  DatabaseInit._privateConstructor();
  // DatabaseInit._privateConstructor() コンストラクタを使用して生成されたインスタンスを返すように定義
  // DatabaseInit クラスのインスタンスは、常に同じものであるという保証
  static final DatabaseInit instance = DatabaseInit._privateConstructor();

  // Databaseクラス型のstatic変数_databaseを宣言
  // クラスはインスタンス化しない
  static Database? _database;

  // databaseメソッド定義
  // 非同期処理
  Future<Database?> get database async {
    // _databaseがNULLか判定
    // NULLの場合、_initDatabaseを呼び出しデータベースの初期化し、_databaseに返す
    // NULLでない場合、そのまま_database変数を返す
    // これにより、データベースを初期化する処理は、最初にデータベースを参照するときにのみ実行されるようになります。
    // このような実装を「遅延初期化 (lazy initialization)」と呼びます。
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // データベース接続
  _initDatabase() async {
    // アプリケーションのドキュメントディレクトリのパスを取得
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // 取得パスを基に、データベースのパスを生成
    String path = join(documentsDirectory.path, _databaseName);
    // // DBを削除するとき
    // await deleteDatabase(path);
    // データベース接続
    return await openDatabase(path,
        version: _databaseVersion,
        // テーブル作成メソッドの呼び出し
        onCreate: _onCreate);
  }

  // テーブル作成
  // 引数:dbの名前
  // 引数:スキーマーのversion
  // スキーマーのバージョンはテーブル変更時にバージョンを上げる（テーブル・カラム追加・変更・削除など）
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
    return await db!.insert(table, row);
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
    return await db!.query(table);
  }

  // トランザクション照会処理
  Future<List<Map<String, dynamic>>> readAllTrn() async {
    Database? db = await instance.database;
    return await db!.query("trn_surveying");
  }

  // レコード数を確認
  Future<int?> queryRowCount() async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(
        await db!.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // レコード数を確認
  Future<int?> queryMaxId() async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(
        await db!.rawQuery('SELECT max(id) FROM $table'));
  }

  //　更新処理
  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnId];
    return await db!
        .update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  //　削除処理
  Future<int> delete() async {
    Database? db = await instance.database;
    // return await db!.delete(table, where: '$columnId = ?', whereArgs: [id]);
    return await db!.delete(table);
  }

  Future<int> trnDelte(int id, int seq) async {
    Database? db = await instance.database;
    return await db!.delete("trn_surveying",
        where: ' id = ? and scene_seq = ?', whereArgs: [id, seq]);
    // return await db!.delete(table);
  }
}
