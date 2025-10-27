import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_24/translation.dart';
import 'package:flutter_application_24/verfiycod.dart';
import 'package:get/get.dart';
import 'signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'task.dart';
import 'Income.dart';
import 'Expenses.dart';
import 'package:firebase_core/firebase_core.dart';

const kPrimaryColor = Color(0xFF6A1B9A);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => prof()),
        ChangeNotifierProvider(create: (context) => exp_provider()),
        ChangeNotifierProvider(create: (context) => income_provider()),
        ChangeNotifierProvider(create: (context) => task_provider()),
        ChangeNotifierProvider(create: (context) => provider_sign()),
      ],

      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: Mylocal(),
      locale: Get.deviceLocale,
      title: 'Smart Plan'.tr,
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kPrimaryColor,
          primary: kPrimaryColor,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // <- خلفية الشاشة
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: kPrimaryColor, // <- خلفية الـ AppBar
          elevation: 4,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          elevation: 8,
          selectedItemColor: kPrimaryColor,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.poppins(),
          type: BottomNavigationBarType.fixed,
        ),
        tabBarTheme: TabBarThemeData(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          indicator: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.poppins(),
        ),
      ),
      // أول صفحة بتظهر هي SplashScreen
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<provider_sign>(context);

    if (provider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (provider.isLoggedIn) {
      return HomePage();
    } else {
      return LoginPage();
    }
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isObscure = true;
  Future<void> _login(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    final FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user != null && user.emailVerified) {
        // 1️⃣ إعداد SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool("isLoggedIn", true);
        await prefs.setString("email", email);

        // 2️⃣ الوصول إلى Provider
        final provider = Provider.of<provider_sign>(context, listen: false);

        // 3️⃣ التحقق من Firestore
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          // ✅ تحميل البيانات الموجودة من Firestore
          final data = doc.data()!;
          await provider.setuserdata(
            full_name: data['fullname'] ?? '',
            email_u: data['email'] ?? email,
            phone_number: data['phonenumber'] ?? '',
            birthofdate:
                DateTime.tryParse(data['dateofbirth'] ?? '') ?? DateTime.now(),
            gender_u: data['gender'] ?? '',
            password_u: provider.password, // ابقِ الباسورد كما هو في Provider
          );

          print('✅ تم تحميل بيانات المستخدم من Firestore بنجاح');
        } else {
          await provider.setuserdata(
            full_name: prefs.getString("fullname") ?? "",
            email_u: email,
            password_u: provider.password,
            phone_number: prefs.getString("phonenumber") ?? "",
            birthofdate:
                DateTime.tryParse(prefs.getString("dateofbirth") ?? "") ??
                DateTime.now(),
            gender_u: prefs.getString("gender") ?? "",
          );

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set(provider.toMap(), SetOptions(merge: true));

          print('☁️ تم رفع بيانات المستخدم إلى Firestore للمرة الأولى');
        }

        // 4️⃣ الانتقال للصفحة الرئيسية
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
        );
      } else if (user != null && !user.emailVerified) {
        // البريد غير مفعل
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("📩 تم إعادة إرسال رسالة التحقق إلى بريدك.".tr),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => VerifyCodePage(email: email)),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = "error_general".tr;
      if (e.code == 'user-not-found') message = "error_user_not_found".tr;
      if (e.code == 'wrong-password') message = "error_wrong_password".tr;
      if (e.code == 'invalid-email') message = "error_invalid_email".tr;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4FACFE), Color(0xFF6E7AFE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.pending_actions,
                          color: Colors.white,
                          size: 35,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "app_title".tr,
                          style: TextStyle(color: Colors.white, fontSize: 40),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Email
                    SizedBox(
                      width: 280,
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          labelText: "email_label".tr,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return "حقل فارغ".tr;
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value))
                            return "ادخل إيميل صحيح".tr;
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: 280,
                      child: TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: isObscure,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                isObscure = !isObscure;
                              });
                            },
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),

                          labelText: "password_label".tr,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return "حقل فارغ".tr;
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // زر Login
                    SizedBox(
                      width: 280,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _login(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6A00), Color(0xFFEE0979)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            child: Text(
                              "login_button".tr,
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Forget Password + Sign Up
                    SizedBox(
                      width: 280,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () async {
                              final provider = Provider.of<provider_sign>(
                                context,
                                listen: false,
                              );
                              final p = Provider.of<prof>(
                                context,
                                listen: false,
                              );

                              // تحقق من كلمة المرور وعرض رسالة فقط
                              if (passwordController.text.isEmpty ||
                                  passwordController.text !=
                                      provider.password) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'الرجاء التأكد من كلمة المرور أولاً',
                                    ),
                                  ),
                                );
                                // لا نضع return هنا → الكود يكمل ويفتح Forget
                              }

                              User? user = FirebaseAuth.instance.currentUser;

                              if (user != null) {
                                await user.reload();
                                if (user.emailVerified) {
                                  p.setemailf(em: emailController.text);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => Forget(),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'الرجاء تفعيل بريدك الإلكتروني أولاً',
                                      ),
                                    ),
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => VerifyCodePage(
                                        email: emailController.text,
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('لم يتم تسجيل الدخول'),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              "forget_password".tr,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => Signu()),
                              );
                            },
                            child: Text(
                              "sign_up".tr,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class prof extends ChangeNotifier {
  String email = "";
  void setemailf({required String em}) {
    email = em;
  }
}

class Forget extends StatefulWidget {
  Forget({super.key});
  State<Forget> createState() => Forgetpass();
}

class Forgetpass extends State<Forget> {
  TextEditingController passcontroller = TextEditingController();
  TextEditingController confpasscontroller = TextEditingController();
  bool isObscure = true;
  GlobalKey<FormState> _k = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forget password:")),
      body: Form(
        key: _k,
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Password
            Text(
              " New Password".tr,
              style: TextStyle(
                color: Color(0xFF444444),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: passcontroller,
              obscureText: isObscure,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    isObscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Password cannot be empty".tr;
                }
                if (value.length < 8) {
                  return "Password must be at least 8 characters".tr;
                }
                if (!RegExp(r'[A-Z]').hasMatch(value)) {
                  return "Must contain at least 1 uppercase letter".tr;
                }
                if (!RegExp(r'[0-9]').hasMatch(value)) {
                  return "Must contain at least 1 number".tr;
                }
                if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
                  return "Must contain at least 1 special character (!@#\$&*~)"
                      .tr;
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            Text(
              "Confirm New Password".tr,
              style: TextStyle(
                color: Color(0xFF444444),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: confpasscontroller,
              obscureText: isObscure,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    isObscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Password cannot be empty".tr;
                }
                if (value != passcontroller.text) {
                  return "Password does not match".tr;
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: 280,
              child: ElevatedButton(
                onPressed: () async {
                  if (_k.currentState!.validate()) {
                    final p = Provider.of<prof>(context, listen: false);
                    final newPassword = passcontroller.text;
                    final email = p.email;

                    final user = FirebaseAuth.instance.currentUser;

                    if (user != null) {
                      try {
                        // نحاول تحديث الباسورد مباشرة
                        await user.updatePassword(newPassword);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم تغيير كلمة المرور بنجاح'),
                          ),
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        // إذا ظهر الخطأ بسبب recent login → نرسل رابط إعادة تعيين
                        if (e.toString().contains('requires-recent-login')) {
                          try {
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                              email: email,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'لم يتم تحديث كلمة المرور مباشرة بسبب أمان الحساب.\nتم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني',
                                ),
                              ),
                            );
                            Navigator.pop(context);
                          } catch (err) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('حدث خطأ: $err')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('حدث خطأ: $e')),
                          );
                        }
                      }
                    } else {
                      // المستخدم غير مسجل دخول → نرسل رابط إعادة تعيين فقط
                      try {
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: email,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني',
                            ),
                          ),
                        );
                        Navigator.pop(context);
                      } catch (err) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('حدث خطأ: $err')),
                        );
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6A00), Color(0xFFEE0979)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    child: Text(
                      "Save".tr,
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
