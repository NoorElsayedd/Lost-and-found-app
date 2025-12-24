// import 'package:flutter/material.dart';
// import 'home.dart';
//
//
// class Signup extends StatelessWidget {
//   const Signup({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF2DDDD),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 28),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 40),
//
//               // Title
//               const Center(
//                 child: Text(
//                   "Sign Up",
//                   style: TextStyle(
//                     fontSize: 50,
//                     fontWeight: FontWeight.w900,
//                     color: Color(0xFF7B0F0F),
//                     fontFamily: 'Times New Roman',
//                   ),
//                 ),
//               ),
//
//
//               const SizedBox(height: 40),
//
//               const Text(
//                 "Full Name",
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Color(0xFF7B0F0F),
//                 ),
//               ),
//               const SizedBox(height: 6),
//               _buildInputField(),
//
//               const SizedBox(height: 16),
//
//               const Text(
//                 "Phone number (optional)",
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Color(0xFF7B0F0F),
//                 ),
//               ),
//               const SizedBox(height: 6),
//               _buildInputField(),
//
//               const SizedBox(height: 16),
//               const Text(
//                 "Faculty",
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Color(0xFF7B0F0F),
//                 ),
//               ),
//               const SizedBox(height: 6),
//               _buildInputField(),
//
//               const SizedBox(height: 16),
//
//               const Text(
//                 "Email",
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Color(0xFF7B0F0F),
//                 ),
//               ),
//               const SizedBox(height: 6),
//               _buildInputField(),
//
//               const SizedBox(height: 16),
//
//               const Text(
//                 "Password",
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Color(0xFF7B0F0F),
//                 ),
//               ),
//               const SizedBox(height: 6),
//               _buildInputField(obscure: true),
//
//               const SizedBox(height: 6),
//               const Text(
//                 "Password must contain atleast 8 characters",
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Color(0xFF7B0F0F),
//                   decoration: TextDecoration.underline,
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               // Conf
//               const Text(
//                 "Confirm Password",
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Color(0xFF7B0F0F),
//                 ),
//               ),
//               const SizedBox(height: 6),
//               _buildInputField(obscure: true),
//
//               const SizedBox(height: 25),
//
//               // Sign Up
//               Center(
//                 child: SizedBox(
//                   width: 240,
//                   height: 55,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF7B0F0F),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(22),
//                       ),
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const Home()),
//                       );
//                     },
//                     child: const Text(
//                       "Sign up",
//                       style: TextStyle(fontSize: 23, color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // input fields
//   Widget _buildInputField({bool obscure = false}) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFFF7E9E9),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: TextField(
//         obscureText: obscure,
//         decoration: const InputDecoration(
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String? selectedFaculty;
  bool isLoading = false;

  final List<String> faculties = [
    'Business',
    'Pharmacy',
    'Dentistry',
    'Engineering',
    'Political Science',
    'Computers and Information Technology',
    'Other'
  ];

  final RegExp fueEmailRegex = RegExp(r'^20\d{6}@fue\.edu\.eg$');

  Future<void> signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      // creating userr
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final uid = userCredential.user!.uid;

      // Saving user's info to Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'fullName': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'faculty': selectedFaculty,
        'email': emailController.text.trim(),
        'createdAt': Timestamp.now(),
      });

      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Signup failed')),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2DDDD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                const Center(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF7B0F0F),
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                _label('Full Name'),
                _inputField(
                  controller: nameController,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),

                const SizedBox(height: 16),
                _label('Phone number (optional)'),
                _inputField(controller: phoneController),

                const SizedBox(height: 16),
                _label('Faculty'),
                _facultyDropdown(),

                const SizedBox(height: 16),
                _label('Email'),
                _inputField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';
                    if (!fueEmailRegex.hasMatch(v)) {
                      return 'Email must be like 20xxxxxx@fue.edu.eg';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                _label('Password'),
                _inputField(
                  controller: passwordController,
                  obscure: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';
                    if (v.length < 8) return 'Minimum 8 characters';
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                _label('Confirm Password'),
                _inputField(
                  controller: confirmPasswordController,
                  obscure: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';
                    if (v != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                Center(
                  child: SizedBox(
                    width: 240,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B0F0F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      onPressed: isLoading ? null : signUp,
                      child: isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : const Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        color: Color(0xFF7B0F0F),
      ),
    ),
  );

  Widget _inputField({
    required TextEditingController controller,
    bool obscure = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7E9E9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        validator: validator,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding:
          EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }

  Widget _facultyDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7E9E9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedFaculty,
        hint: const Text('Select faculty'),
        items: faculties
            .map(
              (f) => DropdownMenuItem(
            value: f,
            child: Text(f),
          ),
        )
            .toList(),
        onChanged: (v) => setState(() => selectedFaculty = v),
        validator: (v) => v == null ? 'Required' : null,
        decoration: const InputDecoration(border: InputBorder.none),
      ),
    );
  }
}
