import 'package:intl/intl.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:surveying_app/constants/mail_constants.dart';

import 'package:image_picker/image_picker.dart';

//アプリがファイルを保存可能な場所を取得するライブラリ
import 'package:path_provider/path_provider.dart';

//ファイル出力用ライブラリ
import 'dart:io';

class Utils {
  // 現在の時刻を文字列で取得する
  String time2Str() {
    DateTime now = DateTime.now();
    DateFormat formatTimeStamp = DateFormat('yyyy-MM-dd hh:mm:ss');
    return formatTimeStamp.format(now);
  }

  // カメラor写真アプリの起動
  static void execImage() async {
    //ストレージのパスを取得する
    final directory = await getExternalStorageDirectory();
    String path = "";

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (directory != null && pickedFile != null) {
      path = directory.path + '${DateTime.now()}.png';

      // saveTo()を使って指定したパスに画像を保存
      await pickedFile.saveTo(path);
    }
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
  void createCSV(
    List<Map<String, dynamic>> targetObjectList,
    Map<String, dynamic> basicInfo,
  ) {
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

    String info =
        "【SurveyingApp】ID:${basicInfo['id']} ${basicInfo['scene_name']}";

    openMailApp(csvStr, info);
  }

  void openMailApp(String csvResult, String info) async {
    String attach_file = await outputCsv(csvResult, info);

    final Email email = Email(
      body: MailConstants.mailBody,
      subject: info,
      recipients: [MailConstants.adminMail],
      attachmentPaths: [attach_file],
    );

    await FlutterEmailSender.send(email);
  }

  //ファイルの出力処理
  Future<String> outputCsv(String targetStr, String fileName) async {
    File file = await getFilePath(fileName);
    file.writeAsString(targetStr);
    return file.path;
  }

  //テキストファイルを保存するパスを取得する
  Future<File> getFilePath(String fileName) async {
    final directory = await getTemporaryDirectory();
    return File(directory.path + '/' + fileName + '.csv');
  }
}
