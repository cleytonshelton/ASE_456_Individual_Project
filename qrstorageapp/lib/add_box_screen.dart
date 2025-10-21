import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/box_item.dart';

class AddBoxScreen extends StatefulWidget {
  final Box<BoxItem> box;

  const AddBoxScreen({super.key, required this.box});

  @override
  State<AddBoxScreen> createState() => _AddBoxScreenState();
}

class _AddBoxScreenState extends State<AddBoxScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<String> _imagePaths = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Get the next available box number
  String _getNextBoxNumber() {
    if (widget.box.isEmpty) {
      return "001";
    }

    // Find the highest existing box number
    int maxNumber = 0;
    for (int i = 0; i < widget.box.length; i++) {
      final item = widget.box.getAt(i)!;
      final numberStr = item.boxNumber.replaceAll(RegExp(r'[^0-9]'), '');
      final number = int.tryParse(numberStr) ?? 0;
      if (number > maxNumber) {
        maxNumber = number;
      }
    }

    // Return next number with zero padding
    return (maxNumber + 1).toString().padLeft(3, '0');
  }

  // Add photo from camera
  Future<void> _addPhotoFromCamera() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      setState(() {
        _imagePaths.add(photo.path);
      });
    }
  }

  // Add photo from gallery
  Future<void> _addPhotoFromGallery() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.gallery);

    if (photo != null) {
      setState(() {
        _imagePaths.add(photo.path);
      });
    }
  }

  // Remove photo
  void _removePhoto(int index) {
    setState(() {
      _imagePaths.removeAt(index);
    });
  }

  // Save the box
  Future<void> _saveBox() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final boxNumber = _getNextBoxNumber();
      final newItem = BoxItem(
        boxNumber: boxNumber,
        title: _titleController.text.trim().isNotEmpty
            ? _titleController.text.trim()
            : null,
        description: _descriptionController.text.trim(),
        imagePaths: List.from(_imagePaths),
      );

      widget.box.add(newItem);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Box #$boxNumber created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating box: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Box'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveBox,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Box Title',
                  hintText: 'e.g., Winter Clothes, Kitchen Items',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title for the box';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description Field (Required)
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description *',
                  hintText: 'Describe the contents of this box in detail',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Photos Section
              Row(
                children: [
                  const Icon(Icons.photo_library, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Photos (Optional)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Add Photo Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _addPhotoFromCamera,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Camera'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _addPhotoFromGallery,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Gallery'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Photo Grid
              if (_imagePaths.isNotEmpty) ...[
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount: _imagePaths.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_imagePaths[index]),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _removePhoto(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],

              // Box Number Preview
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Box number will be automatically assigned: #${_getNextBoxNumber()}',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
