import 'package:flutter/material.dart';
import 'package:karte_visual_tracking/karte_visual_tracking_widget.dart';

class VTScreen extends StatefulWidget {
  const VTScreen({super.key});

  @override
  State<VTScreen> createState() => _VTState();
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
          debugPrint("VTButton pressed");
        },
      ),
    );
  }
}
