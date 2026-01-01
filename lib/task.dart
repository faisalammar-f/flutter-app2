import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'import_schedule_screen.dart';

class Tasks {
  String docId;

  String description;
  String tasktype;
  DateTime d;
  bool isdone;
  Tasks({
    this.docId = '',

    required this.description,
    required this.tasktype,
    required this.d,
    this.isdone = false,
  });
}

class Taskt extends StatefulWidget {
  Taskt({super.key});
  @override
  State<Taskt> createState() => Ttasktype();
}

class Ttasktype extends State<Taskt> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  final TextEditingController desc_con = TextEditingController();
  final TextEditingController date_con = TextEditingController();
  List<String> tasktype = [
    "Work".tr,
    "Study".tr,
    "Personal".tr,
    "Free time".tr,
    "Social occasions".tr,
    "Attend lectures".tr,
    "Complete assignments".tr,
    "Prepare presentations".tr,
    "Submit reports".tr,
    "Group study sessions".tr,
    "Project research".tr,
    "Team meetings".tr,
    "Daily exercise".tr,
    "Plan weekly schedule".tr,
    "Call family/friends".tr,
    "Review work emails".tr,
    "Work on internship tasks".tr,
  ];

  String? selectedtasktype;
  DateTime d1 = DateTime.now();
  void deletetaskexpired() async {
    DateTime now = DateTime.now();
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("tasks")
        .get();
    for (var doc in snapshot.docs) {
      final d = (doc['date'] as Timestamp).toDate();
      if (now.isAfter(d)) {
        await doc.reference.delete();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    deletetaskexpired();
  }

  Widget build(BuildContext context) {
    final prov = Provider.of<task_provider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Task Management".tr), centerTitle: true),
      floatingActionButton: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ImportScheduleScreen()),
          );
        },
        icon: Icon(Icons.camera_alt),
        label: Text(
          "Import Study Schedule".tr,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formkey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Text(
                "Task Title".tr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: desc_con,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  labelText: "Enter task title".tr,
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
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Field is empty".tr : null,
              ),
              const SizedBox(height: 20),
              Text(
                "Task Type".tr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
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
                  border: OutlineInputBorder(),
                ),
                items: tasktype
                    .map(
                      (i) => DropdownMenuItem(
                        child: Text(
                          i,
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        value: i,
                      ),
                    )
                    .toList(),
                value: selectedtasktype,
                onChanged: (val) => setState(() => selectedtasktype = val),
                validator: (value) =>
                    value == null ? "Please select a type".tr : null,
              ),
              const SizedBox(height: 20),
              Text(
                "Due Date".tr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: date_con,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                readOnly: true,
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
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                  hintText: "Select date & time".tr,
                ),
                validator: (value) =>
                    value!.isEmpty ? "Cannot be empty".tr : null,
                onTap: () async {
                  DateTime? newd = await showDatePicker(
                    context: context,
                    initialDate: d1,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (newd == null) return;

                  TimeOfDay? newt = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: d1.hour, minute: d1.minute),
                  );
                  if (newt == null) return;

                  final DateTime d2 = DateTime(
                    newd.year,
                    newd.month,
                    newd.day,
                    newt.hour,
                    newt.minute,
                  );
                  setState(() {
                    d1 = d2;
                    date_con.text =
                        "${d1.day}/${d1.month}/${d1.year} ${d1.hour.toString().padLeft(2, '0')}:${d1.minute.toString().padLeft(2, '0')}";
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formkey.currentState!.validate() &&
                      selectedtasktype != null) {
                    DateTime now = DateTime.now();

                    if (d1.isBefore(now)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Cannot add task with past date".tr),
                        ),
                      );
                      return;
                    }
                    prov.addTask(
                      Tasks(
                        description: desc_con.text,
                        tasktype: selectedtasktype!,
                        d: d1,
                      ),
                    );

                    desc_con.clear();
                    date_con.clear();
                    setState(() => selectedtasktype = null);
                  }
                },
                child: Text(
                  "Add Task".tr,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height:
                    MediaQuery.of(context).size.height * 0.6, // أو حسب الحاجة
                child: StreamBuilder<List<Tasks>>(
                  stream:
                      prov.taskStream, // <- هنا استخدم الـ Stream من provider
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text("لا توجد مهام حالياً".tr));
                    }

                    final tasks = snapshot.data!;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final t = tasks[index];

                        return Card(
                          key: ValueKey(t.docId),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        t.description,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        TextEditingController descController =
                                            TextEditingController(
                                              text: t.description,
                                            );
                                        String selectedType = t.tasktype;
                                        DateTime selectedDate = t.d;
                                        TextEditingController
                                        dateController = TextEditingController(
                                          text:
                                              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year} ${selectedDate.hour.toString().padLeft(2, '0')}:${selectedDate.minute.toString().padLeft(2, '0')}",
                                        );

                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text(
                                              "Edit Task".tr,
                                              style: TextStyle(
                                                color:
                                                    Theme.of(
                                                          context,
                                                        ).brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    controller: descController,
                                                    style: TextStyle(
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.onSurface,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          "Description".tr,
                                                      filled: true,
                                                      fillColor: Theme.of(
                                                        context,
                                                      ).colorScheme.surface,

                                                      labelStyle: TextStyle(
                                                        color:
                                                            Theme.of(
                                                                  context,
                                                                ).brightness ==
                                                                Brightness.dark
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),

                                                      floatingLabelStyle:
                                                          TextStyle(
                                                            color:
                                                                Theme.of(
                                                                      context,
                                                                    ).brightness ==
                                                                    Brightness
                                                                        .dark
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                    ),
                                                  ),
                                                  Text(
                                                    "Task Type".tr,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      color:
                                                          Theme.of(
                                                                context,
                                                              ).brightness ==
                                                              Brightness.dark
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  DropdownButtonFormField<
                                                    String
                                                  >(
                                                    value: selectedType,
                                                    style: TextStyle(
                                                      color:
                                                          Theme.of(
                                                                context,
                                                              ).brightness ==
                                                              Brightness.dark
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: Theme.of(
                                                        context,
                                                      ).colorScheme.surface,

                                                      labelStyle: TextStyle(
                                                        color:
                                                            Theme.of(
                                                                  context,
                                                                ).brightness ==
                                                                Brightness.dark
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),

                                                      floatingLabelStyle:
                                                          TextStyle(
                                                            color:
                                                                Theme.of(
                                                                      context,
                                                                    ).brightness ==
                                                                    Brightness
                                                                        .dark
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                    ),
                                                    items: tasktype
                                                        .map(
                                                          (type) =>
                                                              DropdownMenuItem(
                                                                value: type,
                                                                child: Text(
                                                                  type,
                                                                ),
                                                              ),
                                                        )
                                                        .toList(),
                                                    onChanged: (val) =>
                                                        selectedType = val!,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  TextField(
                                                    controller: dateController,
                                                    style: TextStyle(
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.onSurface,
                                                    ),
                                                    readOnly: true,
                                                    decoration: InputDecoration(
                                                      labelText: "Due Date".tr,
                                                      filled: true,
                                                      fillColor: Theme.of(
                                                        context,
                                                      ).colorScheme.surface,

                                                      labelStyle: TextStyle(
                                                        color:
                                                            Theme.of(
                                                                  context,
                                                                ).brightness ==
                                                                Brightness.dark
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),

                                                      floatingLabelStyle:
                                                          TextStyle(
                                                            color:
                                                                Theme.of(
                                                                      context,
                                                                    ).brightness ==
                                                                    Brightness
                                                                        .dark
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                      suffixIcon: Icon(
                                                        Icons.calendar_today,
                                                      ),
                                                    ),
                                                    onTap: () async {
                                                      DateTime? newDate =
                                                          await showDatePicker(
                                                            context: context,
                                                            initialDate:
                                                                selectedDate,
                                                            firstDate: DateTime(
                                                              2000,
                                                            ),
                                                            lastDate: DateTime(
                                                              2100,
                                                            ),
                                                          );
                                                      if (newDate == null)
                                                        return;

                                                      TimeOfDay? newTime =
                                                          await showTimePicker(
                                                            context: context,
                                                            initialTime: TimeOfDay(
                                                              hour: selectedDate
                                                                  .hour,
                                                              minute:
                                                                  selectedDate
                                                                      .minute,
                                                            ),
                                                          );
                                                      if (newTime == null)
                                                        return;

                                                      selectedDate = DateTime(
                                                        newDate.year,
                                                        newDate.month,
                                                        newDate.day,
                                                        newTime.hour,
                                                        newTime.minute,
                                                      );
                                                      dateController.text =
                                                          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year} ${selectedDate.hour.toString().padLeft(2, '0')}:${selectedDate.minute.toString().padLeft(2, '0')}";
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .doc(
                                                        FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid,
                                                      )
                                                      .collection('tasks')
                                                      .doc(t.docId)
                                                      .delete();
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Delete".tr,
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text("Cancel".tr),
                                              ),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .doc(
                                                        FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid,
                                                      )
                                                      .collection('tasks')
                                                      .doc(t.docId)
                                                      .update({
                                                        'description':
                                                            descController.text,
                                                        'tasktype':
                                                            selectedType,
                                                        'date': selectedDate,
                                                        'isdone': t.isdone,
                                                      });
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Save".tr),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "${t.tasktype} | ${t.d.day}/${t.d.month}/${t.d.year} ${t.d.hour.toString().padLeft(2, '0')}:${t.d.minute.toString().padLeft(2, '0')}",
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),

                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: t.isdone,
                                      onChanged: (val) async {
                                        if (val == null) return;

                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid,
                                            )
                                            .collection('tasks')
                                            .doc(t.docId)
                                            .update({'isdone': val});

                                        setState(() {
                                          t.isdone = val;
                                        });
                                      },
                                    ),
                                    Text(
                                      "تم إنجاز المهمة".tr,
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
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
        ),
      ),
    );
  }
}

