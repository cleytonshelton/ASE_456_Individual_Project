import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeManager extends ChangeNotifier {
  static const _themeBox = 'settings';
  static const _themeKey = 'isDarkMode';

  late Box _box;
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  Future<void> init() async {
    _box = await Hive.openBox(_themeBox);
    _isDarkMode = _box.get(_themeKey, defaultValue: false);
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _box.put(_themeKey, _isDarkMode);
    notifyListeners();
  }
}
