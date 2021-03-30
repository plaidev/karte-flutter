import 'package:flutter/material.dart';
import 'package:karte_flutter/visual_tracking_helper.dart';

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
    return VTScreenContainer(
      child: Center(
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
    );
  }
}
