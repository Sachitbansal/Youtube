import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  List<XFile>? _image;
  final imagePicker = ImagePicker();
  List<String> downloadURL = [];
  List<String> urls = [];
  var isLoading = false;
  int uploadItem = 0;
  UploadTask? uploadTask;

  Future imagePickerMethod() async {
    final pick = await imagePicker.pickMultiImage();
    setState(() {
      if (pick != null) {
        _image = pick;
      } else {
        showSnackBar("No File selected", const Duration(milliseconds: 400));
      }
    });
  }

  void uploadFunction(List<XFile> images) async {
    setState(() {
      isLoading = true;
    });
    for (int i = 0; i < images.length; i++) {
      var imgUrl = await uploadFile(images[i]);
      urls.add(imgUrl.toString());
    }

    add().whenComplete(() {
      urls.clear();
      setState(() {
        isLoading = true;
      });
    });
  }

  Future<String> uploadFile(XFile images) async {
    final imgId = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance
        .ref()
        .child(widget.id.toString())
        .child("post_$imgId");
    uploadTask = reference.putFile(File(images.path));
    await uploadTask?.whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
    // print(await reference.getDownloadURL());
    return await reference.getDownloadURL();
  }

  Future<void> add() {
    final CollectionReference reference =
        FirebaseFirestore.instance.collection(widget.id);
    return reference.add({
      'trueOrFalse': trueFalse,
      'text': text,
      'image': urls
    }).then(
      (value) => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Uploaded'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add'),
      ),
      body: isLoading ? const Center(child: CircularProgressIndicator(),) : Form(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue[200]!),
                    alignment: Alignment.center,
                  ),
                  onPressed: imagePickerMethod,
                  child: const SizedBox(
                    height: 40,
                    width: 350,
                    child: Center(
                      child: Text(
                        'Pick Images',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              child: const Text(
                'Add to FireBase',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    text = textController.text;
                    uploadFunction(_image!);
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
