import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF121212) // لون داكن
            : const Color(0xFF6A1B9A),
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
              "Message me".tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
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
                        return Center(
                          child: Text(
                            "لا توجد رسائل حاليا".tr,
                            style: TextStyle(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        );
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
                                      title: Text(
                                        "تعديل / حذف الرسالة".tr,
                                        style: TextStyle(
                                          color:
                                              Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            controller: editController,
                                            style: TextStyle(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                            ),
                                            decoration: InputDecoration(
                                              labelText: "الرسالة".tr,
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
                                                          "✅ تم تعديل الرسالة بنجاح"
                                                              .tr,
                                                          style: TextStyle(
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
                                                    );
                                                  }
                                                },
                                                child: Text(
                                                  "Save".tr,
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
                                                        "🗑️ تم حذف الرسالة بنجاح"
                                                            .tr,
                                                        style: TextStyle(
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
                                                  );
                                                },
                                                child: Text(
                                                  "Delete".tr,
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
                                style: const TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 15,
                                ),
                              ),
                            ),

                            subtitle: Text(
                              m.replay,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade800,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
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
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface,

                          labelStyle: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),

                          floatingLabelStyle: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                          hintText: "Write your message here".tr,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "cannot be empty".tr;
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
                            userid: pro.userId!,
                            message: message.text.trim(),
                            replay: "",
                            useremail: pro.userEmail!,
                            timestamp: Timestamp.now(),
                          );
                          await pro.addmass(msg);
                          message.clear();
                        }
                      },
                      child: Text(
                        "Send".tr,
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

class adminyou extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Users".tr,
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
      ),
      body: StreamBuilder(
        stream: massprov().userstream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          final user = snapshot.data!;
          return ListView.builder(
            itemBuilder: (context, Index) {
              final users = user[Index];
              return Card(
                child: ListTile(
                  leading: Icon(Icons.person, size: 40),
                  title: Text(
                    "User: $users",
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => adminSupport(user: users),
                      ),
                    );
                  },
                ),
              );
            },
            itemCount: user.length,
          );
        },
      ),
    );
  }
}

class massprov extends ChangeNotifier {
  String? get userId => FirebaseAuth.instance.currentUser?.uid;

  String? get userEmail => FirebaseAuth.instance.currentUser?.email;

  CollectionReference get massCollection =>
      FirebaseFirestore.instance.collection("messages");

  Stream<List<String>> userstream() {
    return massCollection.snapshots().map((snapshot) {
      final users = snapshot.docs
          .map((doc) => doc['userId'] as String)
          .toSet()
          .toList();
      return users;
    });
  }

  Stream<List<Message>> get messagestream {
    final uid = userId;
    if (uid == null) return const Stream.empty();
    return massCollection
        .where("userId", isEqualTo: uid)
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

  Stream<List<Message>> adminmessagestreamuser(String uid) {
    return massCollection
        .where("userId", isEqualTo: uid)
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

  Stream<List<Message>> get adminmessagestream {
    return massCollection.snapshots().map(
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
    final uid = userId;
    final email = userEmail;
    if (uid == null || email == null) return;
    final docref = await massCollection.add({
      "message": m.message,
      "reply": m.replay,
      "userEmail": email,
      "userId": uid,
      "timestamp": FieldValue.serverTimestamp(),
    });
    m.id = docref.id;
    notifyListeners();
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

  Future<void> deletereply(Message m) async {
    if (m.id.isEmpty) return;

    await massCollection.doc(m.id).update({'reply': null});

    notifyListeners();
  }
}

// ignore: must_be_immutable
class adminSupport extends StatelessWidget {
  final String user;
  adminSupport({super.key, required this.user});
  Message? selectedMessage;

  TextEditingController message = TextEditingController();
  GlobalKey<FormState> _k = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF121212) // لون داكن
            : const Color(0xFF6A1B9A),
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
              "Message me".tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
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
                    stream: Provider.of<massprov>(
                      context,
                    ).adminmessagestreamuser(user),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            "لا توجد رسائل حاليا".tr,
                            style: TextStyle(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        );
                      }
                      final mass = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: mass.length,
                        itemBuilder: (context, index) {
                          final m = mass[index];
                          final TextEditingController editController =
                              TextEditingController(text: m.replay);
                          selectedMessage = m;
                          return ListTile(
                            trailing: Padding(
                              padding: EdgeInsets.only(top: 6),

                              child: Text(
                                m.message,
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 15,
                                ),
                              ),
                            ),

                            subtitle: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      title: Text(
                                        "تعديل / حذف الرسالة".tr,
                                        style: TextStyle(
                                          color:
                                              Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            controller: editController,
                                            style: TextStyle(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                            ),
                                            decoration: InputDecoration(
                                              labelText: "الرسالة".tr,
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

                                                    await pro.updatemassrep(
                                                      m,
                                                      newText,
                                                    );
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          "✅ تم تعديل الرسالة بنجاح"
                                                              .tr,
                                                          style: TextStyle(
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
                                                    );
                                                  }
                                                },
                                                child: Text(
                                                  "Save".tr,
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

                                                  await pro.deletereply(m);
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        "🗑️ تم حذف الرسالة بنجاح"
                                                            .tr,
                                                        style: TextStyle(
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
                                                  );
                                                },
                                                child: Text(
                                                  "Delete".tr,
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
                                m.replay,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey.shade800,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
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
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface,

                          labelStyle: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),

                          floatingLabelStyle: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                          hintText: "Write your message here".tr,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "cannot be empty".tr;
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
                          if (selectedMessage == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "اختر رسالة أولاً للرد عليها".tr,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            );
                            return;
                          }
                          final pro = Provider.of<massprov>(
                            context,
                            listen: false,
                          );

                          await pro.updatemassrep(
                            selectedMessage!,
                            message.text,
                          );
                          message.clear();
                        }
                      },
                      child: Text(
                        "Send".tr,
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
