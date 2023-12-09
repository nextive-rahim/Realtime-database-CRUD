import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_faq/answer_page.dart';
import 'package:flutter_faq/main.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  final questionController = TextEditingController();
  final editQuestionController = TextEditingController();
  final ref = FirebaseDatabase.instance.ref('faqs');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Questions',
          style: TextStyle(color: Colors.white),
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
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: questionController,
                decoration: InputDecoration(
                  hintText: 'Search Your Question...',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.deepPurple.shade200,
                      width: 2,
                    ), //<-- SEE HERE
                  ),
                ),
                onChanged: (value) {
                  questionController.text = value;
                  setState(() {});
                },
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: ref.onValue,
                builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  Map<dynamic, dynamic> map =
                      snapshot.data?.snapshot.value as dynamic;
                  List<dynamic> list = [];
                  list.clear();
                  list = map.values.toList();
                  print(list);
                  return ListView.builder(
                    itemCount: snapshot.data?.snapshot.children.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final title = list[index]['Question'].toString();

                      if (questionController.text.isEmpty) {
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AnswerList(
                                  question: list[index]['Question'].toString(),
                                  answer: list[index]['Answer'].toString(),
                                  id: list[index]['id'].toString(),
                                ),
                              ),
                            );
                          },
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              PopupMenuButton(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        showMyDailog(
                                          title,
                                          list[index]['id'].toString(),
                                        );
                                      },
                                      leading: const Icon(
                                        Icons.edit,
                                        color: Colors.deepPurple,
                                      ),
                                      title: const Text('Edit'),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 2,
                                    child: ListTile(
                                      onTap: () {
                                        ref
                                            .child(list[index]['id'].toString())
                                            .remove();
                                        Navigator.pop(context);
                                      },
                                      leading: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      title: const Text('Delete'),
                                    ),
                                  )
                                ],
                              ),
                              // IconButton(
                              //   padding: EdgeInsets.zero,
                              //   onPressed: () {},
                              //   icon: const Icon(
                              //     Icons.edit,
                              //     color: Colors.deepPurple,
                              //   ),
                              // ),

                              IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.deepPurple,
                                ),
                              ),

                              //Icon(Icons.arrow_forward_ios),
                            ],
                          ),
                          title: Text(list[index]['Question'] ?? ''),
                        );
                      } else if (title.toLowerCase().contains(questionController
                          .text
                          .toLowerCase()
                          .toLowerCase())) {
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AnswerList(
                                  question: list[index]['Question'].toString(),
                                  answer: list[index]['Answer'].toString(),
                                  id: list[index]['id'].toString(),
                                ),
                              ),
                            );
                          },
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              PopupMenuButton(
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.edit,
                                        color: Colors.deepPurple,
                                      ),
                                      title: Text('Edit'),
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      title: Text('Delete'),
                                    ),
                                  )
                                ],
                              ),
                              // IconButton(
                              //   padding: EdgeInsets.zero,
                              //   onPressed: () {},
                              //   icon: const Icon(
                              //     Icons.edit,
                              //     color: Colors.deepPurple,
                              //   ),
                              // ),

                              IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.deepPurple,
                                ),
                              ),

                              //Icon(Icons.arrow_forward_ios),
                            ],
                          ),
                          title: Text(list[index]['Question'] ?? ''),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  );
                },
              ),
            )
          ],
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
                  Navigator.of(context).pop();
                  ref.child(id).update(
                      {"Question": editQuestionController.text}).then((value) {
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
