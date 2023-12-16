import 'package:intl/intl.dart';

//ファイル出力用ライブラリ
import 'dart:io';

//アプリがファイルを保存可能な場所を取得するライブラリ
import 'package:path_provider/path_provider.dart';

final _fileName = 'editTextField.txt';

class Utils {
  // 現在の時刻を文字列で取得する
  String time2Str() {
    DateTime now = DateTime.now();
    DateFormat formatTimeStamp = DateFormat('yyyy-MM-dd hh:mm:ss');
    return formatTimeStamp.format(now);
  }

  //少数型であるかどうかのヴァリデーションチェック
  bool doubleValidate(String? targetText) {
    if (targetText != null &&
        targetText != "" &&
        !RegExp(r'^\d+(\.\d+)?$').hasMatch(targetText)) {
      return false;
    }
    return true;
  }

  //CSVの出力用
  void createCSV(List<Map<String, dynamic>> targetObjectList) {
    String csvStr = "no,gh\n";

    print("CSVの作成を開始します");

    targetObjectList.forEach((element) {
      // csvStr = element['gh_number'];

      csvStr += element['list_index'].toString();
      csvStr += ",";
      csvStr += element['gh_number'].toString();
      csvStr += "\n";
    });

    print("**********************結果を出力します**********************");

    print(csvStr + "dev");

    print("**********************結果を出力しました**********************");

    print("CSVの作成が完了しました");

    getFilePath().then((File file) {
      file.writeAsString(csvStr);
    });
  }

  //テキストファイルを保存するパスを取得する
  Future<File> getFilePath() async {
    final directory = await getTemporaryDirectory();
    return File(directory.path + '/' + _fileName);
  }
}
