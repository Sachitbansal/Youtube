import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  late String email;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    resetPass() async {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email).whenComplete(() {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email Has Been Sent'),
            ),
          );
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No user found with this email'),
            ),
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextFormField(
                  cursorColor: Colors.blue[800],
                  decoration: InputDecoration(
                    fillColor: Colors.blue[50],
                    contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(width: 0.8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(
                        width: 0.8,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    hintText: 'ID',
                    labelText: 'Email ID',
                    prefixIcon: Icon(
                      Icons.account_circle,
                      color: Theme.of(context).primaryColor,
                      // size: 30.0,
                    ),
                  ),
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter an Email';
                    }
                    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                        .hasMatch(value)) {
                      return 'Please Enter a Valid Email';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  child: const Text('Send Email'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        email = emailController.text;
                        resetPass();
                      });
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
