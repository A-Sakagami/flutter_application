import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'user_data.g.dart';  // この行を追加

@HiveType(typeId: 0)
class UserData extends HiveObject {
  @HiveField(0)
  String? username;

  @HiveField(1)
  String? password;

  @HiveField(2)
  bool? isAdmin;

  @HiveField(3)
  bool? isLoggedIn;

  UserData({this.username, this.password, this.isAdmin, this.isLoggedIn});
  
  // バリデーションメソッド
  bool isValid() {
    return username != null
    && username!.isNotEmpty
    && password != null
    && password!.isNotEmpty
    && isAdmin != null 
    && isLoggedIn != null;
  }

  // null safeなgetter
  String get safeName => username ?? '';
  String get safePassword => password ?? '';
  bool get safeIsAdmin => isAdmin ?? false;
  bool get safeIsLoggedIn => isLoggedIn ?? false;

}


