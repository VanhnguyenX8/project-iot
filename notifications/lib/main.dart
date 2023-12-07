import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notifications/empty_page.dart';
import 'package:notifications/page/home_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.instance.getToken().then((value) {
    print("getToken: $value");
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print("onmessage: $message");
    Navigator.pushNamed(navigatorKey.currentState!.context, '/push-page',
        arguments: {"message", json.encode(message.data)});
  });
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      Navigator.pushNamed(
        navigatorKey.currentState!.context,
        '/push-page',
        arguments: {"message", json.encode(message.data)},
      );
    }
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgrounfHander);
  runApp(const MyApp());
}
Future<void> _firebaseMessagingBackgrounfHander(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('_firebaseMessagingBackgrounfHander: $message');
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      routes: {
        '/': ((context) => const EmptyPage()),
        '/push-page': ((context) => HomePage())
      },
      theme: ThemeData(),
      home: const EmptyPage(),
    );
  }
}
