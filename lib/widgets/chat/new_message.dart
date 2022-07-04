import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final _sendController = TextEditingController();
  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userData =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    await FirebaseFirestore.instance.collection('chats').add(
      {
        'text': _enteredMessage,
        'createdAt': Timestamp.now(),
        'userId': userId,
        'username': userData['username'],
        'userImage': userData['image_url'],
      },
    );
    setState(() {
      _enteredMessage = '';
    });
    _sendController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _sendController,
              decoration: const InputDecoration(labelText: 'Send a message'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            disabledColor: Colors.grey,
            color: Theme.of(context).primaryColor,
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
            icon: const Icon(Icons.send),
          )
        ],
      ),
    );
  }
}