class task_provider extends ChangeNotifier {
  List<Tasks> task_p = [];
  CollectionReference get taskCollection {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks');
  }

  // جلب المهام من Firestore
  Stream<int> get incompleteCount {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tasks')
        .where('isdone', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<List<Tasks>> get incompletetasks {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .where('isdone', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>? ?? {};

            return Tasks(
              docId: doc.id,
              description: data['description'] ?? '',
              tasktype: data['tasktype'] ?? '',
              d: (data['date'] as Timestamp)
                  .toDate(), // ✅ كمان لازم تتأكد إنها "date" مش "d"
              isdone: data['isdone'] ?? false,
            );
          }).toList();
        });
  }

  Stream<List<Tasks>> get allTasks {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tasks')
        // ترتيب حسب التاريخ مثلاً (اختياري)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();

            return Tasks(
              docId: doc.id,
              description: data['description'] ?? '',
              tasktype: data['tasktype'] ?? '',
              d: (data['d'] as Timestamp).toDate(),
              isdone: data['isdone'] ?? false,
            );
          }).toList();
        });
  }

  Stream<List<Tasks>> get taskStream {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();
    return FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("tasks")
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            // ignore: unnecessary_cast
            final data = doc.data() as Map<String, dynamic>;

            return Tasks(
              docId: doc.id,
              description: data['description'],
              tasktype: data['tasktype'],
              d: (data['date'] as Timestamp).toDate(),
              isdone: data['isdone'] ?? false,
            );
          }).toList(),
        );
  }

  // إضافة مهمة
  Future<void> addTask(Tasks t) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final taskCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tasks');
    DateTime now = DateTime.now();

    if (t.d.isBefore(now)) {
      throw Exception("Cannot add task with past date");
    }
    final docRef = await taskCollection.add({
      'description': t.description,
      'tasktype': t.tasktype,
      'date': t.d,
      'isdone': t.isdone,
      'created_at': FieldValue.serverTimestamp(),
    });
    t.docId = docRef.id;
    DateTime date = t.d;
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: date.millisecondsSinceEpoch ~/ 1000,
        channelKey: "tasks_channel",
        body: t.tasktype,
        title: " تذكير مهمة:  ${t.description}  ",
      ),
      schedule: NotificationCalendar(
        year: date.year,
        month: date.month,
        day: date.day,
        hour: date.hour,
        minute: date.minute,
        second: 0,
        repeats: false,
        preciseAlarm: true,
      ),
    );
  }

  // تحديث مهمة
  Future<void> updateTask(Tasks t) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final taskCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tasks');
    if (t.docId.isEmpty) return;
    await taskCollection.doc(t.docId).update({
      'description': t.description,
      'tasktype': t.tasktype,
      'date': t.d,
      'isdone': t.isdone,
    });
  }

  // حذف مهمة

  Future<void> removeTask(Tasks t) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final taskCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tasks');
    if (t.docId.isEmpty) return;
    await taskCollection.doc(t.docId).delete();
  }

  // تبديل حالة المهمة
  Future<void> toggleDone(Tasks t, bool val) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final taskCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tasks');
    if (t.docId.isEmpty) return;
    await taskCollection.doc(t.docId).update({'isdone': val});
  }
}
