import 'package:flutter/material.dart';
import 'categoryitems.dart';

class categories extends StatelessWidget {
  const categories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7D3D0),
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
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios,
                        color: Color(0xFF7B0F0F)),
                  ),
                  const SizedBox(width: 60),
                  const Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 28,
                      color: Color(0xFF7B0F0F),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            _btn(context, "Electronics"),
            _btn(context, "Makeup"),
            _btn(context, "Personal belongings"),
            _btn(context, "Other"),
          ],
        ),
      ),
    );
  }

  Widget _btn(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryItemsScreen(category: title),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        padding: const EdgeInsets.symmetric(vertical: 22),
        decoration: BoxDecoration(
          color: const Color(0xFFF5ECEC),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              color: Color(0xFF7B0F0F),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
