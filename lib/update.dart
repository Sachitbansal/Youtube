import 'package:flutter/material.dart';

class Update extends StatefulWidget {
  const Update({Key? key}) : super(key: key);

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update'),
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

                }
              },
            )
          ],
        ),
      ),
    );
  }
}
