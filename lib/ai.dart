import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Summary {
  Timestamp lastupdate;
  String advise;
  String topcategory;
  num sumex;
  num sumin;
  Timestamp month;
  Summary({
    required this.advise,
    required this.lastupdate,
    required this.month,
    required this.sumex,
    required this.sumin,
    required this.topcategory,
  });
}

class Ai extends StatefulWidget {
  Ai({super.key});
  State<Ai> createState() => Ai_ass();
}

class Ai_ass extends State<Ai> {
  bool isopen = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI Assistant".tr),
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Smart Insights for you".tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 22,
              ),
            ),
            Text(
              "based on your recent tasks and spending , here are personalized tips: "
                  .tr,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedSuperellipseBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                elevation: 2,
              ),
              icon: Icon(Icons.lightbulb, color: Colors.white, size: 24),
              onPressed: () {
                setState(() {
                  isopen = !isopen;
                });
              },
              label: Text(
                "Get New Suggestions".tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            if (isopen)
              Expanded(
                child: StreamBuilder<Summary?>(
                  stream: ai_prov().summarystream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data == null) {
                      return Center(child: Text("No summary found".tr));
                    }
                    final summary = snapshot.data!;
                    return Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Top Category: ${summary.topcategory}".tr,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Advice: ${summary.advise}".tr,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Total Expense: ${summary.sumex}".tr,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Total Income: ${summary.sumin}".tr,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
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

class ai_prov extends ChangeNotifier {
  DocumentReference get summrydoc {
    final user = FirebaseAuth.instance.currentUser!;
    // ignore: unnecessary_null_comparison
    if (user == null) {
      return FirebaseFirestore.instance
          .collection("users")
          .doc("invalid")
          .collection("analysis")
          .doc("summary");
    }
    return FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("analysis")
        .doc("summary");
  }

  Stream<Summary?> get summarystream {
    final user = FirebaseAuth.instance.currentUser!;
    // ignore: unnecessary_null_comparison
    if (user == null) {
      return const Stream.empty();
    }
    return FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("analysis")
        .doc("summary")
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists) return null;
          final data = snapshot.data() as Map<String, dynamic>;
          return Summary(
            advise: data["advice"] ?? "",
            lastupdate: data["-last_update"] ?? Timestamp.now(),
            month: data["month"] ?? Timestamp.now(),
            sumex: data["total_expense"] ?? 0,
            sumin: data["total_income"] ?? 0,
            topcategory: data["top_category"] ?? "",
          );
        });
  }
}
