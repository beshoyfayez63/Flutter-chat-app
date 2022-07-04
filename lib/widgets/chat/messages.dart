import 'package:firebase_app/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  final chatCollection = FirebaseFirestore.instance
      .collection('chats')
      .orderBy(
        'createdAt',
        descending: true,
      )
      .snapshots();
  Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: chatCollection,
        builder: (context, AsyncSnapshot<QuerySnapshot> chatSnapShot) {
          if (chatSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final chatDocs = chatSnapShot.data!.docs;
            return ListView.builder(
              reverse: true,
              padding: const EdgeInsets.only(top: 16),
              itemCount: chatDocs.length,
              itemBuilder: (ctx, index) => MessageBubble(
                message: chatDocs[index]['text'],
                isMe: chatDocs[index]['userId'] ==
                    FirebaseAuth.instance.currentUser!.uid,
                userImage: chatDocs[index]['userImage'],
                username: chatDocs[index]['username'],
                key: ValueKey(chatDocs[index].id),
              ),
            );
          }
        });
  }
}
