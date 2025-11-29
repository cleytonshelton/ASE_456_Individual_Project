import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:qrstorageapp/models/box_item.dart';

void main() async {
  late String _tempPath;

  setUpAll(() async {
    final tmpDir = await Directory.systemTemp.createTemp('hive_test_');
    _tempPath = tmpDir.path;
    Hive.init(_tempPath);

    Hive.registerAdapter(BoxItemAdapter());
  });

  tearDownAll(() async {
    try {
      await Hive.close();
    } catch (_) {}

    final dir = Directory(_tempPath);
    if (await dir.exists()) await dir.delete(recursive: true);
  });

  group('BoxItem logic', () {
    test('Toggles favorite correctly', () {
      final item = BoxItem(
        boxNumber: '001',
        title: 'Test Box',
        description: 'Some description',
        imagePaths: [],
        isFavorite: false,
      );

      item.isFavorite = !item.isFavorite;
      expect(item.isFavorite, true);

      item.isFavorite = !item.isFavorite;
      expect(item.isFavorite, false);
    });

    test('Generates next box number correctly', () async {
      final box = await Hive.openBox<BoxItem>('testBoxes');
      await box.clear();

      // Add first item
      await box.add(
        BoxItem(
          boxNumber: '001',
          title: 'Box 1',
          description: 'Desc 1',
          imagePaths: [],
        ),
      );

      // Calculate next number
      int maxNumber = 0;
      for (int i = 0; i < box.length; i++) {
        final item = box.getAt(i)!;
        final number =
            int.tryParse(item.boxNumber.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        if (number > maxNumber) maxNumber = number;
      }

      final nextNumber = (maxNumber + 1).toString().padLeft(3, '0');
      expect(nextNumber, '002');

      await box.deleteFromDisk();
    });
  });
}
