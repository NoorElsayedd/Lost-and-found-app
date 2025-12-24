import 'package:flutter/material.dart';
import 'package:lostandfound/services/image_picker_helper.dart';
import 'package:lostandfound/upload.dart';
import 'categories.dart';
import 'found.dart';
import 'lost.dart';
import 'profilescreen.dart';
import 'results.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController searchController = TextEditingController();


  void _goToResults() {
    if (searchController.text
        .trim()
        .isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Results(
          searchKeyword: searchController.text.trim().toLowerCase(),
        ),
      ),
    );
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8CDCE),

      body: SafeArea(
        child: Column(
          children: [


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFFB36A6A),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    const Icon(Icons.search, color: Colors.white70, size: 20),
                    const SizedBox(width: 10),

                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onSubmitted: (_) => _goToResults(),
                        decoration: const InputDecoration(
                          hintText: "Search…",
                          hintStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.arrow_forward, color: Colors.white),
                      onPressed: _goToResults,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const Text(
                    "Found an item? click here",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => FoundScreen()),
                      );
                    },
                    child: _mainButton("Found"),
                  ),

                  const SizedBox(height: 40),
                  const Text(
                    "Browse by categories",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => categories()),
                      );
                    },
                    child: _mainButton("Categories"),
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    "Lost an item? click here",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => LostScreen()),
                      );
                    },
                    child: _mainButton("Lost"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            IconButton(
              icon: const Icon(Icons.upload,
                  size: 32, color: Color(0xFF6A1E1E)),
              onPressed: () async {
                final image = await ImagePickerHelper.pickImage();
                if (image == null) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UploadScreen(imageFile: image),
                  ),
                );
              },
            ),

            IconButton(
              icon: const Icon(Icons.person,
                  size: 32, color: Color(0xFF6A1E1E)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _mainButton(String text) {
    return Container(
      width: 220,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Color(0xFF6A1E1E),
          ),
        ),
      ),
    );
  }
}
