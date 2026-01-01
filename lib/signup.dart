import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Sendcode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Signu extends StatefulWidget {
  const Signu({super.key});

  @override
  State<Signu> createState() => _SignuState();
}

class _SignuState extends State<Signu> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController fullname = TextEditingController();
  final TextEditingController passcontroller = TextEditingController();
  final TextEditingController confpasscontroller = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? gender;
  bool isObscure = true;
  DateTime date = DateTime.now();
  String selectedCountryCode = '+962'; // القيمة الافتراضية (الأردن)
  final List<Map<String, String>> arab_contries = [
    {'name': 'الأردن', 'code': '+962'},
    {'name': 'السعودية', 'code': '+966'},
    {'name': 'مصر', 'code': '+20'},
    {'name': 'الإمارات', 'code': '+971'},
    {'name': 'قطر', 'code': '+974'},
    {'name': 'العراق', 'code': '+964'},
    {'name': 'الكويت', 'code': '+965'},
    {'name': 'لبنان', 'code': '+961'},
    {'name': 'سوريا', 'code': '+963'},
    {'name': 'اليمن', 'code': '+967'},
    {'name': 'الجزائر', 'code': '+213'},
    {'name': 'المغرب', 'code': '+212'},
    {'name': 'تونس', 'code': '+216'},
    {'name': 'ليبيا', 'code': '+218'},
    {'name': 'السودان', 'code': '+249'},
    {'name': 'البحرين', 'code': '+973'},
    {'name': 'عمان', 'code': '+968'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // خلفية متدرجة
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Theme.of(context).brightness == Brightness.dark
                ? [Colors.grey[900]!, Colors.black]
                : [Color(0xFF4FACFE), Color(0xFF6E7AFE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                      "Sign Up".tr,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    // Full Name
                    Text(
                      "Full Name".tr,
                      style: TextStyle(
                        color: Color(0xFF444444),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: fullname,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,

                        labelStyle: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),

                        floatingLabelStyle: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return "empty field".tr;
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Email
                    Text(
                      "Email".tr,
                      style: TextStyle(
                        color: Color(0xFF444444),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: email,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,

                        labelStyle: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),

                        floatingLabelStyle: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return "empty field".tr;
                        if (!EmailValidator.validate(value)) {
                          return "Enter a valid email (e.g. name@example.com)"
                              .tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Password
                    Text(
                      "Password".tr,
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
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
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
                        fillColor: Theme.of(context).colorScheme.surface,

                        labelStyle: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),

                        floatingLabelStyle: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
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

                    // Confirm Password
                    Text(
                      "Confirm Password".tr,
                      style: TextStyle(
                        color: Color(0xFF444444),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: confpasscontroller,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
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
                        fillColor: Theme.of(context).colorScheme.surface,

                        labelStyle: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),

                        floatingLabelStyle: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
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

                    const SizedBox(height: 30),

                    // Phone Number
                    Text(
                      "Phone Number".tr,
                      style: TextStyle(
                        color: Color(0xFF444444),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          child: DropdownButton<String>(
                            value: selectedCountryCode,

                            underline: SizedBox(),
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface, // نص واضح دائمًا
                            ),

                            dropdownColor: Theme.of(
                              context,
                            ).colorScheme.surface, // قائمة واضحة
                            // يخفي الخط السفلي
                            items: arab_contries.map((country) {
                              return DropdownMenuItem<String>(
                                value: country['code'],

                                child: Text(
                                  '${country['name']} (${country['code']})',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedCountryCode = val!;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: phoneController,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "phone number cannot be empty".tr;
                              }
                              return null; // مهم جداً
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface,

                              labelStyle: TextStyle(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),

                              floatingLabelStyle: TextStyle(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              labelText: 'رقم الهاتف'.tr,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Date of Birth".tr,
                      style: TextStyle(
                        color: Color(0xFF444444),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: dateController,
                      keyboardType: TextInputType.datetime,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,

                        labelStyle: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),

                        floatingLabelStyle: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return " cannot be empty".tr;
                        }

                        return null;
                      },
                      onTap: () async {
                        DateTime? newdate = await showDatePicker(
                          context: context,
                          initialDate: date,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (newdate != null) {
                          setState(() {
                            date = newdate;
                            dateController.text =
                                "${date.day}/${date.month}/${date.year}";
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Gender".tr,
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF121212) // لون داكن
                            : Color(0xFF444444),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RadioListTile(
                      value: "Male",
                      title: Text("Male".tr),
                      groupValue: gender,
                      onChanged: (val) {
                        setState(() {
                          gender = val!;
                        });
                      },
                    ),
                    RadioListTile(
                      value: "Female",
                      title: Text("Female".tr),
                      groupValue: gender,
                      onChanged: (val) {
                        setState(() {
                          gender = val!;
                        });
                      },
                    ),

                    // Button
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            UserCredential credential;

                            // محاولة إنشاء حساب جديد
                            try {
                              credential = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                    email: email.text.trim(),
                                    password: passcontroller.text.trim(),
                                  );

                              final user = credential.user;
                              if (user != null) {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .set({
                                      'fullname': fullname.text.trim(),
                                      'email': email.text.trim(),
                                      'phone':
                                          selectedCountryCode +
                                          phoneController.text,
                                      'dateofbirth': date.toIso8601String(),
                                      'gender': gender,
                                      'created_at':
                                          FieldValue.serverTimestamp(),
                                    });
                              }
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'email-already-in-use') {
                                // لو البريد موجود، تسجيل الدخول بدل التسجيل
                                credential = await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                      email: email.text.trim(),
                                      password: passcontroller.text.trim(),
                                    );
                              } else {
                                rethrow;
                              }
                            }

                            final provider1 = Provider.of<provider_sign>(
                              context,
                              listen: false,
                            );
                            await provider1.setuserdata(
                              full_name: fullname.text,
                              email_u: email.text,
                              password_u: passcontroller.text,
                              phone_number:
                                  selectedCountryCode + phoneController.text,
                              birthofdate: date,
                              gender_u: gender!,
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SendCodePage(
                                  email: email.text,
                                  password: passcontroller.text,
                                ),
                              ),
                            );
                          } on FirebaseAuthException catch (e) {
                            String errorMessage;
                            if (e.code == 'weak-password') {
                              errorMessage = '🔐 كلمة المرور ضعيفة جدًا'.tr;
                            } else {
                              errorMessage = '❌ حدث خطأ: ${e.message}';
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(errorMessage.tr)),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('⚠️ خطأ غير متوقع: $e'.tr),
                              ),
                            );
                          }
                        }
                      },

                      child: Text('Sign Up & Verify'.tr),
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

class provider_sign extends ChangeNotifier {
  String fullname = "";
  String email = "";
  String password = "";
  String phonenumber = "";
  DateTime dateofbirth = DateTime.now();
  String gender = "";
  bool isLoggedIn = false;
  bool isLoading = true;

  provider_sign() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    fullname = prefs.getString('fullname') ?? "";
    email = prefs.getString('email') ?? "";
    password = prefs.getString('password') ?? "";
    phonenumber = prefs.getString('phonenumber') ?? "";
    gender = prefs.getString('gender') ?? "";
    final birthString = prefs.getString('dateofbirth');
    if (birthString != null) {
      dateofbirth = DateTime.tryParse(birthString) ?? DateTime.now();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> setuserdata({
    required String full_name,
    required String email_u,
    required String password_u,
    required String phone_number,
    required DateTime birthofdate,
    required String gender_u,
  }) async {
    fullname = full_name;
    email = email_u;
    password = password_u;
    phonenumber = phone_number;
    dateofbirth = birthofdate;
    gender = gender_u;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullname', fullname);
    await prefs.setString('email', email);
    await prefs.setString('password', password);
    await prefs.setString('phonenumber', phonenumber);
    await prefs.setString('gender', gender);
    await prefs.setString('dateofbirth', dateofbirth.toIso8601String());

    notifyListeners();
  }

  Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    isLoggedIn = false;
    fullname = "";
    email = "";
    password = "";
    phonenumber = "";
    gender = "";
    dateofbirth = DateTime.now();
    notifyListeners();
  }

  Future<void> fetchFromFirestore(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        fullname = data['fullname'] ?? '';
        email = data['email'] ?? '';
        phonenumber = data['phone'] ?? '';
        gender = data['gender'] ?? '';

        final dob = data['dateofbirth'];

        if (dob is Timestamp) {
          dateofbirth = dob.toDate();
        } else if (dob is String) {
          dateofbirth = DateTime.tryParse(dob) ?? DateTime.now();
        } else {
          dateofbirth = DateTime.now();
        }
        notifyListeners();

        print('✅ تم تحميل بيانات المستخدم من Firestore بنجاح');
      } else {
        print('⚠️ لا يوجد بيانات للمستخدم في Firestore');
      }
    } catch (e) {
      print('❌ خطأ أثناء تحميل البيانات من Firestore: $e');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'fullname': fullname,
      'email': email,
      'phonenumber': phonenumber,
      'gender': gender,
      'dateofbirth': Timestamp.fromDate(
        dateofbirth,
      ), // تحويل من DateTime → Timestamp
      'createdat': FieldValue.serverTimestamp(),
    };
  }
}
