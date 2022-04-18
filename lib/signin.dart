import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String email;
  late String pass;
  late String finalPass;
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final finalPassController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  late GoogleSignInAccount userObj;

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    finalPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> SignUp() async {
      try {
        await auth.createUserWithEmailAndPassword(email: email, password: pass);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Signed In"),
          duration: Duration(milliseconds: 1000),
        ));
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed with code: ${e.code}"),
          duration: const Duration(milliseconds: 1000),
        ));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal)),
                  hintText: 'email',
                ),
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an Email';
                  }
                  if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                      .hasMatch(value)) {
                    return 'Please enter a valid Email';
                  }
                },
              ),
              TextFormField(
                onChanged: (value) {
                  pass = value;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  hintText: 'password',
                ),
                controller: passController,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) =>
                    value!.length < 6 ? 'Password is too short' : null,
              ),
              TextFormField(
                onChanged: (value) {
                  finalPass = value;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal)),
                  hintText: 'Confirm Password',
                ),
                controller: finalPassController,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) {
                  if (value!.length < 6) {
                    return 'Length is short';
                  }
                  if (pass != finalPass) {
                    return 'Passwords do not match';
                  }
                }
              ),
              TextButton(
                child: const Text('Login'),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    email = emailController.text;
                    pass = passController.text;
                    SignUp();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
