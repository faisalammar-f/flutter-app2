import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Callender extends StatefulWidget {
  Callender({super.key});
  State<Callender> createState() => Calender();
}

class Calender extends State<Callender> {
  late DateTime date;
  late Timestamp dayOnly;

  @override
  void initState() {
    super.initState();

    date = DateTime.now();
    dayOnly = Timestamp.fromDate(DateTime(date.year, date.month, date.day));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Calendar".tr,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF121212) // لون داكن
            : const Color(0xFF6A1B9A),
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            CalendarDatePicker(
              initialDate: date,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
              onDateChanged: (d) {
                setState(() {
                  date = d;
                });
              },
            ),
            Divider(),

            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection("tasks")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  final filteredDocs = docs.where((d) {
                    DateTime taskDate = (d['date'] as Timestamp).toDate();
                    return taskDate.year == date.year &&
                        taskDate.month == date.month &&
                        taskDate.day == date.day;
                  }).toList();

                  if (filteredDocs.isEmpty) {
                    return Center(
                      child: Text(
                        "لا توجد مهام حاليا".tr,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      var t = filteredDocs[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        margin: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        color: Colors.blue.shade50,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.task,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                  Text(
                                    "Task Today".tr,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Task Title: ".tr,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      t["description"],
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(height: 15),

                                  Text(
                                    "Task Type:".tr,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),

                                  SizedBox(height: 5),

                                  Text(
                                    t["tasktype"],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  SizedBox(height: 15),

                                  Text(
                                    "Deadline:".tr,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),

                                  SizedBox(height: 5),

                                  Text(
                                    (t["date"] as Timestamp)
                                        .toDate()
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: filteredDocs.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
