import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:karte_core/karte_core.dart';
import 'package:karte_in_app_messaging/karte_in_app_messaging.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isPresenting = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    bool isPresenting;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      isPresenting = await InAppMessaging.isPresenting;
    } on PlatformException {
      isPresenting = false;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _isPresenting = isPresenting;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('KARTE InAppMessaging example app'),
        ),
        body: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('isPresenting:  $_isPresenting'),
              RaisedButton(
                onPressed: () => initPlatformState(),
                child: Text("checkPresent"),
              ),
              RaisedButton(
                onPressed: () => InAppMessaging.dismiss(),
                child: Text("dismiss"),
              ),
              RaisedButton(
                onPressed: () => InAppMessaging.suppress(),
                child: Text("suppress"),
              ),
              RaisedButton(
                onPressed: () => InAppMessaging.unsuppress(),
                child: Text("unsuppress"),
              ),
              RaisedButton(
                onPressed: () => Tracker.view("popup"),
                child: Text("view"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
