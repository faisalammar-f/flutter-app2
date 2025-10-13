import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // تأكد أنك أضفت الباكيج

class Expenses {
  String category;
  double amount;
  DateTime date;
  Expenses({required this.category, required this.amount, required this.date});
}

class Expenses_w extends StatefulWidget {
  Expenses_w({super.key});
  State<Expenses_w> createState() => Expenses_app();
}

class Expenses_app extends State<Expenses_w> {
  List<String> categorytype = [
    "Transportation",
    "Food",
    "Electricity",
    "Rent",
    "Loan",
    "Personal",
    "Social occasions",
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
                  "Category",
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
                      value == null ? "Please select a category" : null,
                ),
                const SizedBox(height: 20),
                Text(
                  "Amount",
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
                      value!.isEmpty ? "Field is empty" : null,
                ),
                const SizedBox(height: 20),
                Text(
                  "Date",
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
                      ? " cannot be empty"
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
                  child: Text("Add Expense"),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: prov.ex_p.length,
                    itemBuilder: (context, index) {
                      final i = prov.ex_p[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 3,
                        child: ListTile(
                          title: Text(
                            "Recent Expenses",
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
                                  "Category: ${i.category}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Amount: ${i.amount.toStringAsFixed(2)}",
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "Date: ${i.date.day}/${i.date.month}/${i.date.year}",
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
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
                                    title: Text("Edit Expense"),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          DropdownButtonFormField<String>(
                                            value: selectedCategory,
                                            items: categorytype
                                                .map(
                                                  (type) => DropdownMenuItem(
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
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: "Amount",
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          TextField(
                                            controller: dateController,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              labelText: "Date",
                                              suffixIcon: Icon(
                                                Icons.calendar_today,
                                              ),
                                            ),
                                            onTap: () async {
                                              DateTime? newDate =
                                                  await showDatePicker(
                                                    context: context,
                                                    initialDate: selectedDate,
                                                    firstDate: DateTime(2000),
                                                    lastDate: DateTime(2100),
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
                                          prov.removeExpense(index);
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Cancel"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          prov.updateExpense(
                                            index,
                                            Expenses(
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
                                        child: Text("Save"),
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
  double get_sumexp() {
    double sum = 0.0;

    for (var i in ex_p) {
      sum += i.amount;
    }
    return sum;
  }

  List<Expenses> get get_listexp => ex_p;

  void addExpense(Expenses e) {
    ex_p.add(e);
    notifyListeners();
  }

  void removeExpense(int index) {
    ex_p.removeAt(index);
    notifyListeners();
  }

  void updateExpense(int index, Expenses e) {
    ex_p[index] = e;
    notifyListeners();
  }
}
