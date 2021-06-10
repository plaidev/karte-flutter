//
//  Copyright 2020 PLAID, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:karte_core/karte_core.dart';

const WrapperChannel _channel = const WrapperChannel('karte_notification');

/// リモート通知メッセージのパースおよびメッセージ中に含まれるディープリンクのハンドリングを行うためのクラスです。
class Notification {
  static void registerFCMToken(String fcmToken) async {
    await _channel
        .invokeMethod('Notification_registerFCMToken', {"fcmToken": fcmToken});
  }

  /// KARTE経由で送信された通知メッセージであるか判定します。
  ///
  /// [message] にFCMから送信された通知メッセージオブジェクトを渡します。
  /// KARTE経由で送信された通知メッセージの場合は`true`、KARTE以外から送信された通知メッセージの場合は、`false`を返します。
  static Future<bool> canHandle(RemoteMessage message) async {
    return await _channel.invokeMethod(
            "Notification_canHandle", {"data": message.data}, false)
        as FutureOr<bool>;
  }

  /// インスタンスを初期化します。
  ///
  /// [message] にFCMから送信された通知メッセージオブジェクトを渡します。
  /// なおリモート通知メッセージが KARTE から送信されたメッセージでない場合は、`null` を返します。
  static Future<Notification?> create(RemoteMessage message) async {
    bool canHandle = await Notification.canHandle(message);
    if (canHandle) {
      return Notification._(message);
    } else {
      return null;
    }
  }

  var message;

  Notification._(this.message);

  /// 通知メッセージ中に含まれる `URL` を返します。
  ///
  /// 以下の場合は、nullを返します。
  /// - KARTE以外から送信されたメッセージ
  /// - メッセージ中に `URL` が含まれていない場合
  /// - 不正なURL
  Future<String?> get url async {
    return await _channel.invokeMethod(
        "Notification_url", {'data': message.data}, null);
  }

  /// iOS向け：リモート通知メッセージに含まれるディープリンクを処理します。
  ///
  /// 内部では、メッセージ中に含まれるURLを `UIApplication.open(_:options:completionHandler:)` に渡す処理を行っています。
  /// `UIApplication.open(_:options:completionHandler:)` の呼び出しが行われた場合は `true` を返し、メッセージ中にURLが含まれない場合は `false` を返します。
  Future<bool> handleForIOS() async {
    if (!Platform.isIOS) return false;
    return await _channel.invokeMethod(
        'Notification_handle', {'data': message.data}, false) as FutureOr<bool>;
  }

  /// Android向け：KARTE経由で送信された通知メッセージから、通知を作成・表示します。
  ///
  /// KARTE経由で送信された通知メッセージの場合は`true`、KARTE以外から送信された通知メッセージの場合は、`false`を返します。
  Future<bool> handleForAndroid() async {
    if (!Platform.isAndroid) return false;
    return await _channel.invokeMethod(
        'Notification_handle', {'data': message.data}, false) as FutureOr<bool>;
  }

  /// iOS向け：通知のクリック計測を行います。
  ///
  /// 通常は自動でクリック計測が行われるため本メソッドを呼び出す必要はありませんが、
  /// `isEnabledAutoMeasurement` が `false` の場合は自動での計測が行われないため、
  /// 本メソッドを呼び出す必要があります。
  void track() async {
    if (!Platform.isIOS) return;
    await _channel.invokeMethod('Notification_track', {'data': message.data});
  }
}
