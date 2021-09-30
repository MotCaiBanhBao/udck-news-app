import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../business_logic/models/notification_model.dart';
import '../business_logic/utils/extension_method.dart';
import 'package:http/http.dart' as http;

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    "high_important_channel",
    "High Important Notifications",
    "This channel is use for important notifications",
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandle(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("A bg message just show up: ${message.messageId} ");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  FirebaseMessaging.onBackgroundMessage(
      (message) => _firebaseMessagingBackgroundHandle(message));

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  firebaseMessaging.getToken();

  firebaseMessaging.subscribeToTopic("test");

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future pushNotification() async {
    var uri = Uri.parse("https://fcm.googleapis.com/fcm/send");
    Map<String, String> header = {
      "Authorization":
          "key=AAAATtDBR_0:APA91bHuOgKgXlimKEUwc8ETPxystztTf4pzCuCHJIgq2v8R_fGELN-JZmN8qwpl0M1UAb98FQJi5_hcrht41TEpZnyySdW982k3du3DBXW1KL3CRbdMr7vfXiguQSKgkrrxG3YvpVgF",
      'Content-Type': 'application/json'
    };
    var response = http
        .post(
          uri,
          body: jsonEncode({
            "notification": {"title": "This is title", "text": "This is text"},
            "to": "/topics/test",
          }),
          headers: header,
        )
        .then((value) => print(value.body));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                    channel.id, channel.name, channel.description,
                    color: Colors.blue,
                    playSound: true,
                    icon: '@mipmap/ic_launcher')));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Text"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            pushNotification();
          },
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("testing").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            return ListView.builder(
              itemBuilder: (context, index) {
                final docData =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;

                return ListTile(
                  title:
                      Text(NotificationX.fromJson(docData).toJon().toString()),
                );
              },
              itemCount: snapshot.data?.docs.length,
            );
          },
        ),
      ),
    );
  }
}
