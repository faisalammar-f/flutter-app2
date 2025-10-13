import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'Sendcode.dart';

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
            colors: [Colors.blue.shade200, Colors.blue.shade600],
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
                      "Sign Up",
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
                      "Full Name",
                      style: TextStyle(
                        color: Color(0xFF444444),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: fullname,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
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
                        if (value!.isEmpty) return "empty field";
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Email
                    Text(
                      "Email",
                      style: TextStyle(
                        color: Color(0xFF444444),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
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
                        if (value!.isEmpty) return "empty field";
                        if (!EmailValidator.validate(value)) {
                          return "Enter a valid email (e.g. name@example.com)";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Password
                    Text(
                      "Password",
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
                          return "Password cannot be empty";
                        }
                        if (value.length < 8) {
                          return "Password must be at least 8 characters";
                        }
                        if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          return "Must contain at least 1 uppercase letter";
                        }
                        if (!RegExp(r'[0-9]').hasMatch(value)) {
                          return "Must contain at least 1 number";
                        }
                        if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
                          return "Must contain at least 1 special character (!@#\$&*~)";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Confirm Password
                    Text(
                      "Confirm Password",
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
                          return "Password cannot be empty";
                        }
                        if (value != passcontroller.text) {
                          return "Password does not match";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 30),

                    // Phone Number
                    Text(
                      "Phone Number",
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
                            color: Colors.white,
                          ),
                          child: DropdownButton<String>(
                            value: selectedCountryCode,
                            underline: SizedBox(), // يخفي الخط السفلي
                            items: arab_contries.map((country) {
                              return DropdownMenuItem<String>(
                                value: country['code'],
                                child: Text(
                                  '${country['name']} (${country['code']})',
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
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "phone number cannot be empty";
                              }
                              return null; // مهم جداً
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'رقم الهاتف',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Date of Birth",
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
                      decoration: InputDecoration(
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
                          return " cannot be empty";
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
                      "Gender",
                      style: TextStyle(
                        color: Color(0xFF444444),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RadioListTile(
                      value: "Male",
                      title: Text("Male"),
                      groupValue: gender,
                      onChanged: (val) {
                        setState(() {
                          gender = val!;
                        });
                      },
                    ),
                    RadioListTile(
                      value: "Female",
                      title: Text("Female"),
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final provider1 = Provider.of<provider_sign>(
                            context,
                            listen: false,
                          );
                          provider1.setuserdata(
                            full_name: fullname.text,
                            email_u: email.text,
                            password_u: passcontroller.text,
                            phone_number:
                                selectedCountryCode + phoneController.text,
                            birthofdate: date,
                            gender_u: gender!,
                          );
                          // Navigate to SendCodePage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SendCodePage(
                                email: email.text,
                                password: passcontroller.text,
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('Sign Up & Verify'),
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

  void setuserdata({
    required String full_name,
    required String email_u,
    required String password_u,
    required String phone_number,
    required DateTime birthofdate,
    required String gender_u,
  }) {
    fullname = full_name;
    email = email_u;
    password = password_u;
    phonenumber = phone_number;
    dateofbirth = birthofdate;
    gender = gender_u;
    notifyListeners();
  }
}
