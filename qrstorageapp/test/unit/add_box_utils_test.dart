import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:qrstorageapp/models/box_item.dart';
import 'package:qrstorageapp/utils/box_utils.dart';
import 'package:mocktail/mocktail.dart';

class MockBox extends Mock implements Box<BoxItem> {}

void main() {
  group('BoxUtils.getNextBoxNumber', () {
    test('returns 001 if box is empty', () {
      final mockBox = MockBox();
      when(() => mockBox.isEmpty).thenReturn(true);

      final nextNumber = BoxUtils.getNextBoxNumber(mockBox);

      expect(nextNumber, '001');
    });

    test('returns next sequential number with padding', () {
      final mockBox = MockBox();
      when(() => mockBox.isEmpty).thenReturn(false);

      final items = [
        BoxItem(boxNumber: '001', description: 'A', title: 'A'),
        BoxItem(boxNumber: '003', description: 'B', title: 'B'),
      ];

      when(() => mockBox.length).thenReturn(items.length);
      when(() => mockBox.getAt(0)).thenReturn(items[0]);
      when(() => mockBox.getAt(1)).thenReturn(items[1]);

      final nextNumber = BoxUtils.getNextBoxNumber(mockBox);

      expect(nextNumber, '004');
    });
  });
}
