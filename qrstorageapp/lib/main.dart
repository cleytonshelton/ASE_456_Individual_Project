import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/box_item.dart';
import 'home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('1️⃣ Widgets initialized.');

  await Hive.initFlutter();
  print('2️⃣ Hive initialized.');

  Hive.registerAdapter(BoxItemAdapter());
  print('4️⃣ Adapter registered.');

  await Hive.openBox<BoxItem>('boxes');
  print('5️⃣ Box opened.');

  runApp(const MyApp());
  print('6️⃣ runApp called.');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Box Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
