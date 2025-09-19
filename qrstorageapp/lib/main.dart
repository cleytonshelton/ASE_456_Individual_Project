import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const QRStorageApp());
}

class QRStorageApp extends StatelessWidget {
  const QRStorageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Storage',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _items = [];

  Future<void> _addItem(String qrCode) async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      setState(() {
        _items.add({'qr': qrCode, 'image': photo.path});
      });
    }
  }

  void _scanQRCode() async {
    // TODO: integrate qr_code_scanner or mobile_scanner package
    // For now, we’ll simulate with a fake QR code
    String fakeQrCode = "Box-${_items.length + 1}";
    await _addItem(fakeQrCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QR Storage")),
      body: _items.isEmpty
          ? const Center(child: Text("No items yet. Scan a QR to add one."))
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return Card(
                  child: ListTile(
                    leading: Image.file(
                      File(item['image']),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text("QR: ${item['qr']}"),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanQRCode,
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }
}
