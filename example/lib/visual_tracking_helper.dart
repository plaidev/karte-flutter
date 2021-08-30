import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:karte_visual_tracking/karte_visual_tracking.dart';

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
    final GlobalKey k;
    if (key is GlobalKey)
      k = key as GlobalKey;
    else
      k = GlobalObjectKey(context);
    return RepaintBoundary(
        key: k,
        child: ElevatedButton(
          onPressed: () async {
            VisualTracking.handle("touch", "$title", actionId, k);
            onPressed();
          },
          child: Text(title),
        ));
  }
}

class VTScreenContainer extends StatefulWidget {
  const VTScreenContainer({required this.child});

  final Widget child;

  @override
  _VTScreenContainerState createState() => new _VTScreenContainerState();
}

class _VTScreenContainerState extends State<VTScreenContainer> {
  GlobalKey key = GlobalKey<_VTScreenContainerState>();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((_) => {
          VisualTracking.handle("initState", "",
              widget.toStringShort() + "_" + widget.child.toStringShort(), key)
        });
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(key: key, child: widget.child);
  }
}
