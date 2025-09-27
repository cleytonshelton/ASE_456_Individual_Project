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

  // Add an item with photo + QR
  Future<void> _addItem(String qrCode) async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      final newItem = BoxItem(
        qr: qrCode,
        description:
            "Default description here", // you can later replace with input
        imagePaths: [photo.path],
      );
      _box.add(newItem);
    }
  }

  // Fake QR scanner (replace with real scanner later)
  void _scanQRCode() async {
    String fakeQrCode = "Box-${_box.length + 1}";
    await _addItem(fakeQrCode);
  }

  // Take photo only
  Future<void> _takePhotoOnly() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      final newItem = BoxItem(
        qr: "Photo-${_box.length + 1}",
        description: "Photo only",
        imagePaths: [photo.path],
      );
      _box.add(newItem);
    }
  }

  // Handle bottom nav bar tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      _scanQRCode();
    } else if (index == 2) {
      _takePhotoOnly();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Boxes57")),
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
                    "No items yet.\nScan a QR or take a photo.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final item = box.getAt(index)!;
              return Card(
                child: ListTile(
                  leading: Image.file(
                    File(item.imagePaths.first),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text("QR: ${item.qr}"),
                  subtitle: Text(item.description),
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
            icon: Icon(Icons.qr_code_scanner),
            label: "Scan QR",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: "Camera",
          ),
        ],
      ),
    );
  }
}
