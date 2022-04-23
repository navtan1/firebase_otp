import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key}) : super(key: key);

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _topic = TextEditingController();

  String? email;
  String? image;

  void getUserData() async {
    final user = await FirebaseFirestore.instance
        .collection("Users")
        .doc(kFirebaseAuth.currentUser!.uid)
        .get();
    Map<String, dynamic>? getUserData = user.data();
    email = getUserData!['email'];
    image = getUserData['avatar'];

    print('============================$getUserData');
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                    accountEmail:
                        email == null ? const Text("") : Text("$email"),
                    currentAccountPicture: CircleAvatar(
                      radius: 35,
                      backgroundImage: image == null
                          ? NetworkImage(
                              "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/2048px-No_image_available.svg.png")
                          : NetworkImage(image!),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text("Notes"),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     showModalBottomSheet(
        //       isScrollControlled: true,
        //       context: context,
        //       builder: (context)
        //       {
        //         return Container(
        //           padding: EdgeInsets.symmetric(horizontal: Dimansion.width20),
        //           child: SingleChildScrollView(
        //             physics: const BouncingScrollPhysics(),
        //             child: Column(
        //               children: [
        //                 SizedBox(
        //                   height: Dimansion.height45,
        //                 ),
        //                 Row(
        //                   mainAxisAlignment: MainAxisAlignment.end,
        //                   children: [
        //                     GestureDetector(
        //                       onTap: () {
        //                         collectionReference
        //                             .doc(firebaseAuth.currentUser!.uid)
        //                             .collection('notes')
        //                             .add(
        //                           {
        //                             'title': _title.text,
        //                             'notes': _topic.text,
        //                           },
        //                         );
        //                         Navigator.pop(context);
        //                         _title.clear();
        //                         _topic.clear();
        //                       },
        //                       child: const Ts(
        //                         text: "Save",
        //                         weight: FontWeight.bold,
        //                       ),
        //                     ),
        //                     SizedBox(
        //                       width: Dimansion.width20,
        //                     ),
        //                     GestureDetector(
        //                       onTap: () {
        //                         Navigator.pop(context);
        //                       },
        //                       child: const Ts(
        //                         text: "Cancel",
        //                         weight: FontWeight.bold,
        //                       ),
        //                     )
        //                   ],
        //                 ),
        //                 TextFormField(
        //                   controller: _title,
        //                   decoration: const InputDecoration(
        //                     hintText: 'title',
        //                   ),
        //                 ),
        //                 SizedBox(
        //                   height: Dimansion.height45,
        //                 ),
        //                 TextField(
        //                   controller: _topic,
        //                   maxLines: 100,
        //                   decoration: const InputDecoration(
        //                     hintText: 'notes',
        //                     hintMaxLines: 10,
        //                   ),
        //                 )
        //               ],
        //             ),
        //           ),
        //         );
        //       },
        //     );
        //   },
        //   child: const Icon(Icons.add),
        // ),
        body: StreamBuilder(
          stream: collectionReference
              .doc(kFirebaseAuth.currentUser!.uid)
              .collection('notes')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      // ListTile(
                      //   title: Ts(
                      //     text: '${snapshot.data!.docs[index].get('title')}',
                      //   ),
                      //   subtitle: Ts(
                      //     text: '${snapshot.data!.docs[index].get('notes')}',
                      //   ),
                      //   trailing: Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       IconButton(
                      //         onPressed: () {
                      //           collectionReference
                      //               .doc(firebaseAuth.currentUser!.uid)
                      //               .collection('notes')
                      //               .doc(snapshot.data!.docs[index].id)
                      //               .update(
                      //             {
                      //               'title': _title.text,
                      //               'notes': _topic.text,
                      //             },
                      //           );
                      //         },
                      //         icon: const Icon(Icons.edit),
                      //       ),
                      //       SizedBox(
                      //         height: Dimansion.height45,
                      //       ),
                      //       IconButton(
                      //         onPressed: () {
                      //           collectionReference
                      //               .doc(firebaseAuth.currentUser!.uid)
                      //               .collection('notes')
                      //               .doc(snapshot.data!.docs[index].id)
                      //               .delete();
                      //         },
                      //         icon: const Icon(Icons.delete),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  );
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
