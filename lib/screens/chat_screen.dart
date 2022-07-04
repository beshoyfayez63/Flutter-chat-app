// import 'package:firebase_app/widgets/chat/messages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final fbm = FirebaseMessaging.instance;

  void _sendNotitification() async {
    await fbm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((message) {
      return;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      return;
    });
    FirebaseMessaging.onBackgroundMessage((message) async {
      await Firebase.initializeApp();

      return;
    });
    fbm.subscribeToTopic('chats');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sendNotitification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat app'),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                value: 'logout',
                child: Row(
                  children: const [
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              )
            ],
            onChanged: (value) {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Messages(),
          ),
          const NewMessage()
        ],
      ),
    );
  }
}
