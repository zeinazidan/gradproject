import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'EmployeePage.dart';
import 'onboarding.dart';
import 'HREmployeePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  Future<void> login() async {
    try {
      setState(() => _isLoading = true);

      // Sign in user
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final uid = userCredential.user!.uid;
      final userEmail = userCredential.user!.email ?? "";

      // Fetch user role from Firestore
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!doc.exists || !doc.data()!.containsKey('role')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User role not found.")),
        );
        return;
      }

      final role = doc['role'];

      // Navigate based on role
      if (role == 'new') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingPage()),
        );
      } else if (role == 'employee') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => EmployeePage(userEmail: userEmail), // Pass userEmail here
          ),
        );
      } else if (role == 'hr') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HREmployeePage(userEmail: userEmail),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unknown role.")),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Login failed")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            const Icon(Icons.android, size: 80, color: Colors.blue),
            const SizedBox(height: 16),
            const Text("REBOTA", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Your HR Assistant", style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 40),

            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {}, // TODO: Add forgot password logic if needed
                child: const Text('Forgot Password?'),
              ),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _isLoading ? null : login,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Login", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {}, // Optional: Add home navigation
        ),
      ),
    );
  }
}
