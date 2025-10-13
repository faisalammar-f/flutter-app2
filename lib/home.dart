import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'task.dart';
import 'signup.dart';
import 'income&expenes.dart';
import 'package:provider/provider.dart';
import 'Expenses.dart';
import 'Income.dart';
import 'package:fl_chart/fl_chart.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void showEditUserDialog(BuildContext context) {
    final provider = Provider.of<provider_sign>(context, listen: false);

    TextEditingController fullnameController = TextEditingController(
      text: provider.fullname,
    );
    TextEditingController emailController = TextEditingController(
      text: provider.email,
    );
    TextEditingController passwordController = TextEditingController(
      text: provider.password,
    );
    TextEditingController phoneController = TextEditingController(
      text: provider.phonenumber,
    );
    TextEditingController dateController = TextEditingController(
      text:
          "${provider.dateofbirth.day}/${provider.dateofbirth.month}/${provider.dateofbirth.year}",
    );

    String gender = provider.gender;
    DateTime selectedDate = provider.dateofbirth;
    bool isObsecure = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit User Info'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: fullnameController,
                      decoration: const InputDecoration(labelText: 'Full Name'),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: isObsecure,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            isObsecure
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              isObsecure = !isObsecure;
                            });
                          },
                        ),
                      ),
                    ),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                      ),
                    ),
                    TextField(
                      controller: dateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Date of Birth',
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
                            title: const Text('Male'),
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
                            title: const Text('Female'),
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
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    provider.setuserdata(
                      full_name: fullnameController.text,
                      email_u: emailController.text,
                      password_u: passwordController.text,
                      phone_number: phoneController.text,
                      birthofdate: selectedDate,
                      gender_u: gender,
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  int s = 0;
  List<Widget> l = [Home_p(), Taskt(), Inex(), Text("AI Assistant")];

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider1 = Provider.of<provider_sign>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Smart Plan")),
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
                title: Text("Home"),
                onTap: () {
                  if (s == 0) {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                      (Route<dynamic> route) =>
                          false, // Remove all previous routes.
                    );
                  }
                },
              ),
            ),

            Card(
              child: ListTile(
                leading: Icon(Icons.account_box_rounded),
                title: Text("Account"),
                onTap: () {
                  showEditUserDialog(context);
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.miscellaneous_services),
                title: Text("Our Services"),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'Our Services',
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
                              '🎯 Core Services of the App:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Time and Task Management',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "• Create daily and weekly schedules for tasks and classes.",
                            ),
                            Text("• Add, edit, and delete tasks easily."),
                            Text(
                              "• Smart reminders for upcoming tasks and deadlines.",
                            ),
                            Text(
                              "• AI-powered analysis of time usage to suggest ways to improve productivity.",
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Personal Expense Management',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text("• Record daily expenses and income."),
                            Text(
                              "• Categorize expenses (food, transport, books, etc.).",
                            ),
                            Text(
                              "• Display visual reports and charts of spending patterns.",
                            ),
                            Text(
                              "• Provide intelligent financial tips to reduce expenses and manage budgets better.",
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Smart Reminder System',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "• Custom notifications for tasks, expenses, and bills.",
                            ),
                            Text(
                              "• Suggest suitable times for study, rest, or focus based on user schedule.",
                            ),
                            SizedBox(height: 16),
                            Text(
                              'AI-Based Insights and Recommendations 🤖',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text("• Analyze user behavior and habits."),
                            Text(
                              "• Offer personalized suggestions to improve time and money management.",
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "Close",
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
                title: Text("Contact Us"),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.logout_outlined),
                title: Text("Sign Out"),
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
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_available),
            label: "Task & Time Management",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_outlined),
            label: "Income & Expenses",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy),
            label: "AI Assistant",
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
  bool isopen = false;

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
                      final incompletetasks = taskProv.getincomplete_list;
                      int c = incompletetasks.length;

                      return InkWell(
                        onTap: () {
                          showBottomSheet(
                            context: context,
                            builder: (context) => Container(
                              padding: EdgeInsets.all(12),
                              height: 300,
                              color: Colors.white,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: incompletetasks.length,
                                itemBuilder: (context, index) {
                                  final task = incompletetasks[index];
                                  return Card(
                                    margin: EdgeInsets.symmetric(vertical: 6),
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
                                          Text("Type: ${task.tasktype}"),
                                          Text(
                                            "Date: ${task.d.day}/${task.d.month}/${task.d.year} ${task.d.hour}:${task.d.minute}",
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text("تم انجاز المهمة"),
                                              Checkbox(
                                                value: task.isdone,
                                                onChanged: (value) {
                                                  taskProv.toggleTaskDone(
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
                                "Tasks",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "$c",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              Text(
                                "Pending",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Consumer<income_provider>(
                    builder: (context, incomeProv, _) {
                      final sumofincomes = incomeProv.get_listincome;
                      double i = sumofincomes.fold(
                        0,
                        (sum, item) => sum + item.amount,
                      );

                      return InkWell(
                        onTap: () {
                          showBottomSheet(
                            context: context,
                            builder: (context) => Container(
                              padding: EdgeInsets.all(12),
                              height: 300,
                              color: Colors.white,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: sumofincomes.length,
                                itemBuilder: (context, index) {
                                  final item = sumofincomes[index];
                                  return Card(
                                    margin: EdgeInsets.symmetric(vertical: 6),
                                    child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        children: [
                                          Text("Source: ${item.source}"),
                                          Text(
                                            "Amount: ${item.amount.toStringAsFixed(2)}",
                                          ),
                                          Text(
                                            "Date: ${item.date.day}/${item.date.month}/${item.date.year}",
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
                                "Income",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "$i",
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
                  ),
                ),
                Expanded(
                  child: Consumer<exp_provider>(
                    builder: (context, expProv, _) {
                      final sumofexpenses = expProv.get_listexp;
                      double j = sumofexpenses.fold(
                        0,
                        (sum, item) => sum + item.amount,
                      );

                      return InkWell(
                        onTap: () {
                          showBottomSheet(
                            context: context,
                            builder: (context) => Container(
                              padding: EdgeInsets.all(12),
                              height: 300,
                              color: Colors.white,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: sumofexpenses.length,
                                itemBuilder: (context, index) {
                                  final e = sumofexpenses[index];
                                  return Card(
                                    margin: EdgeInsets.symmetric(vertical: 6),
                                    child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        children: [
                                          Text("Category: ${e.category}"),
                                          Text(
                                            "Amount: ${e.amount.toStringAsFixed(2)}",
                                          ),
                                          Text(
                                            "Date: ${e.date.day}/${e.date.month}/${e.date.year}",
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
                                "Expenses",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "$j",
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
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Expenses vs Income",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 250,
              child: Consumer2<income_provider, exp_provider>(
                builder: (context, incomeProv, expProv, _) {
                  double i = incomeProv.get_listincome.fold(
                    0,
                    (sum, item) => sum + item.amount,
                  );
                  double j = expProv.get_listexp.fold(
                    0,
                    (sum, item) => sum + item.amount,
                  );

                  if (i == 0 && j == 0)
                    return Center(child: Text("No data available"));

                  return AspectRatio(
                    aspectRatio: 1, // يحافظ على أن PieChart دائري
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: i > 0 ? i : 0.1,
                            title: "Income",
                            color: Colors.green,
                            radius: 80,
                          ),
                          PieChartSectionData(
                            value: j > 0 ? j : 0.1,
                            title: "Expenses",
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
                    ignoring: isopen, // منع التفاعل إذا كانت الحالة مغلقة
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListTile(
                          leading: Icon(Icons.check, color: Colors.orange),
                          title: Text("Add Task"),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.attach_money,
                            color: Colors.green,
                          ),
                          title: Text("Add Income"),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Icon(Icons.sync, color: Colors.redAccent),
                          title: Text("Add Expense"),
                          onTap: () {},
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
