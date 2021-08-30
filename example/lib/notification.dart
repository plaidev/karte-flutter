import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:karte_core/karte_core.dart';
import 'package:karte_notification/karte_notification.dart' as krt;

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  // Called when received notification on background only Android
  print('myBackgroundMessageHandler $message');
  var karteNotification = await krt.Notification.create(message);
  print("karte notification: $karteNotification");
  if (karteNotification != null) {
    karteNotification.handleForAndroid();
  }
}

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<NotificationScreen> {
  String _homeScreenText = "Waiting for token...";
  String _logText = "";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void updateState({String? log, String? token}) {
    if (!mounted) return;
    setState(() {
      if (log != null) _logText += log;
      if (token != null) _homeScreenText = "Push Messaging token: $token";
    });
  }

  void checkInitialMessage() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    // Called when app launch by tap notification on iOS
    print("checkInitialMessage: $message");
    updateState(log: "\nonLaunch");
    if (message == null) return;
    var karteNotification = await krt.Notification.create(message);
    print("karte notification: $karteNotification");
    if (karteNotification != null) {
      karteNotification.handleForIOS();
    }
  }

  @override
  void initState() {
    super.initState();

    checkInitialMessage();
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // Called when received notification on foreground
      print("onMessage: $message");
      updateState(log: "\nonMessage");
      var karteNotification = await krt.Notification.create(message);
      print("karte notification: $karteNotification");
      if (karteNotification != null) {
        karteNotification.handleForAndroid();
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      // Called when app resume by tap notification on iOS
      print("onMessageOpenedApp: $message");
      updateState(log: "\nonMessageOpenedApp");
      var karteNotification = await krt.Notification.create(message);
      print("karte notification: $karteNotification");
      if (karteNotification != null) {
        karteNotification.handleForIOS();
      }
    });
    _firebaseMessaging
        .requestPermission(
            alert: true, badge: true, provisional: true, sound: true)
        .then((NotificationSettings value) {
      print("Settings registered: $value");
    });
    _firebaseMessaging.onTokenRefresh.listen((String token) {
      print("onTokenRefreshed: $token");
      krt.Notification.registerFCMToken(token);
      updateState(token: token);
    });
    _firebaseMessaging.getToken().then((String? token) {
      if (token == null) return;
      krt.Notification.registerFCMToken(token);
      updateState(token: token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_homeScreenText),
            ElevatedButton(
              onPressed: () {
                Tracker.view("push_text");
              },
              child: Text("View"),
            ),
            Text(_logText),
          ]),
    );
  }
}
