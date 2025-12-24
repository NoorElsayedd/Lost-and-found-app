import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profilescreen.dart';
import 'home.dart';
import 'item.dart';

class FoundScreen extends StatelessWidget {
  const FoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2DDDD),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.upload, size: 32, color: Color(0xFF7B0F0F)),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
              child:
              const Icon(Icons.person, size: 32, color: Color(0xFF7B0F0F)),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 20, top: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Home()),
                      );
                    },
                    child: const Icon(Icons.arrow_back_ios,
                        size: 28, color: Color(0xFF7B0F0F)),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Found Items",
                    style: TextStyle(
                      fontSize: 32,
                      color: Color(0xFF7B0F0F),
                      fontWeight: FontWeight.w900,
                      fontFamily: "Times New Roman",
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('found')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData ||
                      snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text("No found items yet"));
                  }

                  final items = snapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final doc = items[index];
                      final data =
                      doc.data() as Map<String, dynamic>;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ItemScreen(
                                itemData: data,
                                collection: 'found',
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2DDDD),
                            borderRadius:
                            BorderRadius.circular(12),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius:
                                BorderRadius.circular(10),
                                child: Image.network(
                                  data['imageUrl'],
                                  width: 85,
                                  height: 85,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.image),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Text(
                                  data['name'],
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Color(0xFF7B0F0F),
                                    fontWeight: FontWeight.w600,
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
      ),
    );
  }
}
