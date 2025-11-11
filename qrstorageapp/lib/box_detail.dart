import 'dart:io';
import 'package:flutter/material.dart';
import 'models/box_item.dart';
import 'full_image.dart';

class BoxDetailScreen extends StatelessWidget {
  final BoxItem item;

  const BoxDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final hasPhotos = item.imagePaths != null && item.imagePaths!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text("Box: ${item.boxNumber}")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Big title
            Text(
              item.displayTitle,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
