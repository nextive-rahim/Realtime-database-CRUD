import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final questionController = TextEditingController();
  final answerController = TextEditingController();
  bool isLoading = false;
  final databaseRef = FirebaseDatabase.instance.ref('faqs');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Posts',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Question :',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: questionController,
              decoration: InputDecoration(
                hintText: 'Write Your Question...',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.deepPurple.shade200,
                    width: 2,
                  ), //<-- SEE HERE
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Answer :',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: answerController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Write Your Answer...',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.deepPurple.shade200,
                    width: 2,
                  ), //<-- SEE HERE
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  databaseRef.child(id).set({
                    "id": id,
                    'Question': questionController.text,
                    'Answer': answerController.text,
                  }).then((value) {
                    var snackbar =
                        const SnackBar(content: Text('Successfully Added'));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    setState(() {
                      isLoading = false;
                    });
                  }).onError((error, stackTrace) {
                    var snackbar = SnackBar(content: Text(error.toString()));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    setState(() {
                      isLoading = false;
                    });
                  });
                  setState(() {
                    isLoading = false;
                  });
                },
                child: isLoading
                    ? const Center(
                        child: SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      )
                    : const Text('Create Posts'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
