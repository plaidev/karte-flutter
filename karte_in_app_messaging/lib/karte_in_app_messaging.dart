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

import 'package:karte_core/karte_core.dart';

const WrapperChannel _channel = const WrapperChannel('karte_in_app_messaging');

/// アプリ内メッセージの管理を行うクラスです。
class InAppMessaging {
  InAppMessaging._();

  /// アプリ内メッセージの表示有無を返します。
  ///
  /// アプリ内メッセージが表示中の場合は `true` を返し、表示されていない場合は `false` を返します。
  static Future<bool> get isPresenting async {
    return await _channel.invokeMethod(
        'InAppMessaging_isPresenting', null, false);
  }

  /// 現在表示中の全てのアプリ内メッセージを非表示にします。
  static void dismiss() async {
    await _channel.invokeMethod('InAppMessaging_dismiss');
  }

  /// アプリ内メッセージの表示を抑制します。
  ///
  /// なお既に表示されているアプリ内メッセージは、メソッドの呼び出しと同時に非表示となります。
  static void suppress() async {
    await _channel.invokeMethod('InAppMessaging_suppress');
  }

  /// アプリ内メッセージの表示抑制状態を解除します。
  static void unsuppress() async {
    await _channel.invokeMethod('InAppMessaging_unsuppress');
  }
}
