import 'package:flutter/material.dart';
import 'package:karte_core/karte_core.dart';

class CoreScreen extends StatefulWidget {
  @override
  State<CoreScreen> createState() => _CoreState();
}

class _CoreState extends State<CoreScreen> {
  String _visitorId = 'Unknown';
  bool _isOptOut = false;

  @override
  void initState() {
    super.initState();
    updateState();
    Tracker.view("test");
  }

  void updateState() async {
    String visitorId = await KarteApp.visitorId;
    bool isOptOut = await KarteApp.isOptOut;
    if (!mounted) return;

    setState(() {
      _visitorId = visitorId;
      _isOptOut = isOptOut;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Visitor id:  $_visitorId'),
          Text('isOptOut:  $_isOptOut'),
          RaisedButton(
            onPressed: () => Tracker.track("test", {
              "from": 'Flutter',
            }),
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
              updateState();
            },
            child: Text("optIn"),
          ),
          RaisedButton(
            onPressed: () async {
              KarteApp.optOut();
              updateState();
            },
            child: Text("optOut"),
          ),
          RaisedButton(
            onPressed: () async {
              var url =
                  await UserSync.appendingQueryParameter("https://example.com");
              print("url: $url");
            },
            child: Text("userSync"),
          ),
        ],
      ),
    );
  }
}
