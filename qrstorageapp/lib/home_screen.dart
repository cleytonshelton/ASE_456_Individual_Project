import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/box_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late Box<BoxItem> _box;

  @override
  void initState() {
    super.initState();
    _box = Hive.box<BoxItem>('boxes');
  }

  // Add an item with photo + auto-assigned box number
  Future<void> _addItem(String description) async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      // Auto-assign box number (incrementing from existing boxes)
      final nextBoxNumber = _getNextBoxNumber();
      
      final newItem = BoxItem(
        boxNumber: nextBoxNumber,
        description: description,
        imagePaths: [photo.path],
      );
      _box.add(newItem);
    }
  }

  // Get the next available box number
  String _getNextBoxNumber() {
    if (_box.isEmpty) {
      return "001";
    }
    
    // Find the highest existing box number
    int maxNumber = 0;
    for (int i = 0; i < _box.length; i++) {
      final item = _box.getAt(i)!;
      final numberStr = item.boxNumber.replaceAll(RegExp(r'[^0-9]'), '');
      final number = int.tryParse(numberStr) ?? 0;
      if (number > maxNumber) {
        maxNumber = number;
      }
    }
    
    // Return next number with zero padding
    return (maxNumber + 1).toString().padLeft(3, '0');
  }

  // Show dialog to input box description
  void _showAddBoxDialog() async {
    final TextEditingController descriptionController = TextEditingController();
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Box'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Describe the contents of this box:'),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: 'e.g., Winter clothes, Kitchen utensils, etc.',
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 8),
            Text(
              'Box number will be assigned automatically',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (descriptionController.text.trim().isNotEmpty) {
                Navigator.pop(context, descriptionController.text.trim());
              }
            },
            child: const Text('Add Box'),
          ),
        ],
      ),
    );
    
    if (result != null && result.isNotEmpty) {
      await _addItem(result);
    }
  }


  // Handle bottom nav bar tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      _showAddBoxDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Box Tracker")),
      body: ValueListenableBuilder(
        valueListenable: _box.listenable(),
        builder: (context, Box<BoxItem> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 100,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "No boxes yet.\nAdd a box to get started.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: box.length,
            itemBuilder: (context, index) {
              final item = box.getAt(index)!;
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.file(
                          File(item.imagePaths.first),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      height: 80,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Box #${item.boxNumber}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Expanded(
                            child: Text(
                              item.description,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: "Add Box",
          ),
        ],
      ),
    );
  }
}
