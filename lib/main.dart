import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:motivation_accelerator/screen/welcome_screen.dart';
import 'package:provider/provider.dart';

import 'model/habit_data.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

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
