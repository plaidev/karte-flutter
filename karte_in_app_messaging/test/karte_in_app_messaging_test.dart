import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:karte_in_app_messaging/karte_in_app_messaging.dart';

void main() {
  const MethodChannel channel = MethodChannel('karte_in_app_messaging');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (message) async {
      return false;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (message) => null);
  });

  test('isPresenting', () async {
    expect(await InAppMessaging.isPresenting, false);
  });
}
