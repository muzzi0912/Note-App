// Import necessary packages

// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:note_app/Screens/Insert.dart';
import 'package:note_app/Screens/Update.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Note App",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        color: Colors.grey[900],
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("notes").snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Lottie.asset('assets/images/not.json'),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                var docId = snapshot.data!.docs[index].id;
                var noteTitle = data['noteTitle'];

                return Card(
                  color: Colors.grey[800],
                  elevation: 5.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      noteTitle,
                      style: TextStyle(
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(
                              () => UpdateScreen(),
                              arguments: {
                                'note': data['note'],
                                'noteTitle':
                                    noteTitle, // Pass noteTitle to UpdateScreen
                                'docId': docId,
                              },
                            )!
                                .then((value) {
                              // Refresh the data on the HomeScreen after updating
                              setState(() {});
                            });
                          },
                          child: Icon(
                            Icons.edit_document,
                            color: Colors.grey[400],
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        GestureDetector(
                          onTap: () async {
                            await FirebaseFirestore.instance
                                .collection("notes")
                                .doc(docId)
                                .delete();
                            // Refresh the data on the HomeScreen after deletion
                            setState(() {});
                          },
                          child: Icon(
                            Icons.delete_rounded,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Get.to(() => CreateNoteScreen());
        },
        child: Icon(
          Icons.add_box_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}
