import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qrstorageapp/add_box_screen.dart';
import 'package:qrstorageapp/models/box_item.dart';

class MockBox extends Mock implements Box<BoxItem> {}

// fake for mocktail fallback values
class BoxItemFake extends Fake implements BoxItem {}

void main() {
  setUpAll(() {
    registerFallbackValue(BoxItemFake());
  });

  testWidgets('AddBoxScreen saves a new box', (tester) async {
    final mockBox = MockBox();
    when(() => mockBox.isEmpty).thenReturn(true);
    when(() => mockBox.add(any())).thenAnswer((_) async => 0);

    await tester.pumpWidget(MaterialApp(home: AddBoxScreen(box: mockBox)));

    await tester.enterText(find.byType(TextFormField).first, 'Test Box');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Test Description',
    );

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    verify(() => mockBox.add(any())).called(1);
  });
}
