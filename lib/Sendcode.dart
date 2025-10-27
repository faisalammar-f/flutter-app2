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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  bool canResend = true;

  /// 🔄 تحديث المرجع الحالي للمستخدم
  Future<User?> getUpdatedUser() async {
    await _auth.currentUser?.reload();
    return _auth.currentUser;
  }

  Future<void> sendEmailVerification() async {
    if (!canResend) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("⏳ يرجى الانتظار قبل إعادة الإرسال مرة أخرى.".tr),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
      canResend = false;
    });

    try {
      // ignore: unused_local_variable
      UserCredential userCred;

      try {
        // حاول إنشاء حساب جديد
        userCred = await _auth.createUserWithEmailAndPassword(
          email: widget.email,
          password: widget.password,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          // لو الإيميل موجود مسبقًا، قم بتسجيل الدخول مباشرة
          userCred = await _auth.signInWithEmailAndPassword(
            email: widget.email,
            password: widget.password,
          );
        } else {
          rethrow;
        }
      }

      // الحصول على المستخدم المحدث
      final updatedUser = await getUpdatedUser();
      if (updatedUser == null) throw Exception("User not found".tr);

      // إرسال رسالة التحقق لو لم يكن مفعل
      if (!updatedUser.emailVerified) {
        await updatedUser.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "📩 تم إرسال رسالة التحقق إلى ${updatedUser.email}".tr,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("✅ البريد مفعّل مسبقًا".tr)));
      }

      // الانتقال لصفحة التحقق
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
      ).showSnackBar(SnackBar(content: Text("❌ خطأ: $e".tr)));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Email Verification".tr)),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: sendEmailVerification,
                child: Text("Register/Sign In & Verify Email".tr),
              ),
      ),
    );
  }
}
