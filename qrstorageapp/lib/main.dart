import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/box_item.dart';
import 'home_screen.dart';
import 'theme_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('1️⃣ Widgets initialized.');

  await Hive.initFlutter();
  print('2️⃣ Hive initialized.');

  Hive.registerAdapter(BoxItemAdapter());
  print('4️⃣ Adapter registered.');

  var box = await Hive.openBox<BoxItem>('boxes');
  print('5️⃣ Hive box opened.');

  // Initialize theme manager
  final themeManager = ThemeManager();
  await themeManager.init();

  runApp(
    ChangeNotifierProvider.value(value: themeManager, child: const MyApp()),
  );
  print('6️⃣ runApp called.');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Box Tracker',
      themeMode: themeManager.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ).copyWith(surface: const Color(0xFF1E1E1E), onSurface: Colors.white70),
        scaffoldBackgroundColor: const Color(0xFF1C1C1C),
        cardColor: const Color(0xFF2A2A2A),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
