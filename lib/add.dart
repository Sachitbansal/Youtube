import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Add extends StatefulWidget {
  const Add({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  final TextEditingController textController = TextEditingController();
  late String trueFalse = 'True';
  final _formKey = GlobalKey<FormState>();
  late String text = 'None';

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference reference =
        FirebaseFirestore.instance.collection(widget.id);

    Object Add() {
      try {
        return reference.add({
          'trueOrFalse': trueFalse,
          'text': text,
        }).then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Uploaded'),
            ),
          ),
        );
      } on FirebaseException catch (e) {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.code),
          ),
        );
      }

    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
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
                      setState(() {
                        trueFalse = 'True';
                      });
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
                      setState(() {
                        trueFalse = 'False';
                      });
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
                  setState(() {
                    text = textController.text;
                  });
                  Add();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
