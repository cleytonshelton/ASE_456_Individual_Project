import 'package:hive/hive.dart';
import 'package:qrstorageapp/models/box_item.dart';

class BoxUtils {
  /// Returns the next available box number as a 3-digit string, e.g., '001', '002'.
  static String getNextBoxNumber(Box<BoxItem> box) {
    if (box.isEmpty) return '001';

    int maxNumber = 0;
    for (int i = 0; i < box.length; i++) {
      final item = box.getAt(i)!;
      final numberStr = item.boxNumber.replaceAll(RegExp(r'[^0-9]'), '');
      final number = int.tryParse(numberStr) ?? 0;
      if (number > maxNumber) maxNumber = number;
    }

    return (maxNumber + 1).toString().padLeft(3, '0');
  }
}
