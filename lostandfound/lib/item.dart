import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ItemScreen extends StatelessWidget {
  final Map<String, dynamic> itemData;

  const ItemScreen({super.key, required this.itemData, required collection});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    final String itemName = itemData['name'] ?? '';
    final String imageUrl = itemData['imageUrl'] ?? '';
    final String description = itemData['description'] ?? 'No description';
    final String location = itemData['location'] ?? '';
    final String ownerId = itemData['userId'] ?? '';
    final String ownerName = itemData['userName'] ?? 'Unknown user';
    final String ownerEmail = itemData['userEmail'] ?? '';
    //Date handling
    String formattedDate = '';
    final dynamic dateValue = itemData['date'];

    if (dateValue is Timestamp) {
      final date = dateValue.toDate();
      formattedDate = "${date.day}/${date.month}/${date.year}";
    } else if (dateValue is String) {
      formattedDate = dateValue;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE7D3D0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios, size: 28),
              ),

              const SizedBox(height: 10),

              Center(
                child: Text(
                  itemName,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A1E1E),
                    fontFamily: 'Times New Roman',
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image, size: 80),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [

                  GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(Icons.person, size: 28),
                    ),
                  ),

                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ownerName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6A1E1E),
                        ),
                      ),
                      Text(
                        ownerEmail,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                "Description",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A1E1E),
                ),
              ),

              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xCBF7E9E9),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  description,
                  style: const TextStyle(fontSize: 15),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Date",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A1E1E),
                ),
              ),

              const SizedBox(height: 6),

              Text(
                formattedDate,
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 20),

              const Text(
                "Location",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A1E1E),
                ),
              ),

              const SizedBox(height: 6),

              Text(
                location,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}