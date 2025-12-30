import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_24/ai.dart';
import 'package:flutter_application_24/calender.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'import_schedule_screen.dart';
import 'main.dart';
import 'task.dart';
import 'signup.dart';
import 'income&expenes.dart';
import 'package:provider/provider.dart';
import 'Expenses.dart';
import 'Income.dart';
import 'package:fl_chart/fl_chart.dart';
import 'translation.dart';
import 'message.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void showEditUserDialog(BuildContext context) async {
    final provider = Provider.of<provider_sign>(context, listen: false);

    TextEditingController fullnameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController dateController = TextEditingController();

    late String gender;
    DateTime selectedDate = DateTime.now();
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      phoneController.text = data["phone"] ?? "";
      fullnameController.text = data["fullname"] ?? "";
      emailController.text = data["email"] ?? "";
      gender = data["gender"] ?? "";
      final dob = data["dateofbirth"];

      if (dob is Timestamp) {
        selectedDate = dob.toDate();
        dateController.text =
            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
      } else if (dob is String) {
        selectedDate = DateTime.tryParse(dob) ?? DateTime.now();
        dateController.text =
            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
      } else {
        selectedDate = DateTime.now();
        dateController.text = "";
      }
    }
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit User Info'.tr),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: fullnameController,
                      decoration: InputDecoration(labelText: 'Full Name'.tr),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Email'.tr),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final user = FirebaseAuth.instance.currentUser;

                        if (user == null || user.email == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'حدث خطأ، يرجى إعادة تسجيل الدخول'.tr,
                              ),
                            ),
                          );
                          return;
                        }

                        try {
                          await FirebaseAuth.instance.sendPasswordResetEmail(
                            email: user.email!,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'تم إرسال رابط تغيير كلمة المرور إلى بريدك الإلكتروني'
                                    .tr,
                              ),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('حدث خطأ أثناء إرسال الرابط'.tr),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      child: Text(
                        "change password".tr,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(labelText: 'Phone Number'.tr),
                    ),
                    TextField(
                      controller: dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Date of Birth'.tr,
                      ),
                      onTap: () async {
                        DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );
                        if (newDate != null) {
                          setState(() {
                            selectedDate = newDate;
                            dateController.text =
                                "${newDate.day}/${newDate.month}/${newDate.year}";
                          });
                        }
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: Text('Male'.tr),
                            value: 'Male',
                            groupValue: gender,
                            onChanged: (val) {
                              setState(() {
                                gender = val!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: Text('Female'.tr),
                            value: 'Female',
                            groupValue: gender,
                            onChanged: (val) {
                              setState(() {
                                gender = val!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'.tr),
                ),
                ElevatedButton(
                  onPressed: () async {
                    provider.setuserdata(
                      full_name: fullnameController.text,
                      email_u: emailController.text,
                      password_u: provider.password,
                      phone_number: phoneController.text,
                      birthofdate: selectedDate,
                      gender_u: gender,
                    );
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .set({
                          'fullname': fullnameController.text.trim(),
                          'email': emailController.text.trim(),
                          'phone': phoneController.text,
                          'dateofbirth': Timestamp.fromDate(selectedDate),
                          'gender': gender,
                          'created_at': FieldValue.serverTimestamp(),
                        });
                    Navigator.of(context).pop();
                  },
                  child: Text('Save'.tr),
                ),
              ],
            );
          },
        );
      },
    );
  }

  int s = 0;
  List<Widget> l = [Home_p(), Taskt(), Inex(), Ai()];

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", false);
    Provider.of<ai_prov>(context, listen: false).clearData();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<provider_sign>(context, listen: false);
      Provider.of<task_provider>(context, listen: false);
      Provider.of<income_provider>(context, listen: false);
      Provider.of<exp_provider>(context, listen: false);
    });
  }

  Widget build(BuildContext context) {
    final provider1 = Provider.of<provider_sign>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Smart Plan".tr),
        actions: [
          GetBuilder<ThemePro>(
            builder: (controller) => IconButton(
              onPressed: () {
                controller.toggletheme();
              },
              icon: Icon(
                controller.isDark ? Icons.light_mode : Icons.dark_mode,
              ),
            ),
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            Card(
              color: Colors.deepPurple,
              child: ListTile(
                leading: Icon(Icons.person, size: 40),
                title: Text(provider1.fullname),
                subtitle: Text(provider1.email),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.home),
                title: Text("Home".tr),
                onTap: () {
                  if (s == 0) {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                      (Route<dynamic> route) => false,
                    );
                  }
                },
              ),
            ),

            Card(
              child: ListTile(
                leading: Icon(Icons.account_box_rounded),
                title: Text("Account".tr),
                onTap: () {
                  showEditUserDialog(context);
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.miscellaneous_services),
                title: Text("Our Services".tr),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'Our Services'.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Text(
                              '🎯 Core Services of the App:'.tr,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Time and Task Management'.tr,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "• Create daily and weekly schedules for tasks and classes."
                                  .tr,
                            ),
                            Text("• Add, edit, and delete tasks easily.".tr),
                            Text(
                              "• Smart reminders for upcoming tasks and deadlines."
                                  .tr,
                            ),
                            Text(
                              "• AI-powered analysis of time usage to suggest ways to improve productivity."
                                  .tr,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Personal Expense Management'.tr,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text("• Record daily expenses and income.".tr),
                            Text(
                              "• Categorize expenses (food, transport, books, etc.)."
                                  .tr,
                            ),
                            Text(
                              "• Display visual reports and charts of spending patterns."
                                  .tr,
                            ),
                            Text(
                              "• Provide intelligent financial tips to reduce expenses and manage budgets better."
                                  .tr,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Smart Reminder System'.tr,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "• Custom notifications for tasks, expenses, and bills."
                                  .tr,
                            ),
                            Text(
                              "• Suggest suitable times for study, rest, or focus based on user schedule."
                                  .tr,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'AI-Based Insights and Recommendations 🤖'.tr,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text("• Analyze user behavior and habits.".tr),
                            Text(
                              "• Offer personalized suggestions to improve time and money management."
                                  .tr,
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "Close".tr,
                            style: TextStyle(color: Colors.deepPurple),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.contact_mail),
                title: Text("Contact Us".tr),
                onTap: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => Support()));
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings".tr),
                onTap: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => Lang()));
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.calendar_month),
                title: Text("Calendar".tr),
                onTap: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => Callender()));
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.schedule),
                title: Text('Import Study Schedule'.tr),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ImportScheduleScreen(),
                    ),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.logout_outlined),
                title: Text("Sign Out".tr),
                onTap: () => _logout(context),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: s,
        onTap: (value) {
          setState(() {
            s = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Home".tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_available),
            label: "Task & Time Management".tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_outlined),
            label: "Income & Expenses".tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy),
            label: "AI Assistant".tr,
          ),
        ],
      ),
      body: IndexedStack(index: s, children: l),
    );
  }
}

