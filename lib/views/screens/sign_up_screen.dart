import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_auth_app/views/screens/home_screen.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  final GlobalKey<FormState> formKey = GlobalKey();

  String emailAddress = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Image.asset('assets/auth.jpg'),
            ),
            Expanded(
              flex: 1,
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff494CF3),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: TextFormField(
                        onSaved: (newValue) {
                          emailAddress = newValue!;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          labelText: 'Email',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: TextFormField(
                        obscureText: true,
                        onSaved: (newValue) {
                          password = newValue!;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          labelText: 'Password',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: MaterialButton(
                          padding: const EdgeInsets.all(16),
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          color: const Color(0xff494CF3),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              try {
                                await signUp(
                                    emailAddress: emailAddress,
                                    password: password);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                );
                              } on FirebaseAuthException catch (e) {
                                handelFirebaseAuthException(e, context);
                              } catch (e) {
                                log(e.toString());
                              }
                            }
                          },
                          textColor: Colors.white,
                          child: const Text('Register'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handelFirebaseAuthException(
      FirebaseAuthException e, BuildContext context) {
    if (e.code == 'weak-password') {
      log('The password provided is too weak.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'The password provided is too weak.',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Color(0xff494CF3),
        ),
      );
    } else if (e.code == 'email-already-in-use') {
      log('The account already exists for that email.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'The account already exists for that email.',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Color(0xff494CF3),
        ),
      );
    }
  }

  signUp({required String emailAddress, required String password}) async {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
  }
}
