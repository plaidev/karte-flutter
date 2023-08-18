import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:karte_notification/karte_notification.dart';


RemoteMessage getDummyMessage() {
  return RemoteMessage.fromMap({'data':{'aaa': 'bbb'}});
}

void main() {
  const MethodChannel channel = MethodChannel('karte_notification');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (message) async {
      return message.method == 'Notification_canHandle';
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (message) => null);
  });

  test('Notification create', () async {
    RemoteMessage dummy = getDummyMessage();
    Notification? n = await (Notification.create(dummy));
    expect(n, isNotNull);
    expect(n!.message.data, dummy.data);
  });
}