class Home_p extends StatefulWidget {
  Home_p({super.key});

  @override
  State<Home_p> createState() => _Home_pState();
}

class _Home_pState extends State<Home_p> {
  final GlobalKey<ScaffoldState> _skey = GlobalKey<ScaffoldState>();
  bool isopen = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _skey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Consumer<task_provider>(
                    builder: (context, taskProv, _) {
                      return StreamBuilder<List<Tasks>>(
                        stream: taskProv.incompletetasks,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final incompletetasks = snapshot.data!;
                          int c = incompletetasks.length;

                          return InkWell(
                            onTap: () {
                              showBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                  padding: EdgeInsets.all(12),
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  color: Colors.white,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemCount: incompletetasks.length,
                                    itemBuilder: (context, index) {
                                      final task = incompletetasks[index];
                                      return Card(
                                        margin: EdgeInsets.symmetric(
                                          vertical: 6,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                task.description,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text("Type: ${task.tasktype}".tr),
                                              Text(
                                                "Date: ${task.d.day}/${task.d.month}/${task.d.year} ${task.d.hour}:${task.d.minute}"
                                                    .tr,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text("تم انجاز المهمة".tr),
                                                  Checkbox(
                                                    value: task.isdone,
                                                    onChanged: (value) {
                                                      taskProv.toggleDone(
                                                        task,
                                                        value!,
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 100,
                              margin: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Tasks".tr,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "$c",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                  Text(
                                    "Pending".tr,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                Expanded(
                  child: Consumer<income_provider>(
                    builder: (context, incomeProv, _) {
                      return StreamBuilder<List<Income>>(
                        stream: incomeProv.allIncome, // Stream للقائمة
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return const CircularProgressIndicator();

                          final incomes = snapshot.data!;
                          // نحسب المجموع مباشرة من القائمة
                          final double total = incomes.fold(
                            0,
                            (sum, item) => sum + item.amount,
                          );

                          return InkWell(
                            onTap: () {
                              showBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                  padding: EdgeInsets.all(12),
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  color: Colors.white,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemCount: incomes.length,
                                    itemBuilder: (context, index) {
                                      final item = incomes[index];
                                      return Card(
                                        margin: EdgeInsets.symmetric(
                                          vertical: 6,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Column(
                                            children: [
                                              Text("Source: ${item.source}".tr),
                                              Text(
                                                "Amount: ${item.amount.toStringAsFixed(2)}"
                                                    .tr,
                                              ),
                                              Text(
                                                "Date: ${item.date.day}/${item.date.month}/${item.date.year}"
                                                    .tr,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 100,
                              margin: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Income".tr,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "$total",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Consumer<exp_provider>(
                    builder: (context, expProv, _) {
                      return StreamBuilder<List<Expenses>>(
                        stream: expProv.allExpenses, // Stream من Provider
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return CircularProgressIndicator();

                          final expenses =
                              snapshot.data!; // هذه القائمة الفعلية
                          double totale = expenses.fold(
                            0,
                            (sum, item) => sum + item.amount,
                          );

                          return InkWell(
                            onTap: () {
                              showBottomSheet(
                                context: context,

                                builder: (context) => Container(
                                  padding: EdgeInsets.all(12),
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  color: Colors.white,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemCount: expenses.length,
                                    itemBuilder: (context, index) {
                                      final e = expenses[index];
                                      return Card(
                                        margin: EdgeInsets.symmetric(
                                          vertical: 6,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Category: ${e.category}".tr,
                                              ),
                                              Text(
                                                "Amount: ${e.amount.toStringAsFixed(2)}"
                                                    .tr,
                                              ),
                                              Text(
                                                "Date: ${e.date.day}/${e.date.month}/${e.date.year}"
                                                    .tr,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 100,
                              margin: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Expenses".tr,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "$totale",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Expenses vs Income".tr,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 250,
              child: Consumer2<income_provider, exp_provider>(
                builder: (context, incomeProv, expProv, _) {
                  return StreamBuilder<List<Income>>(
                    stream: incomeProv.allIncome,
                    builder: (context, snapshotIncome) {
                      if (!snapshotIncome.hasData)
                        return CircularProgressIndicator();

                      final incomes = snapshotIncome.data!;
                      double totalIncome = incomes.fold(
                        0,
                        (sum, item) => sum + item.amount,
                      );

                      return StreamBuilder<List<Expenses>>(
                        stream: expProv.allExpenses,
                        builder: (context, snapshotExp) {
                          if (!snapshotExp.hasData)
                            return CircularProgressIndicator();

                          final expenses = snapshotExp.data!;
                          double totalExpenses = expenses.fold(
                            0,
                            (sum, item) => sum + item.amount,
                          );

                          if (totalIncome == 0 && totalExpenses == 0) {
                            return Center(child: Text("No data available".tr));
                          }

                          if (totalExpenses == 0 && totalIncome == 0)
                            return Center(child: Text("No data available".tr));

                          return AspectRatio(
                            aspectRatio: 1, // يحافظ على أن PieChart دائري
                            child: PieChart(
                              PieChartData(
                                sections: [
                                  PieChartSectionData(
                                    value: totalIncome > 0 ? totalIncome : 0.1,
                                    title: "Income".tr,
                                    color: Colors.green,
                                    radius: 80,
                                  ),
                                  PieChartSectionData(
                                    value: totalExpenses > 0
                                        ? totalExpenses
                                        : 0.1,
                                    title: "Expenses".tr,
                                    color: Colors.red,
                                    radius: 80,
                                  ),
                                ],
                                sectionsSpace: 2,
                                centerSpaceRadius: 0,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnimatedContainer(
                  width: isopen ? 200 : 300,
                  height: 200,
                  duration: Duration(seconds: 3),
                  margin: EdgeInsets.only(bottom: 16, right: 16),
                  alignment: isopen ? Alignment.bottomRight : Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IgnorePointer(
                    ignoring: isopen,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListTile(
                          leading: Icon(Icons.check, color: Colors.orange),
                          title: Text("Add Task".tr),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Taskt()),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.attach_money,
                            color: Colors.green,
                          ),
                          title: Text("Add Income".tr),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Inex()),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.sync, color: Colors.redAccent),
                          title: Text("Add Expense".tr),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Inex()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            isopen = !isopen;
          });
        },
      ),
    );
  }
}
