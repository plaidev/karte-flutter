import 'package:flutter/material.dart';
import 'package:karte_visual_tracking/karte_visual_tracking_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return VisualTrackingWidget(
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('KARTE VisualTracking example app'),
          ),
          body: Center(
            child: Column(
              children: [
                ElevatedButton(
                    child: Text("handle"),
                    onPressed: () async {
                      print("VTButton pressed");
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
