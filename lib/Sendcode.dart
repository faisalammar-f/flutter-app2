import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'verfiycod.dart';

class SendCodePage extends StatefulWidget {
  final String email;
  final String password;

  const SendCodePage({required this.email, required this.password, super.key});

  @override
  State<SendCodePage> createState() => _SendCodePageState();
}

class _SendCodePageState extends State<SendCodePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  Future<void> sendEmailVerification() async {
    print("📧 Attempting to verify email: ${widget.email}");
    setState(() => isLoading = true);

    try {
      UserCredential userCred;

      try {
        print("🔹 Trying to create a new user...");
        userCred = await _auth.createUserWithEmailAndPassword(
          email: widget.email,
          password: widget.password,
        );
        print("✅ User created successfully.");
      } on FirebaseAuthException catch (e) {
        print("⚠️ FirebaseAuthException: ${e.code} - ${e.message}");
        if (e.code == 'email-already-in-use') {
          print("🔹 Email already in use, signing in...");
          userCred = await _auth.signInWithEmailAndPassword(
            email: widget.email,
            password: widget.password,
          );
          print("✅ Signed in successfully.");
        } else {
          rethrow;
        }
      }

      User? user = userCred.user;

      if (user == null) {
        print("❌ User is null, cannot send verification email.");
        return;
      }

      if (!user.emailVerified) {
        print("📩 Sending verification email...");
        await user.sendEmailVerification();
        print("✅ Verification email sent to ${user.email}");
      } else {
        print("✅ Email already verified.");
      }

      // الانتقال لصفحة التحقق
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VerifyCodePage(email: widget.email)),
      );
    } catch (e) {
      print("❌ Error during email verification process: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Email Verification")),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: sendEmailVerification,
                child: const Text("Register/Sign In & Verify Email"),
              ),
      ),
    );
  }
}
