import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

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
    String bodyFormat = "";

    bodyFormat += 'アプリ「SurveyingApp@Napa」から送信されています。\n ';
    bodyFormat += '下記の手順でご活用ください。\n';
    bodyFormat += '1.宛先をご自身のパソコンに設定\n';
    bodyFormat += '2.矢印の中のテキストをコピー\n';
    bodyFormat += '3.パソコンのテキストエディタに張り付け。';
    bodyFormat += '4.拡張子を.csvとして保存';
    bodyFormat += '5.各自ご活用ください。（Excelなどで利用できます）';

    bodyFormat += '↓↓↓↓↓↓↓↓↓↓↓↓↓↓\n';
    bodyFormat += '${csvResult}\n';
    bodyFormat += '↑↑↑↑↑↑↑↑↑↑\n';

    final Email email = Email(
      body: bodyFormat,
      subject: info,
      recipients: ["shino.satoru@gmail.com"],
      // attachmentPaths: ['images/sample1.png'],
    );

    await FlutterEmailSender.send(email);
  }

  Future<void> launchMail(Uri url) async {
    await launchUrl(url);
  }
}
