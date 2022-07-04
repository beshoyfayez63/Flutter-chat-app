import 'dart:io';

import '../../widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String username,
    File? userImage,
    bool isLogin,
  ) submitAuthForm;

  bool isLoading;

  AuthForm({required this.isLoading, required this.submitAuthForm, Key? key})
      : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File? _userImage;

  void _pickedImage(File image) {
    _userImage = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (_userImage == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add an image'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    if (isValid == false) return;
    _formKey.currentState?.save();
    widget.submitAuthForm(
      _userEmail.trim(),
      _userPassword.trim(),
      _userName.trim(),
      _userImage,
      _isLogin,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(imagePicked: _pickedImage),
                  TextFormField(
                    key: const ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(labelText: 'Email Address'),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return 'Please enter a valid email.';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('Username'),
                      decoration: const InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 4) {
                          return 'Please enter at least 4 characters.';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        _userName = value!;
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('Password'),
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 6) {
                        return 'Password must be at least 7 characters long.';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                    obscureText: true,
                  ),
                  const SizedBox(height: 12),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 25)),
                      child: Text(_isLogin ? 'Login' : 'Sign up'),
                    ),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  TextButton(
                    style: TextButton.styleFrom(primary: theme.primaryColor),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(
                      _isLogin
                          ? 'Create new account'
                          : 'I already have an account',
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
