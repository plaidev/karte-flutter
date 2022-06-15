import 'package:flutter/material.dart';
import 'package:karte_visual_tracking/karte_visual_tracking_widget.dart';

class VTScreen extends StatefulWidget {
  @override
  _VTState createState() => _VTState();
}

class _VTState extends State<VTScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return VisualTrackingWidget(
      child: ElevatedButton(
        child: Text('handle'),
        onPressed: () {
          print("VTButton pressed");
        },
      ),
    );
  }
}
