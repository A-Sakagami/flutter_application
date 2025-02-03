import 'package:hive_flutter/hive_flutter.dart';
import '../storages/user_data.dart';
import '../storages/text_data.dart';

class StorageService {
  static const String userBox = 'userBox';
  static const String textBox = 'textBox';

  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserDataAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TextDataAdapter());
    }
    await Hive.openBox<UserData>(userBox);
    await Hive.openBox<TextData>(textBox);
  }

  // UserData関連の操作
  static Future<void> saveUser(UserData user) async {
    final box = await Hive.openBox<UserData>(userBox);
    await box.add(user);
  }

  static Future<List<UserData>> getAllUsers() async {
    final box = await Hive.openBox<UserData>(userBox);
    return box.values.toList();
  }

  static Future<void> updateUser(int index, UserData user) async {
    final box = await Hive.openBox<UserData>(userBox);
    await box.putAt(index, user);
  }

  static Future<void> deleteUser(int index) async {
    final box = await Hive.openBox<UserData>(userBox);
    await box.deleteAt(index);
  }

  // ログイン中のユーザーを検知する
  static Future<UserData?> getCurrentUser() async {
    final box = await Hive.openBox<UserData>('userBox');
    return box.get('userData');
  }

  // ログアウトの操作
  static Future<void> logout() async {
    final box = await Hive.openBox<UserData>(userBox);
    await box.delete('userData');
  }

  // TextData関連の操作
  // 既存のデータと新しいデータをマージして保存する想定
  static Future<void> saveAllTexts(List<TextData> textList) async {
    final box = await Hive.openBox<TextData>(textBox);
    final existingTexts = box.values.toList();

    for (var newText in textList) {
      int index = existingTexts.indexWhere((text) => text.id == newText.id);
      if (index != -1) {
        existingTexts[index] = newText; // 上書き保存
      } else {
        existingTexts.add(newText); // 新しいデータを追加
      }
    }

    await box.clear();
    await box.addAll(existingTexts);
  }
  
  static Future<void> saveText(TextData text) async {
    final box = await Hive.openBox<TextData>(textBox);
    await box.add(text);
  }

  static Future<List<TextData>> getAllTexts() async {
    final box = await Hive.openBox<TextData>(textBox);
    return box.values.toList();
  }

  static Future<void> updateText(TextData textData) async {
    // 既存のリストを取得
    List<TextData> textList = await getAllTexts();
    
    // 同じ ID のデータを検索し更新
    int index = textList.indexWhere((t) => t.id == textData.id);
    if (index > -1) {
      textList[index] = textData; // 上書き保存
    }

    // 更新したリストを保存
    await saveAllTexts(textList);
  }

  // idを指定して消去
  static Future<void> deleteTextById(int id) async {
    final box = await Hive.openBox<TextData>(textBox);
    final textList = box.values.toList();
    final index = textList.indexWhere((text) => text.id == id);
    if (index != -1) {
      await box.deleteAt(index);
    }
  }

  // ボックスのクリア
  static Future<void> clearUserBox() async {
    final box = await Hive.openBox<UserData>(userBox);
    await box.clear();
  }

  static Future<void> clearTextBox() async {
    final box = await Hive.openBox<TextData>(textBox);
    await box.clear();
  }
}