import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qrstorageapp/add_box_screen.dart';
import 'package:qrstorageapp/models/box_item.dart';
import 'package:hive/hive.dart';

class MockBox extends Mock implements Box<BoxItem> {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      BoxItem(boxNumber: '000', title: '', description: '', imagePaths: []),
    );
  });

  testWidgets('Edit existing box updates Hive', (tester) async {
    final mockBox = MockBox();
    final existingItem = BoxItem(
      boxNumber: '001',
      title: 'Old',
      description: 'Old Desc',
      imagePaths: [],
    );

    when(() => mockBox.putAt(0, any<BoxItem>())).thenAnswer((_) async {});

    await tester.pumpWidget(
      MaterialApp(
        home: AddBoxScreen(
          box: mockBox,
          existingItem: existingItem,
          existingIndex: 0,
        ),
      ),
    );

    // Enter new text
    await tester.enterText(find.byKey(const Key('titleField')), 'Updated Box');
    await tester.enterText(
      find.byKey(const Key('descriptionField')),
      'Updated Desc',
    );

    // Tap Save
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Verify Hive putAt called
    verify(() => mockBox.putAt(0, any<BoxItem>())).called(1);
  });
}
