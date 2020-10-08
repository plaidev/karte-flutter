import 'package:flutter/material.dart';
import 'package:karte_core/karte_core.dart';
import 'package:karte_in_app_messaging/karte_in_app_messaging.dart';

class IAMScreen extends StatefulWidget {
  @override
  _IAMState createState() => _IAMState();
}

class _IAMState extends State<IAMScreen> {
  bool _isPresenting = false;

  @override
  void initState() {
    super.initState();
    updateState();
  }

  void updateState() async {
    bool isPresenting = await InAppMessaging.isPresenting;
    if (!mounted) return;

    setState(() {
      _isPresenting = isPresenting;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('isPresenting:  $_isPresenting'),
          RaisedButton(
            onPressed: () => updateState(),
            child: Text("checkPresent"),
          ),
          RaisedButton(
            onPressed: () => InAppMessaging.dismiss(),
            child: Text("dismiss"),
          ),
          RaisedButton(
            onPressed: () => InAppMessaging.suppress(),
            child: Text("suppress"),
          ),
          RaisedButton(
            onPressed: () => InAppMessaging.unsuppress(),
            child: Text("unsuppress"),
          ),
          RaisedButton(
            onPressed: () => Tracker.view("popup"),
            child: Text("view"),
          ),
        ],
      ),
    );
  }
}
