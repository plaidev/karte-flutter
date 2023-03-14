import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:karte_variables/karte_variables.dart';

void main() {
  const MethodChannel channel = MethodChannel('karte_variables');
  Map<String, List<MethodCall>> calls = {};

  T? cast<T>(x) => x is T ? x : null;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      calls.putIfAbsent(methodCall.method, () => []);
      calls[methodCall.method]?.add(methodCall);

      switch (methodCall.method) {
        case 'Variables_get':
          return "test";
      }
      return null;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    var variable = await Variables.get("test");
    expect(variable.name, "test");
  });

  test('trackOpen', () async {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(1000);
    var variable = await Variables.get("test");
    Variables.trackOpen([variable], { 'd': dateTime });
    Map? args = cast<Map>(calls['Variables_trackOpen']?[0].arguments);
    expect(args?['variableNames'], ['test']);
    expect(args?['values'], { 'd': 1 });
  });


  test('trackClick', () async {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(1000);
    var variable = await Variables.get("test");
    Variables.trackClick([variable], { 'd': dateTime });
    Map? args = cast<Map>(calls['Variables_trackClick']?[0].arguments);
    expect(args?['variableNames'], ['test']);
    expect(args?['values'], { 'd': 1 });
  });
}
