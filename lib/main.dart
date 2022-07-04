import 'package:firebase_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import './screens/chat_screen.dart';
import './screens/auth_screen.dart';
// import './screens/error_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final _intializeFirebase = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _intializeFirebase,
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'Flutter Chat',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(color: Colors.pink),
            primarySwatch: Colors.pink,
            backgroundColor: Colors.pink,
            colorScheme: ThemeData().colorScheme.copyWith(
                  secondary: Colors.deepPurple,
                ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                primary: Colors.pink,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(primary: Colors.deepPurple),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              floatingLabelStyle: TextStyle(color: Colors.pink),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.pink),
              ),
            ),
            progressIndicatorTheme:
                const ProgressIndicatorThemeData(color: Colors.deepPurple),
          ),
          home: snapshot.connectionState != ConnectionState.done
              ? const SplashScreen()
              : StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, userSnapShot) {
                    if (userSnapShot.connectionState ==
                        ConnectionState.waiting) {
                      return const SplashScreen();
                    }
                    if (userSnapShot.hasData) {
                      return const ChatScreen();
                    }
                    return const AuthScreen();
                  },
                ),
        );
      },
    );
  }
}
