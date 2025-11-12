import 'dart:io';
import 'package:flutter/material.dart';
import 'models/box_item.dart';
import 'full_image.dart';

class BoxDetailScreen extends StatelessWidget {
  final BoxItem item;
  final int index;

  const BoxDetailScreen({super.key, required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    final hasPhotos = item.imagePaths != null && item.imagePaths!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text("Box: ${item.boxNumber}"),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_horiz),
            onSelected: (value) async {
              if (value == 'edit') {
                return;
              } else if (value == 'delete') {
                Navigator.pop(context, 'delete');
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Edit Box'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete Box'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Big title
            Center(
              child: Text(
                item.displayTitle,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Horizontal photo gallery
            if (hasPhotos) ...[
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: item.imagePaths!.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final path = item.imagePaths![index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FullImageScreen(imagePath: path),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.file(
                          File(path),
                          width: 260,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Description header
            const Text(
              "Description",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Description text
            Text(
              item.description,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
