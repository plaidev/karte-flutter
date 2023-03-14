import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:karte_core/karte_core.dart';

void main() {
  const MethodChannel channel = MethodChannel('karte_core');
  Map<String, List<MethodCall>> calls = {};

  T? cast<T>(x) => x is T ? x : null;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      calls.putIfAbsent(methodCall.method, () => []);
      calls[methodCall.method]?.add(methodCall);

      switch (methodCall.method) {
        case 'KarteApp_getVisitorId':
          return 'visitorId';
      }
      return null;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getVisitorId', () async {
    expect(await KarteApp.visitorId, 'visitorId');
  });
  
  test("track", () {
    Tracker.track('foo', { 'd': DateTime.fromMillisecondsSinceEpoch(1000) });
    Map? args = cast<Map>(calls['Tracker_track']?[0].arguments);
    expect(args?['name'], 'foo');
    expect(args?['values'], { 'd': 1 });
  });

  test("identify", () {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(1000);
    Tracker.identify({ 'user_id': 'foo', 'd': dateTime });

    Map? args = cast<Map>(calls['Tracker_identify']?[0].arguments);
    expect(args?['values'], { 'user_id': 'foo', 'd': 1 });
  });

  test("identifyWithUserId", () {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(1000);
    Tracker.identifyWithUserId('foo', { 'd': dateTime });

    Map? args = cast<Map>(calls['Tracker_identify']?[1].arguments);
    expect(args?['userId'], 'foo');
    expect(args?['values'], { 'd': 1 });
  });

  test("attribute", () {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(1000);
    Tracker.attribute({ 'd': dateTime });

    Map? args = cast<Map>(calls['Tracker_attribute']?[0].arguments);
    expect(args?['values'], { 'd': 1 });
  });

  test("view", () {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(1000);
    Tracker.view('foo', 'bar', { 'd': dateTime });

    Map? args = cast<Map>(calls['Tracker_view']?[0].arguments);
    expect(args?['viewName'], 'foo');
    expect(args?['title'], 'bar');
    expect(args?['values'], { 'd': 1 });
  });
}
