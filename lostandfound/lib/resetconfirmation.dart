import 'package:flutter/material.dart';
import 'package:lostandfound/login.dart';

class ResetConfirmation extends StatelessWidget {
  const ResetConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9CFCF),
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF7A0E0E)),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF7A0E0E),
                    width: 4,
                  ),
                ),
                child: Center(
                  child: Icon(Icons.check_outlined,
                      size: 140, color: const Color(0xFF7A0E0E)),
                ),
              ),
            ),

            const SizedBox(height: 40),
            Text(
              "We Sent An Email\nTo Reset Your\nPassword!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                height: 1.3,
                fontWeight: FontWeight.bold,
                fontFamily: "Times New Roman",
                color: const Color(0xFF7A0E0E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
