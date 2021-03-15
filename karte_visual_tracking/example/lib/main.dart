import 'package:flutter/material.dart';
import 'package:karte_visual_tracking/karte_visual_tracking.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey _globalKey = GlobalKey();
  GlobalKey _globalKey2 = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('KARTE VisualTracking example app'),
        ),
        body: Center(
          child: Column(
            children: [
              RepaintBoundary(
                key: _globalKey,
                child: RaisedButton(
                  onPressed: () async {
                    VisualTracking.handle("touch", "test_target_text",
                        "test_action_id", _globalKey);
                  },
                  child: Text("handle with image1"),
                ),
              ),
              RepaintBoundary(
                key: _globalKey2,
                child: RaisedButton(
                  onPressed: () async {
                    VisualTracking.handle("touch", "test_target_text2",
                        "test_action_id2", _globalKey2);
                  },
                  child: Text("handle with image2"),
                ),
              ),
              RaisedButton(
                onPressed: () async {
                  VisualTracking.handle(
                      "touch", "test_target_text3", "test_action_id3");
                },
                child: Text("handle without image"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
