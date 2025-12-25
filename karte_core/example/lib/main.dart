import 'dart:async';

import 'package:flutter/material.dart';
import 'package:karte_core/karte_core.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

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
                ElevatedButton(
                  onPressed: () => Tracker.track("test"),
                  child: const Text("track"),
                ),
                ElevatedButton(
                  onPressed: () => Tracker.identify({"name": "sample"}),
                  child: const Text("identify"),
                ),
                ElevatedButton(
                  onPressed: () => Tracker.view("test"),
                  child: const Text("view"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    KarteApp.optIn();
                    await initPlatformState();
                  },
                  child: const Text("optIn"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    KarteApp.optOut();
                    await initPlatformState();
                  },
                  child: const Text("optOut"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // ignore: deprecated_member_use
                    var url = await UserSync.appendingQueryParameter(
                        "https://example.com");
                    debugPrint("url: $url");
                  },
                  child: const Text("userSync query(dep)"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    var script = await UserSync.getUserSyncScript();
                    debugPrint("script: $script");
                  },
                  child: const Text("userSync script"),
                ),
              ],
            ),
          )),
    );
  }
}
