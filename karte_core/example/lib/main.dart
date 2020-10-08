import 'dart:async';

import 'package:flutter/material.dart';
import 'package:karte_core/karte_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _visitorId = 'Unknown';
  bool _isOptOut = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    Tracker.view("test");
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String visitorId = await KarteApp.visitorId;
    bool isOptOut = await KarteApp.isOptOut;

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _visitorId = visitorId;
      _isOptOut = isOptOut;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('KARTE Core example app'),
          ),
          body: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Visitor id:  $_visitorId'),
                Text('isOptOut:  $_isOptOut'),
                RaisedButton(
                  onPressed: () => Tracker.track("test"),
                  child: Text("track"),
                ),
                RaisedButton(
                  onPressed: () => Tracker.identify({"name": "sample"}),
                  child: Text("identify"),
                ),
                RaisedButton(
                  onPressed: () => Tracker.view("test"),
                  child: Text("view"),
                ),
                RaisedButton(
                  onPressed: () async {
                    KarteApp.optIn();
                    await initPlatformState();
                  },
                  child: Text("optIn"),
                ),
                RaisedButton(
                  onPressed: () async {
                    KarteApp.optOut();
                    await initPlatformState();
                  },
                  child: Text("optOut"),
                ),
                RaisedButton(
                  onPressed: () async {
                    var url = await UserSync.appendingQueryParameter(
                        "https://example.com");
                    print("url: $url");
                  },
                  child: Text("userSync"),
                ),
              ],
            ),
          )),
    );
  }
}
