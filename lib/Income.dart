import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Income {
  String docId;

  String source;
  double amount;
  DateTime date;
  Income({
    this.docId = '',
    required this.source,
    required this.amount,
    required this.date,
  });
}

class Income_w extends StatefulWidget {
  Income_w({super.key});
  State<Income_w> createState() => Income_app();
}

class Income_app extends State<Income_w> {
  List<String> source_type = [
    "month salary".tr,
    "freelance".tr,
    "trading".tr,
    "investment".tr,
    "business".tr,
    "Granting excellence".tr,
    "Financial need grants".tr,
    "Bonuses & Allowances".tr,
    "Family support".tr,
  ];
  String? selectedsourcetype;
  GlobalKey<FormState> _formkey = GlobalKey();
  TextEditingController amount_con = TextEditingController();
  DateTime d = DateTime.now();
  TextEditingController date_con = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<income_provider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  "Source".tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 18,
                  ),
                ),

                DropdownButtonFormField<String>(
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  items: source_type
                      .map(
                        (i) =>
                            DropdownMenuItem<String>(child: Text(i), value: i),
                      )
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedsourcetype = val;
                    });
                  },
                  value: selectedsourcetype,
                  validator: (value) =>
                      value == null ? "Please select a type".tr : null,
                ),

                const SizedBox(height: 20),
                Text(
                  "Amount".tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: amount_con,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.attach_money),
                    label: Text("0.00"),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Field is empty".tr : null,
                ),
                const SizedBox(height: 20),
                Text(
                  "Date".tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: date_con,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.calendar_today),
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
                  validator: (value) => value == null || value.isEmpty
                      ? " cannot be empty".tr
                      : null,
                  onTap: () async {
                    DateTime? newdate = await showDatePicker(
                      context: context,
                      initialDate: d,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (newdate != null) {
                      setState(() {
                        d = newdate;
                        date_con.text = "${d.day}/${d.month}/${d.year}";
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate() &&
                        amount_con.text.isNotEmpty &&
                        date_con.text.isNotEmpty &&
                        selectedsourcetype != null) {
                      prov.addIncome(
                        Income(
                          source: selectedsourcetype!,
                          amount: double.parse(amount_con.text),
                          date: d,
                        ),
                      );

                      // مسح الحقول
                      amount_con.clear();
                      date_con.clear();
                      selectedsourcetype = null;
                    }
                  },
                  child: Text("Add Income".tr),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: StreamBuilder<List<Income>>(
                    stream: prov.incomeStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Center(child: CircularProgressIndicator());

                      final incomeList = snapshot.data!;

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: incomeList.length,
                        itemBuilder: (context, index) {
                          final i = incomeList[index];

                          return Card(
                            key: ValueKey(i.docId),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 3,
                            child: ListTile(
                              title: Text(
                                "Recent Income".tr,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      "Source: ${i.source}".tr,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Amount: ${i.amount.toStringAsFixed(2)}"
                                          .tr,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      "Date: ${i.date.day}/${i.date.month}/${i.date.year}"
                                          .tr,
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.edit, color: Colors.black),
                                onPressed: () {
                                  TextEditingController amountController =
                                      TextEditingController(
                                        text: i.amount.toString(),
                                      );
                                  String selectedSource = i.source;
                                  DateTime selectedDate = i.date;
                                  TextEditingController
                                  dateController = TextEditingController(
                                    text:
                                        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                                  );

                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Edit Income".tr),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              DropdownButtonFormField<String>(
                                                value: selectedSource,
                                                items: source_type
                                                    .map(
                                                      (type) =>
                                                          DropdownMenuItem(
                                                            value: type,
                                                            child: Text(type),
                                                          ),
                                                    )
                                                    .toList(),
                                                onChanged: (val) {
                                                  selectedSource = val!;
                                                },
                                              ),
                                              const SizedBox(height: 10),
                                              TextField(
                                                controller: amountController,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  labelText: "Amount".tr,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              TextField(
                                                controller: dateController,
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  labelText: "Date".tr,
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
                                                  if (newDate != null) {
                                                    selectedDate = newDate;
                                                    dateController.text =
                                                        "${newDate.day}/${newDate.month}/${newDate.year}";
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              await prov.removeIncome(i);

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
                                              if (i.docId.isEmpty) return;

                                              await prov.updateIncome(
                                                Income(
                                                  docId: i
                                                      .docId, // docId موجود مسبقاً
                                                  source: selectedSource,
                                                  amount:
                                                      double.tryParse(
                                                        amountController.text,
                                                      ) ??
                                                      i.amount,
                                                  date: selectedDate,
                                                ),
                                              );
                                              Navigator.pop(context);
                                            },
                                            child: Text("Save".tr),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
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
      ),
    );
  }
}

class income_provider extends ChangeNotifier {
  List<Income> i_p = [];
  Stream<double> get sumIncome {
    return allIncome.map((incomeList) {
      double sum = 0.0;
      for (var i in incomeList) {
        sum += i.amount;
      }
      return sum;
    });
  }

  Stream<List<Income>> get allIncome {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('income')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            // ignore: unused_local_variable
            final createdAt = data['created_at'] != null
                ? (data['created_at'] as Timestamp).toDate()
                : DateTime.now();
            return Income(
              docId: doc.id,
              source: data['source'] ?? '',
              amount: (data['amount'] ?? 0).toDouble(),
              date: (data['date'] as Timestamp).toDate(),
            );
          }).toList();
        });
  }

  final String userId = FirebaseAuth.instance.currentUser!.uid;

  CollectionReference get incomeCollection => FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('income');

  // جلب البيانات من Firestore

  Stream<List<Income>> get incomeStream {
    return incomeCollection
        .orderBy('created_at', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            // ignore: unused_local_variable
            final createdAt = data['created_at'] != null
                ? (data['created_at'] as Timestamp).toDate()
                : DateTime.now();
            return Income(
              docId: doc.id,
              source: data['source'],
              amount: (data['amount'] as num).toDouble(),
              date: (data['date'] as Timestamp).toDate(),
            );
          }).toList(),
        );
  }

  // إضافة دخل
  Future<void> addIncome(Income i) async {
    // ignore: unused_local_variable
    final docRef = await incomeCollection.add({
      'source': i.source,
      'amount': i.amount,
      'date': i.date,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  // تحديث دخل
  Future<void> updateIncome(Income i) async {
    // ignore: unnecessary_null_comparison
    if (i.docId.isEmpty) return; // تأكد من وجود docId
    await incomeCollection.doc(i.docId).update({
      'source': i.source,
      'amount': i.amount,
      'date': i.date,
    });
  }

  // حذف دخل
  Future<void> removeIncome(Income i) async {
    if (i.docId.isEmpty) return;
    await incomeCollection.doc(i.docId).delete();
  }
}
