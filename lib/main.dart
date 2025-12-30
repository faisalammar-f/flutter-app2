import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_24/ai.dart';
import 'package:flutter_application_24/message.dart';
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
import 'package:awesome_notifications/awesome_notifications.dart';

const kPrimaryColor = Color(0xFF6A1B9A);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeController = Get.put(ThemePro());
  await themeController.loadTheme();
  Mycon c = Get.put(Mycon());
  String savedLang = await c.getSavedLang();
  await Firebase.initializeApp();
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: "tasks_channel",
      channelName: "task reminder",
      channelDescription: "reminder of task",
      importance: NotificationImportance.Max,
      playSound: true,
      enableLights: true,
      enableVibration: true,
    ),
    NotificationChannel(
      channelKey: "messageadmin",
      channelName: "Messages",
      channelDescription: "notifications ",
      importance: NotificationImportance.Max,
      playSound: true,
      enableLights: true,
      enableVibration: true,
    ),
  ], debug: true);

  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => massprov()),
        ChangeNotifierProvider(create: (context) => exp_provider()),
        ChangeNotifierProvider(create: (context) => income_provider()),
        ChangeNotifierProvider(create: (context) => task_provider()),
        ChangeNotifierProvider(create: (context) => provider_sign()),

        ChangeNotifierProvider(
          create: (context) => ai_prov(
            income: context.read<income_provider>(),
            expenses: context.read<exp_provider>(),
          ),
        ),
      ],

      child: MyApp(savedLang: savedLang, themeController: themeController),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String savedLang;
  final ThemePro themeController;

  MyApp({super.key, required this.savedLang, required this.themeController});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: Mylocal(),
      locale: Locale(savedLang),
      title: 'Smart Plan'.tr,
      themeMode: themeController.thememode,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: kPrimaryColor,
          unselectedItemColor: Colors.grey,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle: TextStyle(color: Colors.black),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      theme: ThemeData(
        useMaterial3: false,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(106, 27, 154, 1),
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
  String isadmin = "faisalammar147@gmail.com";
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
        if (user.email == isadmin) {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => adminyou()));
          return;
        }
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
          DateTime birthDate;

          final dob = data['dateofbirth'];

          if (dob is Timestamp) {
            birthDate = dob.toDate();
          } else if (dob is String) {
            birthDate = DateTime.tryParse(dob) ?? DateTime.now();
          } else {
            birthDate = DateTime.now();
          }
          await provider.setuserdata(
            full_name: data['fullname'] ?? '',
            email_u: data['email'] ?? email,
            phone_number: data['phone'] ?? '',
            birthofdate: birthDate,

            gender_u: data['gender'] ?? '',
            password_u: provider.password,
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
        Provider.of<ai_prov>(context, listen: false).init();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(), // انتقل مباشرة
          ),
        );
        // 4️⃣ الانتقال للصفحة الرئيسية
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Theme.of(context).brightness == Brightness.dark
                ? [Colors.grey[900]!, Colors.black]
                : [Color(0xFF4FACFE), Color(0xFF6E7AFE)],
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
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                            fontSize: 40,
                          ),
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
                          fillColor:
                              Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[800]
                              : Colors.white,
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
                          fillColor:
                              Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[800]
                              : Colors.white,
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
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
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
                              final email = emailController.text.trim();

                              if (email.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'الرجاء إدخال البريد الإلكتروني'.tr,
                                    ),
                                  ),
                                );
                                return;
                              }

                              try {
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(email: email);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'تم إرسال رابط إعادة تعيين كلمة المرور'
                                          .tr,
                                    ),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'الإيميل غير صحيح أو غير مسجل'.tr,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              "forget_password".tr,
                              style: TextStyle(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => Signu()),
                              );
                            },
                            child: Text(
                              "sign_up".tr,
                              style: TextStyle(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
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

class ThemePro extends GetxController {
  ThemeMode thememode = ThemeMode.light;
  bool get isDark => thememode == ThemeMode.dark;
  void toggletheme() async {
    thememode = isDark ? ThemeMode.light : ThemeMode.dark;
    Get.changeThemeMode(thememode);
    update();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDark);
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isDarkSaved = prefs.getBool('isDarkMode');
    if (isDarkSaved != null) {
      thememode = isDarkSaved ? ThemeMode.dark : ThemeMode.light;
      update();
    }
  }
}
