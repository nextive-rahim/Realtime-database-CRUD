import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_faq/main.dart';

class AnswerList extends StatefulWidget {
  AnswerList({
    super.key,
    required this.question,
    required this.answer,
    required this.id,
  });
  final String? question;
  String? answer;
  final String? id;

  @override
  State<AnswerList> createState() => _AnswerListState();
}

class _AnswerListState extends State<AnswerList> {
  final editQuestionController = TextEditingController();

  final ref = FirebaseDatabase.instance.ref('faqs');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.question!,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            color: Colors.deepPurple,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showMyDailog(widget.answer!, widget.id!);
            },
            icon: const Icon(
              Icons.edit,
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          widget.answer!,
          style: const TextStyle(fontSize: 17),
        ),
      ),
    );
  }

  Future<void> showMyDailog(String question, String id) async {
    editQuestionController.text = question;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Edit Question"),
            content: TextFormField(
              controller: editQuestionController,
              decoration: InputDecoration(
                hintText: 'Edit Your Question...',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.deepPurple.shade200,
                    width: 2,
                  ), //<-- SEE HERE
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cencle"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ref.child(id).update(
                      {"Answer": editQuestionController.text}).then((value) {
                    setState(() {
                      widget.answer = editQuestionController.text;
                    });
                    scaffoldMessengerKey.currentState!.showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Edidted Question Successfully",
                        ),
                      ),
                    );
                  }).onError((error, stackTrace) {
                    scaffoldMessengerKey.currentState!.showSnackBar(
                      SnackBar(
                        content: Text(
                          error.toString(),
                        ),
                      ),
                    );
                  });
                },
                child: const Text("Update"),
              )
            ],
          );
        });
  }
}
