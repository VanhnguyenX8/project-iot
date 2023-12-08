import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notifications/firebase_options.dart';
import 'package:web_socket_channel/io.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("token : $fcmToken");
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('_firebaseMessagingBackgroundHandler: $message');
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final channel = IOWebSocketChannel.connect('ws://your_server_ip:8080');
  List<dynamic> data = [];
  @override
  void initState() {
    super.initState();
    channel.stream.listen((message) {
      setState(() {
        final decodedMessage = json.decode(message);
        data = List<dynamic>.from(decodedMessage);
        print("data");
      });
    });

    // Gửi yêu cầu lấy dữ liệu khi kết nối WebSocket được thiết lập
    channel.sink.add('getData');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showDialog(
        context: navigatorKey.currentState!.overlay!.context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(message.notification?.title ?? "Thông báo"),
            content: Text(message.notification?.body ?? "Cảnh báo"),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IOT',
      navigatorKey: navigatorKey,
      home: Scaffold(
        appBar: AppBar(title: const Text("Thống kê sản phẩm")),
        body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            // Hiển thị dữ liệu trong ListView hoặc GridView
            var item = data[index];
            return ListTile(
              title: Text(item['user_name']),
              subtitle: Text(item['time_present']),
              // Hiển thị trạng thái dựa trên giá trị của 'is_error'
              leading: CircleAvatar(
                backgroundColor: item['is_error'] ? Colors.red : Colors.green,
              ),
            );
          },
        ),
      ),
    );
  }
}
