import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Update extends StatefulWidget {
  final String id;
  final String collection;
  const Update({Key? key, required this.id, required this.collection}) : super(key: key);

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {

  final TextEditingController textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    CollectionReference students =
    FirebaseFirestore.instance.collection(widget.collection.toString());

    Future<void> updateUser(id, fText, trueOrFalse) {
      return students
          .doc(id)
          .update({'trueOrFalse': trueOrFalse, 'text': fText})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update'),
      ),
      body: Form(
        key: _formKey,
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection(widget.collection.toString())
              .doc(widget.id)
              .get(),

          builder: (_, snapshot) {
            if (snapshot.hasError) {
              print('Something Went Wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var data = snapshot.data!.data();
            textController.text = data!['text'];
            var trueFalse = data['trueOrFalse'];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: trueFalse == 'True'
                            ? MaterialStateProperty.all<Color>(Colors.green[200]!)
                            : MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: const Text('True'),
                      onPressed: () {
                          trueFalse = 'True';
                      },
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: trueFalse == 'False'
                            ? MaterialStateProperty.all<Color>(Colors.green[200]!)
                            : MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: const Text('False'),
                      onPressed: () {
                          trueFalse = 'False';
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: textController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter a Value';
                    }
                    return null;
                  },
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                ),
                child: const Text(
                  'Add to Firebase',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // var String fText = textController.text;
                    updateUser(widget.id, textController.text, trueFalse);
                    Navigator.pop(context);
                  }
                },
              )
            ],
          );
  }
        ),
      ),
    );
  }
}
