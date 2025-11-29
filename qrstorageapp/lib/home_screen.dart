import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:qrstorageapp/theme_manager.dart';
import 'models/box_item.dart';
import 'add_box_screen.dart';
import 'box_detail.dart'; // ✅ NEW IMPORT

class HomeScreen extends StatefulWidget {
  final Box<BoxItem>? box;

  const HomeScreen({super.key, this.box});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late Box<BoxItem> _box;
  String _searchQuery = "";
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _box = widget.box ?? Hive.box<BoxItem>('boxes');
  }

  void _navigateToAddBox() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddBoxScreen(box: _box)),
    );
  }

  Future<void> _deleteBox(int index) async {
    final item = _box.getAt(index)!;

    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Box'),
        content: Text(
          'Are you sure you want to delete Box #${item.boxNumber}?\n\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    if (confirmed == true) {
      await _box.deleteAt(index);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Box #${item.boxNumber} deleted'),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              _box.putAt(index, item);
            },
          ),
        ),
      );
    } else {
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BoxDetailScreen(item: item, index: index),
        ),
      );
    }
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      _navigateToAddBox();
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Consumer<ThemeManager>(
          builder: (context, themeManager, _) {
            final textColor = themeManager.isDarkMode
                ? Colors.white
                : Colors.black;
            final hintColor = textColor.withOpacity(0.7);

            // If searching → show expandable TextField
            if (_isSearching) {
              return TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Looking for something...",
                  hintStyle: TextStyle(color: hintColor),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: textColor, fontSize: 18),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              );
            }

            // If not searching → default title
            return Text("Packed Boxes", style: TextStyle(color: textColor));
          },
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,

        leading: _isSearching
            ? Consumer<ThemeManager>(
                builder: (context, themeManager, _) {
                  final iconColor = themeManager.isDarkMode
                      ? Colors.white
                      : Colors.black;
                  return IconButton(
                    icon: Icon(Icons.arrow_back, color: iconColor),
                    onPressed: () {
                      setState(() {
                        _isSearching = false;
                        _searchQuery = "";
                        _searchController.clear();
                      });
                    },
                  );
                },
              )
            : null,

        actions: [
          // 🔍 Search Icon (only when not searching)
          if (!_isSearching)
            Consumer<ThemeManager>(
              builder: (context, themeManager, _) {
                final iconColor = themeManager.isDarkMode
                    ? Colors.white
                    : Colors.black;
                return IconButton(
                  icon: Icon(Icons.search, color: iconColor),
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                );
              },
            ),

          // 🌙 Theme toggle button
          Consumer<ThemeManager>(
            builder: (context, themeManager, _) {
              return IconButton(
                icon: Icon(
                  themeManager.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                ),
                onPressed: () => themeManager.toggleTheme(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 📦 GRID VIEW + HIVE LISTENING
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _box.listenable(),
              builder: (context, Box<BoxItem> box, _) {
                // 🔎 FILTER HERE
                final filtered = box.values.where((item) {
                  final q = _searchQuery.toLowerCase();

                  return item.displayTitle.toLowerCase().contains(q) ||
                      item.description.toLowerCase().contains(q) ||
                      (item.location ?? "").toLowerCase().contains(q);
                }).toList();

                // ⭐ FAVORITES FIRST
                filtered.sort((a, b) {
                  if (a.isFavorite && !b.isFavorite) return -1;
                  if (!a.isFavorite && b.isFavorite) return 1;
                  return 0;
                });

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text(
                      "No matching boxes found.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
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
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    final originalIndex = box.values.toList().indexOf(item);

                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BoxDetailScreen(
                              item: item,
                              index: originalIndex,
                            ),
                          ),
                        );

                        if (result == 'delete') {
                          _deleteBox(originalIndex);
                        }
                      },
                      child: Card(
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
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: Colors.grey[200],
                                  child: Stack(
                                    children: [
                                      // --- The Image ---
                                      Positioned.fill(
                                        child:
                                            item.imagePaths != null &&
                                                item.imagePaths!.isNotEmpty
                                            ? Image.file(
                                                File(item.imagePaths!.first),
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                "assets/images/boxpicture.png",
                                                fit: BoxFit.cover,
                                              ),
                                      ),

                                      // ⭐ Favorite Icon
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              item.isFavorite =
                                                  !item.isFavorite;
                                              item.save(); // Hive persists
                                            });
                                          },
                                          child: Icon(
                                            item.isFavorite
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: item.isFavorite
                                                ? Colors.amber
                                                : Colors.white,
                                            size: 26,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 80,
                              padding: const EdgeInsets.all(12),
                              child: Center(
                                child: Text(
                                  item.displayTitle,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "Add Box"),
        ],
      ),
    );
  }
}
