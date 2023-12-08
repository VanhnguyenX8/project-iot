import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notifications/bloc/product_bloc.dart';
import 'package:notifications/firebase_options.dart';
import 'package:notifications/model/product.dart';
import 'package:notifications/respositories/products_respository.dart';
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
  late IOWebSocketChannel channel;
  List<dynamic> data = [];
  late Timer timer;
  @override
  void initState() {
    super.initState();
    print("da vao day initSTate");
    connectToWebSocket();
//  timer = Timer.periodic(Duration(seconds: 2), (timer) {
//       getDataFromWebSocket();
//     });
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

  void getDataFromWebSocket() {
    channel.sink.add('getData');
  }

  void connectToWebSocket() {
    print("da vao day connect socket");
    channel = IOWebSocketChannel.connect('ws://192.168.1.3:8080');
    channel.stream.listen((message) {
      print("mes: $message");
      // setState(() {
      //   final decodedMessage = json.decode(message);
      //   data = List<dynamic>.from(decodedMessage);
      //   print("Received data: $data");
      // });
    });

    channel.sink.done.then((_) {
      print('WebSocket closed');
    });

    channel.sink.add('getData');
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("vao ham build");
    return MaterialApp(
      title: 'IOT',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("Thống kê sản phẩm")),
        body: RepositoryProvider(
          create: (context) => ProductRespository(client: Dio()),
          child: BlocProvider(
            create: (context) => ProductsBloc(ProductRespository(client: Dio()))
              ..add(ProductstFetched()),
            child: BlocBuilder<ProductsBloc, ProductsState>(
              builder: (context, state) {
                if (state.status == ProductsStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.status == ProductsStatus.success) {
                  return ListView.builder(
                    itemCount: state.products.length,
                    itemBuilder: ((context, index) {
                      List<Product> products = state.products;
                      return __buildProduct(products[index]);
                    }),
                  );
                }
                if (state.status == ProductsStatus.failure) {
                  return const Center(
                    child: Text('error'),
                  );
                }
                return const Center();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget __buildProduct(Product product) {
    if (product.isError == 1.0) {
      return Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        padding:
            const EdgeInsets.only(left: 30, top: 20, right: 10, bottom: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xffEAF2FF)),
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(product.userName),
            Text(product.timePresent.toString()),
          ],
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        padding:
            const EdgeInsets.only(left: 30, top: 20, right: 10, bottom: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: Colors.red[300]),
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(product.userName),
            Text(product.timePresent.toString()),
          ],
        ),
      );
    }
  }
}
// MaterialApp(
//       title: 'IOT',
//       navigatorKey: navigatorKey,
//       home: Scaffold(
//         appBar: AppBar(title: const Text("Thống kê sản phẩm")),
//         body: ListView.builder(
//           itemCount: data.length,
//           itemBuilder: (context, index) {
//             // Hiển thị dữ liệu trong ListView hoặc GridView
//             var item = data[index];
//             return ListTile(
//               title: Text(item['user_name']),
//               subtitle: Text(item['time_present']),
//               // Hiển thị trạng thái dựa trên giá trị của 'is_error'
//               leading: CircleAvatar(
//                 backgroundColor: item['is_error'] ? Colors.red : Colors.green,
//               ),
//             );
//           },
//         ),
//       ),
//     );