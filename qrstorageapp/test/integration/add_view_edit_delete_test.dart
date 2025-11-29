import 'dart:typed_data';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:qrstorageapp/models/box_item.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

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

  group('Hive in-memory box tests', () {
    late Box<BoxItem> box;

    setUp(() async {
      box = await Hive.openBox<BoxItem>('testBox');
    });

    tearDown(() async {
      await box.clear();
      await box.close();
    });

    test('Add BoxItem', () async {
      final item = BoxItem(
        boxNumber: '001',
        title: 'Test Box',
        description: 'Test Description',
      );
      await box.add(item);

      expect(box.values.length, 1);
      expect(box.values.first.title, 'Test Box');
    });

    test('Edit BoxItem', () async {
      final item = BoxItem(
        boxNumber: '002',
        title: 'Old Title',
        description: 'Old Description',
      );
      await box.add(item);

      final updatedItem = BoxItem(
        boxNumber: '002',
        title: 'New Title',
        description: 'New Description',
      );

      await box.putAt(0, updatedItem);

      expect(box.values.first.title, 'New Title');
    });

    test('Delete BoxItem', () async {
      final item = BoxItem(
        boxNumber: '003',
        title: 'Delete Me',
        description: 'To be deleted',
      );
      await box.add(item);

      await box.deleteAt(0);

      expect(box.values.length, 0);
    });
  });
}
