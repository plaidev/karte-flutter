import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:karte_core/karte_core.dart';
import 'package:karte_notification/karte_notification.dart' as krt;

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  // Called when received notification on background only Android
  print('myBackgroundMessageHandler $message');
  if (message.containsKey('data')) {
    // Handle data message
    var karteNotification = await krt.Notification.create(message);
    print("karte notification: $karteNotification");
    if (karteNotification != null) {
      karteNotification.handleForAndroid();
    }
  }
}

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<NotificationScreen> {
  String _homeScreenText = "Waiting for token...";
  String _logText = "";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void updateState({String log, String token}) {
    if (!mounted) return;
    setState(() {
      if(log!=null) _logText += log;
      if(token!=null) _homeScreenText = "Push Messaging token: $token";
    });
  }

  @override
  void initState() {
    super.initState();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        // Called when received notification on foreground
        print("onMessage: $message");
        updateState(log: "\nonMessage");
        var karteNotification = await krt.Notification.create(message);
        print("karte notification: $karteNotification");
        if (karteNotification != null) {
          karteNotification.handleForAndroid();
        }
      },
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        // Called when app launch by tap notification on iOS
        print("onLaunch: $message");
        updateState(log: "\nonLaunch");
        var karteNotification = await krt.Notification.create(message);
        print("karte notification: $karteNotification");
        if (karteNotification != null) {
          karteNotification.handleForIOS();
        }
      },
      onResume: (Map<String, dynamic> message) async {
        // Called when app resume by tap notification on iOS
        print("onResume: $message");
        updateState(log: "\nonResume");
        var karteNotification = await krt.Notification.create(message);
        print("karte notification: $karteNotification");
        if (karteNotification != null) {
          karteNotification.handleForIOS();
        }
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.onTokenRefresh.listen((String token) {
      print("onTokenRefreshed: $token");
      krt.Notification.registerFCMToken(token);
      updateState(token: token);
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
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
            RaisedButton(
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
