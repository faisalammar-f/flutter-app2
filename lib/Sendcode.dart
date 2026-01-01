import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'verfiycod.dart';

class SendCodePage extends StatefulWidget {
  final String email;
  final String password;

  const SendCodePage({required this.email, required this.password, super.key});

  @override
  State<SendCodePage> createState() => _SendCodePageState();
}

class _SendCodePageState extends State<SendCodePage> {
  // ignore: unused_field
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  bool canResend = true;

  Future<void> sendEmailVerification() async {
    if (!canResend) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⏳ يرجى الانتظار قبل إعادة الإرسال.")),
      );
      return;
    }

    setState(() {
      isLoading = true;
      canResend = false;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("حدث خطأ: المستخدم غير موجود");
      }

      await user.sendEmailVerification();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("📩 تم إرسال رسالة التحقق إلى ${user.email}")),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VerifyCodePage(email: widget.email)),
      );

      Future.delayed(const Duration(seconds: 60), () {
        if (mounted) setState(() => canResend = true);
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ خطأ: $e")));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF121212) // لون داكن
          : const Color(0xFF6A1B9A),
      appBar: AppBar(
        title: Text(
          "Email Verification".tr,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: sendEmailVerification,
                child: Text(
                  "Send Verification Email".tr,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
      ),
    );
  }
}
