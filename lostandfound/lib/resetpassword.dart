import 'package:flutter/material.dart';
import 'package:lostandfound/resetconfirmation.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9CFCF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Reset Password",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF7A0E0E),
                    fontFamily: "Times New Roman",
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Email
              const Text(
                "Email",
                style: TextStyle(fontSize: 17),
              ),
              const SizedBox(height: 10),

              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF7E9E9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "Please ensure that you have access to this email as we will send you a mail to reset your password.",
                style: TextStyle(fontSize: 12, color: Color(0xFF7A0E0E),),
              ),

              const SizedBox(height: 30),

              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7A0E0E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            const ResetConfirmation()),
                      );
                    },
                    child: const Text(
                      "Send",
                      style: TextStyle(
                        fontSize: 22,
                        //fontFamily: "Times New Roman",
                       // fontWeight: FontWeight.bold,
                        color: Colors.white,
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
}
