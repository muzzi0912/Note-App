// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, file_names, deprecated_member_use, unused_local_variable, avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({Key? key}) : super(key: key);

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  // Backend

  TextEditingController noteController = TextEditingController();

  // Backend

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text(
          "Note App",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        color: Colors.grey[900], // Dark background color
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.grey[800], // Input field background color
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextFormField(
                  controller: noteController,
                  maxLines: null,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Add note",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                // Backend
                var note = noteController.text.trim();

                if (note != "") {
                  try {
                    await FirebaseFirestore.instance.collection("notes").add({
                      "note": note,
                      "created_at": DateTime.now(),
                      "updated_at": DateTime.now()
                    });
                    print("Note saved successfully");

                    // Clear the form
                    noteController.clear();

                    // Navigate back to the home screen
                    Navigator.pop(context);
                  } catch (e) {
                    print("Error: $e");
                  }
                } else {
                  print("Note is empty");
                }
                // Backend
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  "Save",
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
