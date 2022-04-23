import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_otp/view/info_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';

class TodoNotes extends StatefulWidget {
  const TodoNotes({Key? key}) : super(key: key);

  @override
  State<TodoNotes> createState() => _TodoNotesState();
}

class _TodoNotesState extends State<TodoNotes> {
  final _title = TextEditingController();
  final _description = TextEditingController();

  String? email;
  String? image;

  Future getUserData() async {
    final user =
        await collectionReference.doc(kFirebaseAuth.currentUser!.uid).get();

    Map<String, dynamic>? getUserData = user.data();

    email = getUserData!['email'];
    image = getUserData['avatar'];

    print("===============$getUserData");
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Notes"),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: DrawerHeader(
                padding: EdgeInsets.zero,
                child: UserAccountsDrawerHeader(
                  accountName: Text(""),
                  accountEmail: email == null ? Text("") : Text("$email"),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: image == null
                        ? NetworkImage('')
                        : NetworkImage(
                            image!,
                          ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: GestureDetector(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  prefs
                      .remove("Email")
                      .then((value) => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InfoScreen(),
                          )));
                },
                child: ListTile(
                  title: Text(
                    "Log out",
                    style: TextStyle(fontSize: 20),
                  ),
                  trailing: Icon(Icons.logout),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Column(
                  children: [
                    Text('Notes'),
                    TextField(
                      controller: _title,
                      decoration: InputDecoration(hintText: 'Enter Title'),
                    ),
                    TextField(
                      controller: _description,
                      decoration:
                          InputDecoration(hintText: 'Enter Description'),
                    ),
                  ],
                ),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                    color: Colors.redAccent.shade100,
                  ),
                  MaterialButton(
                    onPressed: () {
                      collectionReference
                          .doc(kFirebaseAuth.currentUser!.uid)
                          .collection("notes")
                          .add({
                        "title": _title.text,
                        "description": _description.text
                      });
                      Navigator.pop(context);
                      _title.clear();
                      _description.clear();
                    },
                    child: Text('Add'),
                    color: Colors.greenAccent,
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: collectionReference
              .doc(kFirebaseAuth.currentUser!.uid)
              .collection("notes")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<DocumentSnapshot> info = snapshot.data!.docs;
              return ListView.builder(
                itemCount: info.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("${info[index].get("title")}"),
                    subtitle: Text("${info[index].get("description")}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Column(
                                      children: [
                                        Text('Edit'),
                                        TextField(
                                          controller: _title,
                                          decoration: InputDecoration(
                                              hintText: 'Edit Title'),
                                        ),
                                        TextField(
                                          controller: _description,
                                          decoration: InputDecoration(
                                              hintText: 'Edit Description'),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel'),
                                        color: Colors.redAccent.shade100,
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          collectionReference
                                              .doc(kFirebaseAuth
                                                  .currentUser!.uid)
                                              .collection("notes")
                                              .doc(info[index].id)
                                              .update({
                                            "title": _title.text,
                                            "description": _description.text
                                          });
                                          Navigator.pop(context);
                                          _title.clear();
                                          _description.clear();
                                        },
                                        child: Text('Update'),
                                        color: Colors.greenAccent,
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.edit)),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title:
                                      Text('Do you want to delete this Notes'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('no')),
                                    TextButton(
                                        onPressed: () {
                                          collectionReference
                                              .doc(kFirebaseAuth
                                                  .currentUser!.uid)
                                              .collection("notes")
                                              .doc(info[index].id)
                                              .delete();

                                          Navigator.pop(context);
                                          _title.clear();
                                          _description.clear();
                                        },
                                        child: Text('yes')),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.delete),
                        )
                      ],
                    ),
                  );
                },
              );
            } else {
              return SizedBox();
            }
          },
        ),
      ),
    );
  }
}
