import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // تأكد أنك أضفت الباكيج

class Income {
  String source;
  double amount;
  DateTime date;
  Income({required this.source, required this.amount, required this.date});
}

class Income_w extends StatefulWidget {
  Income_w({super.key});
  State<Income_w> createState() => Income_app();
}

class Income_app extends State<Income_w> {
  List<String> source_type = [
    "month salary",
    "freelance",
    "trading",
    "investment",
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
                  "Source",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
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
                      value == null ? "Please select a type" : null,
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
                  child: Text("Add Income"),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: prov.i_p.length,
                    itemBuilder: (context, index) {
                      final i = prov.i_p[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 3,
                        child: ListTile(
                          title: Text(
                            "Recent Income",
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
                                  "Source: ${i.source}",
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
                                    title: Text("Edit Income"),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          DropdownButtonFormField<String>(
                                            value: selectedSource,
                                            items: source_type
                                                .map(
                                                  (type) => DropdownMenuItem(
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
                                          prov.removeIncome(
                                            index,
                                          ); // تعديل ليحذف من الـ Provider
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
                                          prov.updateIncome(
                                            index,
                                            Income(
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

class income_provider extends ChangeNotifier {
  List<Income> i_p = [];
  double get_sumincome() {
    double sum = 0.0;

    for (var i in i_p) {
      sum += i.amount;
    }
    return sum;
  }

  List<Income> get get_listincome => i_p;

  void addIncome(Income i) {
    i_p.add(i);
    notifyListeners();
  }

  void removeIncome(int index) {
    i_p.removeAt(index);
    notifyListeners();
  }

  void updateIncome(int index, Income i) {
    i_p[index] = i;
    notifyListeners();
  }
}
