import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  void _submitAuthForm(
    String email,
    String password,
    String username,
    File? userImage,
    bool isLogin,
  ) async {
    UserCredential userCredential;
    setState(() {
      _isLoading = true;
    });
    try {
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child('${userCredential.user!.uid}.jpg');
        await ref.putFile(userImage!);
        final url = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set({
          'username': username,
          'email': email,
          'image_url': url,
        });
      }
      // setState(() {
      //   _isLoading = false;
      // });
    } on PlatformException catch (e) {
      String message = 'An error occured please check your credentials';
      if (e.message != null) message = e.message!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() {
        _isLoading = false;
      });
      // showDialog(
      //   context: context,
      //   builder: (ctx) => const AlertError(errorMsg: 'Something went wrong!'),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        submitAuthForm: _submitAuthForm,
        isLoading: _isLoading,
      ),
    );
  }
}
