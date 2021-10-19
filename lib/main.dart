import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:motivation_accelerator/screen/welcome_screen.dart';
import 'package:provider/provider.dart';

import 'model/habit_data.dart';

final FirebaseMessaging _firebaseMessaging =
    FirebaseMessaging.instance; // バックグラウンドの処理の実態
// トップレベルに定義
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("バックグラウンドでメッセージを受け取りました");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  _firebaseMessaging.getToken().then((String? token) {
    print('$token');
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HabitData>(
      create: (_) => HabitData(),
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData.dark(),
          builder: EasyLoading.init(),
          home: const SafeArea(
            child: WelcomeScreen(),
          )),
    );
  }
}
