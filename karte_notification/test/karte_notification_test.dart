import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:karte_notification/karte_notification.dart';

void main() {
  const MethodChannel channel = MethodChannel('karte_notification');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // channel.setMockMethodCallHandler((MethodCall methodCall) async {
    //   return Notification._({'aaa':'bbb'});
    // });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('Notification create', () async {
    Notification n = await Notification.create({'aaa': 'bbb'});
    expect(n.message, {'aaa': 'bbb'});
  });
}
