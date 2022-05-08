import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:youtubefianal/reset_pass.dart';
import 'package:youtubefianal/signin.dart';

import 'home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String email;
  late String pass;
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  late GoogleSignInAccount userObj;

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> login() async {
      try {
        await auth.signInWithEmailAndPassword(email: email, password: pass);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(
              id: FirebaseAuth.instance.currentUser!.uid,
            ),
          ),
        );
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
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal)),
                  hintText: 'password',
                ),
                controller: passController,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) =>
                    value!.length < 6 ? 'Password is too short' : null,
              ),
              TextButton(
                child: const Text('Login'),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    email = emailController.text;
                    pass = passController.text;
                    login();
                  }
                },
              ),
              TextButton(
                child: const Text('Reset Password'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ResetPassword(),
                    ),
                  );
                },
              ),
              TextButton(
                child: const Text('Sign Up'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUp(),
                    ),
                  );
                },
              ),

              const SizedBox(
                height: 30,
              ),
              TextButton(
                child: const Text('Google Sign In'),
                onPressed: () async {

                  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn().then((value) {
                    setState(() {
                      userObj = value!;
                    });
                    return userObj;
                  });

                  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

                  auth.signInWithCredential(GoogleAuthProvider.credential(
                    accessToken: googleAuth.accessToken,
                    idToken: googleAuth.idToken
                  ));

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(
                        id: userObj.id,
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
