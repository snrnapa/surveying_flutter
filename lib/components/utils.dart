import 'package:intl/intl.dart';

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
}
