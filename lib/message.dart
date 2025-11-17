import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Message {
  String userid;
  String message;
  String replay;
  String id;
  String useremail;
  Timestamp timestamp;
  Message({
    required this.userid,
    required this.message,
    required this.replay,
    this.id = "",
    required this.useremail,
    required this.timestamp,
  });
}

// ignore: must_be_immutable
class Support extends StatelessWidget {
  Support({super.key});

  TextEditingController message = TextEditingController();
  GlobalKey<FormState> _k = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6A1B9A),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Row(
          children: [
            Icon(Icons.chat, size: 20),
            Text(
              "Message me",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _k,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: StreamBuilder<List<Message>>(
                    stream: Provider.of<massprov>(context).messagestream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text("لا توجد رسائل حاليا"));
                      }
                      final mass = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: mass.length,
                        itemBuilder: (context, index) {
                          final m = mass[index];
                          final TextEditingController editController =
                              TextEditingController(text: m.message);
                          return ListTile(
                            trailing: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      title: Text("تعديل / حذف الرسالة"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            controller: editController,
                                            decoration: InputDecoration(
                                              labelText: "الرسالة",
                                              border: OutlineInputBorder(),
                                            ),
                                            maxLines: 3,
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  final newText = editController
                                                      .text
                                                      .trim();
                                                  if (newText.isNotEmpty) {
                                                    final pro =
                                                        Provider.of<massprov>(
                                                          context,
                                                          listen: false,
                                                        );

                                                    await pro.updatemass(
                                                      m,
                                                      newText,
                                                    );
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          "✅ تم تعديل الرسالة بنجاح",
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Text("Save"),
                                              ),
                                              const SizedBox(width: 10),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                ),
                                                onPressed: () async {
                                                  final pro =
                                                      Provider.of<massprov>(
                                                        context,
                                                        listen: false,
                                                      );

                                                  await pro.removemass(m);
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        "🗑️ تم حذف الرسالة بنجاح",
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Text("Delete"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Text(
                                m.message,
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            subtitle: Text(m.replay),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(width: 2)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: message,
                        decoration: InputDecoration(
                          hintText: "Write your message here",
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "cannot be empty";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),

                    TextButton(
                      onPressed: () async {
                        if (_k.currentState!.validate()) {
                          final pro = Provider.of<massprov>(
                            context,
                            listen: false,
                          );
                          final msg = Message(
                            userid: pro.userId,
                            message: message.text.trim(),
                            replay: "",
                            useremail: pro.userEmail,
                            timestamp: Timestamp.now(),
                          );
                          await pro.addmass(msg);
                          message.clear();
                        }
                      },
                      child: Text(
                        "Send",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class massprov extends ChangeNotifier {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  String userEmail = FirebaseAuth.instance.currentUser!.email!;

  CollectionReference get massCollection =>
      FirebaseFirestore.instance.collection("messages");

  Stream<List<Message>> get messagestream {
    return massCollection
        .where("userId", isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Message(
              userid: data["userId"] ?? "",
              message: data["message"] ?? "",
              replay: data["reply"] ?? "",
              id: doc.id,
              useremail: data["userEmail"] ?? "",
              timestamp: data["timestamp"] ?? Timestamp.now(),
            );
          }).toList(),
        );
  }

  Future<void> addmass(Message m) async {
    final docref = await massCollection.add({
      "message": m.message,
      "reply": m.replay,
      "userEmail": userEmail,
      "userId": userId,
      "timestamp": FieldValue.serverTimestamp(),
    });
    m.id = docref.id;
  }

  Future<void> updatemass(Message m, String newm) async {
    if (m.id.isEmpty) return;
    await massCollection.doc(m.id).update({
      "message": newm,
      "timestamp": FieldValue.serverTimestamp(),
    });
    notifyListeners();
  }

  Future<void> updatemassrep(Message m, String newrep) async {
    if (m.id.isEmpty) return;
    await massCollection.doc(m.id).update({"reply": newrep});
    notifyListeners();
  }

  Future<void> removemass(Message m) async {
    if (m.id.isEmpty) return;
    await massCollection.doc(m.id).delete();
  }
}
