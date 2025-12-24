import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lostandfound/profilescreen.dart';
import 'home.dart';
import 'item.dart';

class Results extends StatelessWidget {
  final String searchKeyword;

  const Results({super.key, required this.searchKeyword});

  @override
  Widget build(BuildContext context) {
    final String keyword = searchKeyword.trim().toLowerCase();
    return Scaffold(
      backgroundColor: const Color(0xFFF2DDDD),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Home()));
              },
              child: const Icon(Icons.upload,
                  size: 32, color: Color(0xFF7B0F0F)),
            ),

            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ProfileScreen()));
              },
              child: const Icon(Icons.person,
                  size: 32, color: Color(0xFF7B0F0F)),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios,
                      color: Color(0xFF7B0F0F)),
                ),
                const SizedBox(width: 20),
                const Text(
                  "Matching Results",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Times New Roman",
                    color: Color(0xFF7B0F0F),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

      Expanded(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('found')
              .where('name', isGreaterThanOrEqualTo: keyword)
              .where('name', isLessThanOrEqualTo: '$keyword\uf8ff')
              .snapshots(),
          builder: (context, foundSnapshot) {
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('lost')
                  .where('name', isGreaterThanOrEqualTo: keyword)
                  .where('name', isLessThanOrEqualTo: '$keyword\uf8ff')
                  .snapshots(),
              builder: (context, lostSnapshot) {
                if (foundSnapshot.connectionState == ConnectionState.waiting ||
                    lostSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final foundDocs = foundSnapshot.data?.docs ?? [];
                final lostDocs = lostSnapshot.data?.docs ?? [];

                final allDocs = [
                  ...foundDocs.map((d) => {'doc': d, 'collection': 'found'}),
                  ...lostDocs.map((d) => {'doc': d, 'collection': 'lost'}),
                ];

                if (allDocs.isEmpty) {
                  return const Center(
                    child: Text(
                      "Item not found",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7B0F0F),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: allDocs.length,
                  itemBuilder: (context, index) {
                    final doc = allDocs[index]['doc'] as QueryDocumentSnapshot;
                    final collection = allDocs[index]['collection'] as String;
                    final data = doc.data() as Map<String, dynamic>;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ItemScreen(
                              itemData: data,
                              collection: collection,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2DDDD),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black, width: 0.8),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                data['imageUrl'],
                                width: 75,
                                height: 75,
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
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF7B0F0F),
                                  fontFamily: "Times New Roman",
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
            );
          },
        ),
      ),
      ]
    ),
    ),
    );
  }
}
