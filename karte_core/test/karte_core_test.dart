import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:karte_core/karte_core.dart';

void main() {
  const MethodChannel channel = MethodChannel('karte_core');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return 'visitorId';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getVisitorId', () async {
    expect(await KarteApp.visitorId, 'visitorId');
  });
}
