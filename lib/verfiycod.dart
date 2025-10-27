import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
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
  bool canResend = true;
  String statusMessage =
      "📩 تحقق من بريدك الإلكتروني ثم اضغط على الزر أدناه.".tr;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // بدء التحقق التلقائي كل 2 ثانية
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      checkEmailVerified(auto: true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// ✅ التحقق من حالة التفعيل
  Future<void> checkEmailVerified({bool auto = false}) async {
    try {
      User? user = _auth.currentUser;
      await user?.reload();
      user = _auth.currentUser;

      if (user != null && user.emailVerified) {
        if (!auto) {
          setState(() => isLoading = true);
        }
        _timer?.cancel(); // إيقاف التحقق التلقائي
        setState(() {
          statusMessage = "✅ تم التحقق من البريد بنجاح!".tr;
        });

        // الانتقال إلى الصفحة الرئيسية
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => HomePage()),
          (Route<dynamic> route) => false,
        );
      } else {
        if (!auto) {
          setState(() {
            statusMessage =
                "❌ البريد لم يتم تفعيله بعد. تحقق من الرسالة المرسلة.".tr;
          });
        }
      }
    } catch (e) {
      if (!auto) {
        setState(() {
          statusMessage = "❌ خطأ أثناء التحقق: $e".tr;
        });
      }
    } finally {
      if (!auto) setState(() => isLoading = false);
    }
  }

  /// 📩 إعادة إرسال رسالة التحقق
  Future<void> resendVerificationEmail() async {
    if (!canResend) return;

    setState(() {
      isLoading = true;
      canResend = false;
      statusMessage = "⏳ جاري إرسال رسالة تحقق جديدة...".tr;
    });

    try {
      final user = _auth.currentUser;
      await user?.reload();

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        setState(() {
          statusMessage =
              "📨 تم إرسال رسالة التحقق مرة أخرى إلى ${user.email}".tr;
        });
      } else {
        setState(() {
          statusMessage = "✅ البريد مفعّل بالفعل.".tr;
        });
      }

      // إعادة تمكين الإرسال بعد 60 ثانية
      Future.delayed(const Duration(seconds: 60), () {
        if (mounted) setState(() => canResend = true);
      });
    } catch (e) {
      setState(() {
        statusMessage = "❌ خطأ أثناء إعادة الإرسال: $e".tr;
      });
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Email Verification".tr)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              statusMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            if (isLoading)
              const CircularProgressIndicator()
            else
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => checkEmailVerified(),
                    child: Text("✅ Check Verification".tr),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: resendVerificationEmail,
                    child: Text("📩 Resend Verification Email".tr),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => HomePage()),
                      );
                    },
                    child: Text("⏭️ Skip".tr),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
