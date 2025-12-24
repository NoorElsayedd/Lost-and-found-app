import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';
import 'services/cloudinary_upload_service.dart';

class UploadScreen extends StatefulWidget {
  final File imageFile;

  const UploadScreen({super.key, required this.imageFile});

  @override
  State<UploadScreen> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadScreen> {
  bool isFound = true;
  bool isLoading = false;

  String selectedCategory = 'Electronics';

  final List<String> categories = [
    'Electronics',
    'Makeup',
    'Personal belongings',
    'Other',
  ];

  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  Future<void> submitItem() async {
    if (nameController.text.isEmpty ||
        dateController.text.isEmpty ||
        locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill required fields')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final collectionName = isFound ? 'found' : 'lost';

      final imageUrl =
      await CloudinaryUploadService.uploadImage(widget.imageFile);

      if (imageUrl == null) {
        throw Exception('Image upload failed');
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      await FirebaseFirestore.instance.collection(collectionName).add({
        'name': nameController.text.trim(),
        'date': dateController.text.trim(),
        'location': locationController.text.trim(),
        'description': descriptionController.text.trim(),
        'imageUrl': imageUrl,

        'category': selectedCategory,

        'userId': uid,
        'userName': userDoc['fullName'],
        'userEmail': userDoc['email'],
        'createdAt': Timestamp.now(),
      });

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Home()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7D3D0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const Home()),
                  );
                },
                child: const Icon(Icons.arrow_back_ios, size: 28),
              ),

              const SizedBox(height: 10),

              SizedBox(
                height: 200,
                child: Center(
                  child: Image.file(widget.imageFile),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _toggleButton("Found", true),
                  const SizedBox(width: 20),
                  _toggleButton("Lost", false),
                ],
              ),

              const SizedBox(height: 25),

              _buildField("Name", controller: nameController),
              const SizedBox(height: 15),

              _buildField("Date", controller: dateController),
              const SizedBox(height: 15),

              _buildField("Location", controller: locationController),
              const SizedBox(height: 15),

              _buildField(
                "Description (optional)",
                controller: descriptionController,
                maxLines: 3,
              ),

              const SizedBox(height: 20),

              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7E9E9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    isExpanded: true,
                    items: categories
                        .map(
                          (c) => DropdownMenuItem(
                        value: c,
                        child: Text(
                          c,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF6A1E1E),
                          ),
                        ),
                      ),
                    )
                        .toList(),
                    onChanged: (value) {
                      setState(() => selectedCategory = value!);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Center(
                child: GestureDetector(
                  onTap: isLoading ? null : submitItem,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xFFF7E9E9),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                      "submit",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6A1E1E),
                        fontFamily: 'Times New Roman',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _toggleButton(String text, bool value) {
    return GestureDetector(
      onTap: () => setState(() => isFound = value),
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isFound == value ? Colors.white : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isFound == value
                  ? const Color(0xFF6A1E1E)
                  : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
      String hint, {
        int maxLines = 1,
        required TextEditingController controller,
      }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF7E9E9),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black54),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
