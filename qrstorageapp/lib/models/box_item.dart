import 'package:hive/hive.dart';

part 'box_item.g.dart'; // Hive will generate this file

@HiveType(typeId: 0)
class BoxItem extends HiveObject {
  @HiveField(0)
  String boxNumber;

  @HiveField(1)
  String? title;

  @HiveField(2)
  String description;

  @HiveField(3)
  List<String>? imagePaths;

  BoxItem({
    required this.boxNumber,
    this.title,
    required this.description,
    this.imagePaths,
  });

  // Getter to provide a default title if null
  String get displayTitle => title ?? "Box #$boxNumber";
}
