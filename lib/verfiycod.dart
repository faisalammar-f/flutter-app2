import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';

class VerifyCodePage extends StatefulWidget {
  final String email;

  const VerifyCodePage({required this.email, super.key});

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  String statusMessage = "Please verify your email, then press the button.";

  Future<void> checkEmailVerified() async {
    setState(() {
      isLoading = true;
      statusMessage = "Checking verification...";
    });

    try {
      await _auth.currentUser!.reload();
      bool isVerified = _auth.currentUser!.emailVerified;

      if (isVerified) {
        setState(() {
          statusMessage = "✅ Email verified successfully!";
        });
      } else {
        setState(() {
          statusMessage = "❌ Email not verified yet. Please check your inbox.";
        });
      }
    } catch (e) {
      setState(() {
        statusMessage = "❌ Error verifying email: $e";
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> resendVerificationEmail() async {
    try {
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        setState(() {
          statusMessage = "📩 Verification email re-sent to ${user.email}";
        });
      } else {
        setState(() {
          statusMessage = "✅ Email is already verified.";
        });
      }
    } catch (e) {
      setState(() {
        statusMessage = "❌ Error resending email: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Email")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(statusMessage),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      ElevatedButton(
                        onPressed: checkEmailVerified,
                        child: const Text("Check Verification"),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: resendVerificationEmail,
                        child: const Text("Resend Verification Email"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        },
                        child: const Text("Skip"),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
