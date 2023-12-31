import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:surveying_app/constants/mail_constants.dart';

import 'package:image_picker/image_picker.dart';

//アプリがファイルを保存可能な場所を取得するライブラリ
import 'package:path_provider/path_provider.dart';

//ファイル出力用ライブラリ
import 'dart:io';

import 'package:surveying_app/constants/review_constants.dart';

class Utils {
  // 現在の時刻を文字列で取得する
  String time2Str() {
    DateTime now = DateTime.now();
    DateFormat formatTimeStamp = DateFormat('yyyy-MM-dd hh:mm:ss');
    return formatTimeStamp.format(now);
  }

  // カメラor写真アプリの起動
  static Future<String> execImage(String method) async {
    //ストレージのパスを取得する
    int _imageQuality = 20;

    String path = "";
    final directory = await getApplicationDocumentsDirectory();

    final picker = ImagePicker();

    XFile? pickedFile;

    if (method == "camera") {
      pickedFile = await picker.pickImage(
          source: ImageSource.camera, imageQuality: _imageQuality);
    } else if (method == "album") {
      pickedFile = await picker.pickImage(
          source: ImageSource.gallery, imageQuality: _imageQuality);
    } else {
      pickedFile = null;
    }

    if (directory != null && pickedFile != null) {
      path = "${directory.path}/${DateTime.now()}.png";

      await pickedFile.saveTo(path);
      final savedFile = File(path);
      if (await savedFile.exists()) {
        print("撮影した画像は無事保存されました: ${path}");
      }
    }

    return path;
  }

  // 写真を削除する
  static void deleteImage(String filePath) async {
    final targetFile = File(filePath);
    if (await targetFile.exists()) {
      targetFile.delete();
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
  void createCSV(List<Map<String, dynamic>> targetObjectList,
      Map<String, dynamic> basicInfo, bool _pictureFlg) {
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

    openMailApp(csvStr, info, basicInfo['file_name'], _pictureFlg);
  }

  void openMailApp(
      String csvResult, String info, String imagePath, bool _pictureFlg) async {
    String csv_file = await outputCsv(csvResult, info);

    List<String> attachFilesPath = [csv_file];
    if (_pictureFlg && imagePath != null) {
      attachFilesPath.add(imagePath);
    }

    final Email email = Email(
      body: MailConstants.mailBody,
      subject: info,
      recipients: [MailConstants.adminMail],
      attachmentPaths: attachFilesPath,
    );

    await FlutterEmailSender.send(email);
  }

  void openReviewMail() async {
    final Email email = Email(
      // body: MailConstants.mailBody,
      // subject: info,
      recipients: [ReviewConstants.mail],
      // attachmentPaths: attachFilesPath,
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

  SnackBar makeSnackBar(String str) {
    final snackBar = SnackBar(
      content: Text(str),
      duration: const Duration(milliseconds: 2000),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    );

    return snackBar;
  }
}
