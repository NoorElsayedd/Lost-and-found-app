import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'resetpassword.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  final RegExp fueEmailRegex =
  RegExp(r'^20\d{6}@fue\.edu\.eg$');

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) =>  Home()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Login failed'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
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
                const SizedBox(height: 60),

                Center(
                  child: Text(
                    "LogIn",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF6E0E0A),
                      fontFamily: "Times New Roman",
                    ),
                  ),
                ),

                const SizedBox(height: 55),

                _label("Email"),
                _inputField(
                  controller: emailController,
                  hint: "20******@fue.edu.eg",
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Email is required";
                    if (!fueEmailRegex.hasMatch(v)) {
                      return "Email must be like id@fue.edu.eg";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                _label("Password"),
                _inputField(
                  controller: passwordController,
                  hint: "********",
                  obscure: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Password is required";
                    return null;
                  },
                ),

                const SizedBox(height: 6),

                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ResetPassword(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: const Text(
                      "Forgot Your Password?",
                      style: TextStyle(
                        color: Color(0xFF6E0E0A),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6E0E0A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : const Text(
                        "Login",
                        style:
                        TextStyle(fontSize: 22, color: Colors.white),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                Row(
                  children: [
                    Expanded(child: Container(height: 1.2, color: Colors.black)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text("or"),
                    ),
                    Expanded(child: Container(height: 1.2, color: Colors.black)),
                  ],
                ),

                const SizedBox(height: 20),

                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Signup(),
                        ),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: "Don’t Have Any Account? ",
                        style: TextStyle(color: Colors.black87, fontSize: 16),
                        children: [
                          TextSpan(
                            text: "Sign Up",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        color: Color(0xFF6E0E0A),
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(6),
        border: const Border(
          bottom: BorderSide(color: Color(0xFF6E0E0A), width: 1.4),
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

