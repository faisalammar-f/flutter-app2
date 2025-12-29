import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_24/task.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:provider/provider.dart';

// ====== غيّري هذا المسار حسب مشروعك ======
// ========================================

// ====== Model ======
class ScheduleItem {
  final String day; // Mon / Tue ...
  final String subject; // Networks
  final String timeText; // 10:00-11:30

  ScheduleItem({
    required this.day,
    required this.subject,
    required this.timeText,
  });

  @override
  String toString() => "$day | $timeText | $subject";
}

// ====== Screen ======
class ImportScheduleScreen extends StatefulWidget {
  const ImportScheduleScreen({super.key});

  @override
  State<ImportScheduleScreen> createState() => _ImportScheduleScreenState();
}

class _ImportScheduleScreenState extends State<ImportScheduleScreen> {
  File? _imageFile;
  bool _isLoading = false;
  List<String> _lines = [];

  // ---------- OCR helpers ----------
  String _normalize(String s) {
    var x = s.trim();
    x = x.replaceAll('–', '-').replaceAll('—', '-');
    x = x.replaceAll(RegExp(r'\s+'), ' ');
    x = x.replaceAll('O', '0').replaceAll('o', '0');
    return x;
  }

  Future<Set<String>> _fetchExistingTaskKeys() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};

    final snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .get();

    return snap.docs.map((doc) {
      final data = doc.data();
      final desc = (data['description'] ?? '').toString().trim().toLowerCase();
      final type = (data['tasktype'] ?? '').toString().trim().toLowerCase();

      DateTime dt;
      final rawDate = data['date'];
      if (rawDate is Timestamp) {
        dt = rawDate.toDate();
      } else if (rawDate is DateTime) {
        dt = rawDate;
      } else {
        dt = DateTime(2000);
      }

      final dtKey =
          "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} "
          "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";

      return "$desc|$type|$dtKey";
    }).toSet();
  }

  String _makeKey(String description, String tasktype, DateTime d) {
    final desc = description.trim().toLowerCase();
    final type = tasktype.trim().toLowerCase();
    final dtKey =
        "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')} "
        "${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";
    return "$desc|$type|$dtKey";
  }

  // ignore: unused_element
  Future<void> _autoImportToTasks() async {
    if (_lines.isEmpty) return;

    final items = _parseScheduleLines(_lines);
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(".ما قدرنا نستخرج جدول واضح من الصورة".tr)),
      );
      return;
    }

    final prov = Provider.of<task_provider>(context, listen: false);

    final existingKeys = await _fetchExistingTaskKeys();

    int added = 0;
    int skipped = 0;

    for (final it in items) {
      final dt = _taskDateTime(it);

      // نفس صيغة الوصف اللي عندك
      final desc = "${it.subject} (${it.day} ${it.timeText})";
      final type = "Study".tr;

      // رفض التاريخ الماضي
      if (dt.isBefore(DateTime.now())) {
        skipped++;
        continue;
      }

      // منع التكرار
      final key = _makeKey(desc, type, dt);
      if (existingKeys.contains(key)) {
        skipped++;
        continue;
      }

      await prov.addTask(Tasks(description: desc, tasktype: type, d: dt));

      existingKeys.add(key);
      added++;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("انضاف $added | اترفض $skipped (مكرر/غير صالح)")),
    );
  }

  String? _extractDay(String s) {
    final x = s.toLowerCase();
    if (RegExp(r'\bmon(day)?\b').hasMatch(x)) return "Mon";
    if (RegExp(r'\btue(sday)?\b').hasMatch(x)) return "Tue";
    if (RegExp(r'\bwed(nesday)?\b').hasMatch(x)) return "Wed";
    if (RegExp(r'\bthu(rsday)?\b').hasMatch(x)) return "Thu";
    if (RegExp(r'\bfri(day)?\b').hasMatch(x)) return "Fri";
    if (RegExp(r'\bsat(urday)?\b').hasMatch(x)) return "Sat";
    if (RegExp(r'\bsun(day)?\b').hasMatch(x)) return "Sun";

    if (x.contains('الاثنين') || x.contains('اثنين')) return "Mon";
    if (x.contains('الثلاثاء') || x.contains('ثلاثاء')) return "Tue";
    if (x.contains('الاربعاء') ||
        x.contains('الأربعاء') ||
        x.contains('اربعاء'))
      return "Wed";
    if (x.contains('الخميس')) return "Thu";
    if (x.contains('الجمعة')) return "Fri";
    if (x.contains('السبت')) return "Sat";
    if (x.contains('الاحد') || x.contains('الأحد') || x.contains('احد'))
      return "Sun";
    return null;
  }

  String? _extractTimeRange(String s) {
    final x = s.replaceAll('.', ':');
    final m = RegExp(
      r'(\b\d{1,2}(:\d{2})?\s*(am|pm)?\b)\s*-\s*(\b\d{1,2}(:\d{2})?\s*(am|pm)?\b)',
      caseSensitive: false,
    ).firstMatch(x);
    if (m == null) return null;
    return "${m.group(1)!.trim()}-${m.group(4)!.trim()}";
  }

  String _cleanSubject(String s) {
    var x = s;
    x = x.replaceAll(
      RegExp(
        r'\b(mon(day)?|tue(sday)?|wed(nesday)?|thu(rsday)?|fri(day)?|sat(urday)?|sun(day)?)\b',
        caseSensitive: false,
      ),
      '',
    );
    x = x.replaceAll(
      RegExp(
        r'(الاثنين|الثلاثاء|الأربعاء|الاربعاء|الخميس|الجمعة|السبت|الأحد|الاحد)',
      ),
      '',
    );
    x = x.replaceAll(
      RegExp(
        r'\b\d{1,2}(:\d{2})?\s*(am|pm)?\s*-\s*\d{1,2}(:\d{2})?\s*(am|pm)?\b',
        caseSensitive: false,
      ),
      '',
    );
    x = x
        .replaceAll(RegExp(r'^[\-\•\*]+'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    return x;
  }

  List<ScheduleItem> _parseScheduleLines(List<String> lines) {
    final cleaned = lines.map(_normalize).where((e) => e.isNotEmpty).toList();
    final items = <ScheduleItem>[];
    String? currentDay;
    String? pendingTime;

    for (final raw in cleaned) {
      final d = _extractDay(raw);
      final t = _extractTimeRange(raw);
      if (d != null) currentDay = d;
      if (t != null) pendingTime = t;

      final subject = _cleanSubject(raw);
      final ok =
          currentDay != null &&
          pendingTime != null &&
          subject.length >= 3 &&
          !RegExp(r'^\d+$').hasMatch(subject) &&
          subject.toLowerCase() != 'import study schedule';

      if (ok) {
        items.add(
          ScheduleItem(
            day: currentDay,
            subject: subject,
            timeText: pendingTime,
          ),
        );
        pendingTime = null;
      }
    }
    return items;
  }

  // ---------- Date helpers ----------
  DateTime _dateFromDay(String day) {
    final now = DateTime.now();
    final map = {
      "Mon": DateTime.monday,
      "Tue": DateTime.tuesday,
      "Wed": DateTime.wednesday,
      "Thu": DateTime.thursday,
      "Fri": DateTime.friday,
      "Sat": DateTime.saturday,
      "Sun": DateTime.sunday,
    };
    int diff = map[day]! - now.weekday;
    if (diff < 0) diff += 7;
    return now.add(Duration(days: diff));
  }

  DateTime _taskDateTime(ScheduleItem it) {
    final base = _dateFromDay(it.day);
    final m = RegExp(r'(\d{1,2})').firstMatch(it.timeText);
    final hour = m != null ? int.parse(m.group(1)!) : 8;
    return DateTime(base.year, base.month, base.day, hour);
  }

  // ---------- Actions ----------
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() {
      _imageFile = File(picked.path);
      _lines = [];
    });
    await _processImage(picked.path);
  }

  Future<void> _processImage(String path) async {
    setState(() => _isLoading = true);
    final recognizer = TextRecognizer();
    final input = InputImage.fromFilePath(path);
    final text = await recognizer.processImage(input);
    await recognizer.close();

    final out = <String>[];
    for (final b in text.blocks) {
      for (final l in b.lines) {
        out.add(l.text);
      }
    }

    setState(() {
      _isLoading = false;
      _lines = out;
    });

    await _autoImportToTasks();
  }

  // ignore: unused_element
  void _addToTasks(BuildContext context) {
    final items = _parseScheduleLines(_lines);
    if (items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('ما قدرنا نطلع جدول واضح'.tr)));
      return;
    }

    final tp = Provider.of<task_provider>(context, listen: false);
    for (final it in items) {
      tp.addTask(
        Tasks(
          description: "${it.subject} (${it.day} ${it.timeText})",
          tasktype: "Study".tr,
          d: _taskDateTime(it),
        ),
      );
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('تمت إضافة ${items.length} عناصر')));
    Navigator.pop(context);
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Import Study Schedule'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.upload_file),
                label: Text('Choose a table image'.tr),
              ),
            ),
            const SizedBox(height: 12),

            if (_imageFile != null)
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(_imageFile!, fit: BoxFit.contain),
                ),
              ),

            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(),
              ),

            const SizedBox(height: 8),

            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                ),
                padding: const EdgeInsets.all(8),
                child: _lines.isEmpty
                    ? Text('اختاري صورة جدولك وشوفي النص هون'.tr)
                    : ListView.builder(
                        itemCount: _lines.length,
                        itemBuilder: (_, i) => Text('- ${_lines[i]}'),
                      ),
              ),
            ),

            if (_lines.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.playlist_add),
                  label: Text("Add to Tasks".tr),
                  onPressed: () => _autoImportToTasks(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
