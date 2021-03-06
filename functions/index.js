/* eslint-disable quotes */
/* eslint-disable indent */
const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

exports.sendNotificationMessage = functions.firestore
  .document('chats/{message}')
  .onCreate((snapshot, context) => {
    return admin.messaging().sendToTopic('chats', {
      notification: {
        title: snapshot.data().username,
        body: snapshot.data().text,
      },
    });
  });
