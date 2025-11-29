import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:qrstorageapp/models/box_item.dart';
import 'package:qrstorageapp/box_detail.dart';

void main() async {
  late String _tempPath;

  setUpAll(() async {
    // avoid Hive.initFlutter() in tests to prevent path_provider plugin calls
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

  testWidgets('BoxDetailScreen shows title, description, location', (
    WidgetTester tester,
  ) async {
    final item = BoxItem(
      boxNumber: '001',
      title: 'Test Box',
      description: 'This is a test box.',
      location: 'Garage',
      imagePaths: [],
    );

    await tester.pumpWidget(
      MaterialApp(home: BoxDetailScreen(item: item, index: 0)),
    );

    expect(find.text('Box: 001'), findsOneWidget);
    expect(find.text('Test Box'), findsOneWidget);
    expect(find.text('This is a test box.'), findsOneWidget);
    expect(find.text('Garage'), findsOneWidget);
  });
}
