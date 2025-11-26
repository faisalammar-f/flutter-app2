import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart'; // تأكد أنك أضفت الباكيج
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Expenses {
  String docId;

  String category;
  double amount;
  DateTime date;
  Expenses({
    this.docId = '',

    required this.category,
    required this.amount,
    required this.date,
  });
}

class Expenses_w extends StatefulWidget {
  Expenses_w({super.key});
  State<Expenses_w> createState() => Expenses_app();
}

class Expenses_app extends State<Expenses_w> {
  List<String> categorytype = [
    "Transportation".tr,
    "Tuition fees and materials".tr,
    "Food".tr,
    "Electricity".tr,
    "Rent".tr,
    "Loan".tr,
    "Personal".tr,
    "Social occasions".tr,
  ];
  String? selectedcategory;
  DateTime d = DateTime.now();
  TextEditingController amount_con = TextEditingController();
  TextEditingController date_con = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<exp_provider>(context);

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
                  "Category".tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  items: categorytype
                      .map(
                        (i) =>
                            DropdownMenuItem<String>(child: Text(i), value: i),
                      )
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedcategory = val;
                    });
                  },
                  value: selectedcategory,
                  validator: (value) =>
                      value == null ? "Please select a category".tr : null,
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Field is empty".tr;
                    }
                    final number = double.tryParse(value);

                    if (number! < 0) {
                      return "A negative value cannot be entered".tr;
                    }

                    return null;
                  },
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
                        selectedcategory != null) {
                      prov.addExpense(
                        Expenses(
                          category: selectedcategory!,
                          amount: double.parse(amount_con.text),
                          date: d,
                        ),
                      );
                      amount_con.clear();
                      date_con.clear();
                      selectedcategory = null;
                    }
                  },
                  child: Text("Add Expense".tr),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: StreamBuilder<List<Expenses>>(
                    stream: prov.expensesStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text("No expenses yet".tr));
                      }
                      final expenses = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: expenses.length,
                        itemBuilder: (context, index) {
                          final i = expenses[index];
                          return Card(
                            key: ValueKey(i.docId),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 3,
                            child: ListTile(
                              title: Text(
                                "Recent Expenses".tr,
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
                                      "Category: ${i.category}".tr,
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
                                  String selectedCategory = i.category;
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
                                        title: Text("Edit Expense".tr),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              DropdownButtonFormField<String>(
                                                value: selectedCategory,
                                                items: categorytype
                                                    .map(
                                                      (type) =>
                                                          DropdownMenuItem(
                                                            value: type,
                                                            child: Text(type),
                                                          ),
                                                    )
                                                    .toList(),
                                                onChanged: (val) {
                                                  selectedCategory = val!;
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
                                                onChanged: (value) {
                                                  if (value.isEmpty ||
                                                      double.tryParse(value) ==
                                                          null) {
                                                    print("Field is empty");
                                                  } else if (double.parse(
                                                        value,
                                                      ) <
                                                      0) {
                                                    print(
                                                      "A negative value cannot be entered.",
                                                    );
                                                  }
                                                },
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
                                            onPressed: () {
                                              prov.removeExpense(i);
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
                                            onPressed: () {
                                              prov.updateExpense(
                                                Expenses(
                                                  docId: i
                                                      .docId, // مهم تمرر docId عشان يعرف Firestore أي مستند يعدل
                                                  category: selectedCategory,
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

class exp_provider extends ChangeNotifier {
  List<Expenses> ex_p = [];

  CollectionReference get expensesCollection {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw Exception("User not logged in");
    }
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('expenses');
  }

  Stream<List<Expenses>> get expensesStream {
    return expensesCollection
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            // ignore: unused_local_variable
            final createdAt = data['created_at'] != null
                ? (data['created_at'] as Timestamp).toDate()
                : DateTime.now();
            return Expenses(
              docId: doc.id,
              category: data['category'],
              amount: (data['amount'] as num).toDouble(),
              date: (data['date'] as Timestamp).toDate(),
            );
          }).toList();
        });
  }

  Stream<double> get sumExpenses {
    return allExpenses.map((expenseList) {
      double sum = 0.0;
      for (var e in expenseList) {
        sum += e.amount;
      }
      return sum;
    });
  }

  Stream<List<Expenses>> get allExpenses {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            // ignore: unused_local_variable
            final createdAt = data['created_at'] != null
                ? (data['created_at'] as Timestamp).toDate()
                : DateTime.now();
            return Expenses(
              docId: doc.id,
              category: data['category'] ?? '',
              amount: (data['amount'] ?? 0).toDouble(),
              date: (data['date'] as Timestamp).toDate(),
            );
          }).toList();
        });
  }

  Future<void> removeExpense(Expenses e) async {
    if (e.docId.isEmpty) return;
    await expensesCollection.doc(e.docId).delete();
  }

  Future<void> updateExpense(Expenses e) async {
    if (e.docId.isEmpty) return;
    await expensesCollection.doc(e.docId).update({
      'category': e.category,
      'amount': e.amount,
      'date': e.date,
    });
  }

  Future<void> addExpense(Expenses e) async {
    await expensesCollection.add({
      'category': e.category,
      'amount': e.amount,
      'date': e.date,
      'created_at': FieldValue.serverTimestamp(),
    });
  }
}
