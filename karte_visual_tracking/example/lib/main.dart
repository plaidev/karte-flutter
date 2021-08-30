import 'package:flutter/material.dart';
import 'package:karte_visual_tracking/karte_visual_tracking.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class VTButton extends StatelessWidget {
  const VTButton({
    Key? key,
    this.title = "",
    required this.actionId,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final String actionId;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final k = key ?? GlobalObjectKey(context);
    return RepaintBoundary(
        key: k,
        child: ElevatedButton(
          onPressed: () async {
            VisualTracking.handle("touch", "$title", actionId,
                k as GlobalKey<State<StatefulWidget>>?);
            onPressed();
          },
          child: Text(title),
        ));
  }
}

class _MyAppState extends State<MyApp> {
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
              VTButton(
                  title: "handle",
                  actionId: "touch_vtbutton1",
                  onPressed: () async {
                    print("VTButton pressed");
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
