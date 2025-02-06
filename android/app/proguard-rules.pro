# Flutterの関連クラスを保護
-keep class io.flutter.** { *; }

# Firebase関連の設定（Firebaseを使用している場合）
-keep class com.google.firebase.** { *; }
-keepattributes *Annotation*

# Modelクラスの難読化防止
-keep class com.yourpackage.models.** { *; }
