import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:karte_in_app_messaging/karte_in_app_messaging.dart';

void main() {
  const MethodChannel channel = MethodChannel('karte_in_app_messaging');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return false;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('isPresenting', () async {
    expect(await InAppMessaging.isPresenting, false);
  });
}
