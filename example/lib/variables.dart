import 'package:flutter/material.dart';
import 'package:karte_variables/karte_variables.dart';

class VariablesScreen extends StatefulWidget {
  @override
  _VariablesState createState() => _VariablesState();
}

class _VariablesState extends State<VariablesScreen> {
  String? _string;
  int? _int;
  double? _double;
  bool? _bool;
  List? _list;
  Map? _map;

  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkVariables();
  }

  checkVariables() async {
    var strVar = await Variables.get("string");
    String string = await strVar.getString("unknown");
    var intVar = await Variables.get("long");
    int intValue = await intVar.getInteger(-1);
    var doubleVar = await Variables.get("double");
    double doubleValue = await doubleVar.getDouble(-1);
    var boolVar = await Variables.get("boolean");
    bool boolValue = await boolVar.getBoolean(false);
    var arrVar = await Variables.get("array");
    List list = await arrVar.getArray(['u', 'n', 'k', 'n', 'o', 'w', 'n']);
    var objVar = await Variables.get("object");
    Map map = await objVar.getObject({'un': "known"});

    var noneVar = await Variables.get('none');
    print(await noneVar.getString('unknown'));
    print(await noneVar.getInteger(-1));
    print(await noneVar.getDouble(-1.1));
    print(await noneVar.getBoolean(false));
    print(await noneVar.getArray(['u', 'n', 'k', 'n', 'o', 'w', 'n']));
    print(await noneVar.getObject({"un": 'known'}));

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _string = string;
      _int = intValue;
      _double = doubleValue;
      _bool = boolValue;
      _list = list;
      _map = map;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                return Container(
                  height: 250 + MediaQuery.of(context).viewInsets.bottom,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _textEditingController,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Variables.clearCache(_textEditingController.text);
                          await checkVariables();
                          _textEditingController.clear();
                          Navigator.pop(context);
                        },
                        child: Text("OK"),
                      ),
                    ]
                  )
                );
              });
            },
            child: Text("Clear Cache By Key"),
          ),
          ElevatedButton(
            onPressed: () {
              Variables.fetch().then((value) async {
                print("variables fetch completed!");
                await checkVariables();
              });
            },
            child: Text("Fetch Variables"),
          ),
          ElevatedButton(
            onPressed: () async {
              var strVar = await Variables.get('string');
              var intVar = await Variables.get('long');
              Variables.trackOpen([
                strVar,
                intVar
              ], {
                "from": 'Flutter',
              });
            },
            child: Text("Track open"),
          ),
          ElevatedButton(
            onPressed: () async {
              var strVar = await Variables.get('string');
              var intVar = await Variables.get('long');
              Variables.trackClick([
                strVar,
                intVar
              ], {
                "from": 'Flutter',
              });
            },
            child: Text("Track click"),
          ),
          Text('string: $_string\n'),
          Text('int: $_int\n'),
          Text('double: $_double\n'),
          Text('bool: $_bool\n'),
          Text('array: $_list\n'),
          Text('object: $_map\n'),
        ],
      ),
    );
  }
}
