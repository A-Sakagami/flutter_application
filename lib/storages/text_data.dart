import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'text_data.g.dart';  // この行を追加

@HiveType(typeId: 1)
class TextData extends HiveObject {
  @HiveField(0)
  String? text;

  @HiveField(1)
  bool? approved;

  @HiveField(2)
  bool? denyed;

  @HiveField(3)
  int? id;

  TextData({this.text, this.approved, this.denyed, this.id});
  
  // バリデーションメソッド
  bool isValid() {
    return text != null
    && text!.isNotEmpty
    && approved != null 
    && denyed != null
    && id != null;
  }

  // null safeなgetter
  String get safeText => text ?? '';
  bool get safeApproved => approved ?? false;
  bool get safeDenyed => denyed ?? false;
  int get safeId => id ?? -1;

}