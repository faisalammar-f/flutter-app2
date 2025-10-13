import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Tasks {
  String description;
  String tasktype;
  DateTime d;
  bool isdone;
  Tasks({
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
  List<String> tasktype = ["Work", "Study", "Personal"];
  String? selectedtasktype;
  DateTime d1 = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<task_provider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Task Management"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formkey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Text(
                "Task Title",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: desc_con,
                decoration: InputDecoration(
                  labelText: "Enter task title",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Field is empty" : null,
              ),
              const SizedBox(height: 20),
              Text(
                "Task Type",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(border: OutlineInputBorder()),
                items: tasktype
                    .map((i) => DropdownMenuItem(child: Text(i), value: i))
                    .toList(),
                value: selectedtasktype,
                onChanged: (val) => setState(() => selectedtasktype = val),
                validator: (value) =>
                    value == null ? "Please select a type" : null,
              ),
              const SizedBox(height: 20),
              Text(
                "Due Date",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: date_con,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                  hintText: "Select date & time",
                ),
                validator: (value) => value!.isEmpty ? "Cannot be empty" : null,
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
                child: Text("Add Task"),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: prov.task_p.length,
                itemBuilder: (context, index) {
                  final t = prov.task_p[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                t.description,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
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
                                      title: Text("Edit Task"),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: descController,
                                              decoration: InputDecoration(
                                                labelText: "Description",
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            DropdownButtonFormField<String>(
                                              value: selectedType,
                                              items: tasktype
                                                  .map(
                                                    (type) => DropdownMenuItem(
                                                      value: type,
                                                      child: Text(type),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (val) =>
                                                  selectedType = val!,
                                            ),
                                            const SizedBox(height: 10),
                                            TextField(
                                              controller: dateController,
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                labelText: "Due Date",
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
                                                if (newDate == null) return;

                                                TimeOfDay? newTime =
                                                    await showTimePicker(
                                                      context: context,
                                                      initialTime: TimeOfDay(
                                                        hour: selectedDate.hour,
                                                        minute:
                                                            selectedDate.minute,
                                                      ),
                                                    );
                                                if (newTime == null) return;

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
                                          onPressed: () {
                                            prov.removeTask(index);
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("Cancel"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            prov.updateTask(
                                              index,
                                              Tasks(
                                                description:
                                                    descController.text,
                                                tasktype: selectedType,
                                                d: selectedDate,
                                                isdone: t.isdone,
                                              ),
                                            );
                                            Navigator.pop(context);
                                          },
                                          child: Text("Save"),
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
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Checkbox(
                                value: t.isdone,
                                onChanged: (val) =>
                                    prov.toggleDone(index, val!),
                              ),
                              const Text("تم إنجاز المهمة"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
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
  int getincomplete_count() {
    int count = 0;

    for (var t in task_p) {
      if (t.isdone == false) {
        count++;
      }
    }

    return count;
  }

  List<Tasks> get getincomplete_list {
    return task_p.where((t) => t.isdone == false).toList();
  }

  void toggleTaskDone(Tasks task, bool value) {
    task.isdone = value;
    notifyListeners();
  }

  void addTask(Tasks t) {
    task_p.add(t);
    notifyListeners();
  }

  void updateTask(int index, Tasks t) {
    task_p[index] = t;
    notifyListeners();
  }

  void removeTask(int index) {
    task_p.removeAt(index);
    notifyListeners();
  }

  void toggleDone(int index, bool val) {
    task_p[index].isdone = val;
    notifyListeners();
  }
}
