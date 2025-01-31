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

  // TextData関連の操作
  static Future<void> saveText(TextData text) async {
    final box = await Hive.openBox<TextData>(textBox);
    await box.add(text);
  }

  static Future<List<TextData>> getAllTexts() async {
    final box = await Hive.openBox<TextData>(textBox);
    return box.values.toList();
  }

  static Future<void> updateText(int index, TextData text) async {
    final box = await Hive.openBox<TextData>(textBox);
    await box.putAt(index, text);
  }

  static Future<void> deleteText(int index) async {
    final box = await Hive.openBox<TextData>(textBox);
    await box.deleteAt(index);
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