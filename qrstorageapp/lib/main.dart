import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/box_item.dart';
import 'home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and register adapters
  await Hive.initFlutter();
  Hive.registerAdapter(BoxItemAdapter());

  // Open a box (like a database table) for BoxItem objects
  await Hive.openBox<BoxItem>('boxes');

  runApp(const MyApp());
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
