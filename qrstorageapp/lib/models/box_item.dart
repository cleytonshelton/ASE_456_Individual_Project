import 'package:hive/hive.dart';

part 'box_item.g.dart'; // Hive will generate this file

@HiveType(typeId: 0)
class BoxItem extends HiveObject {
  @HiveField(0)
  String qr;

  @HiveField(1)
  String description;

  @HiveField(2)
  List<String> imagePaths;

  BoxItem({
    required this.qr,
    required this.description,
    required this.imagePaths,
  });
}
