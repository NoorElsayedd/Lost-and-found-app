import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'item.dart';

class CategoryItemsScreen extends StatelessWidget {
  final String category;
  const CategoryItemsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2DDDD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2DDDD),
        foregroundColor: const Color(0xFF7B0F0F),
        title: Text(category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),

        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('lost').snapshots(),
        builder: (context, lostSnap) {
          if (lostSnap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return StreamBuilder<QuerySnapshot>(
            stream:
            FirebaseFirestore.instance.collection('found').snapshots(),
            builder: (context, foundSnap) {
              if (foundSnap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final List<Map<String, dynamic>> items = [];

              for (var doc in lostSnap.data!.docs) {
                final data = doc.data() as Map<String, dynamic>;
                if ((data['category'] ?? '').toString().toLowerCase() ==
                    category.toLowerCase()) {
                  items.add({...data, 'type': 'lost'});
                }
              }

              for (var doc in foundSnap.data!.docs) {
                final data = doc.data() as Map<String, dynamic>;
                if ((data['category'] ?? '').toString().toLowerCase() ==
                    category.toLowerCase()) {
                  items.add({...data, 'type': 'found'});
                }
              }

              if (items.isEmpty) {
                return const Center(child: Text("No items in this category"));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final data = items[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ItemScreen(
                            itemData: data,
                            collection: data['type'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2DDDD),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              data['imageUrl'],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['name'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF7B0F0F),
                                  ),
                                ),
                                Text(
                                  data['type'].toString().toUpperCase(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
