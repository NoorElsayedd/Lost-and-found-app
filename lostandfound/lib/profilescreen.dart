
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('User not logged in')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1E6E6),
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(
                child: Text(
                  'Profile data not found',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;

            return Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 28,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) =>  Home()),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 40),
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.grey.shade300,
                  child: const Icon(
                    Icons.person,
                    size: 55,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  data['fullName'] ?? 'No Name',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Times New Roman',
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  data['phone'] ?? 'No phone number',
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 10),

                Text(
                  data['email'] ?? user.email ?? '',
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 10),

                Text(
                  data['faculty'] ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
