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

import 'package:flutter/services.dart';

/// Wrapper of [MethodChannel] for catch PlatformExceptions.
class WrapperChannel extends MethodChannel {
  const WrapperChannel(String name) : super(name);

  @override
  Future<T?> invokeMethod<T>(String method, [dynamic arguments, T? def]) {
    try {
      return super.invokeMethod(method, arguments);
    } on PlatformException {
      return Future.value(def);
    }
  }
}

const WrapperChannel _channel = WrapperChannel('karte_core');

/// KARTE SDKのエントリポイントクラスです。
class KarteApp {
  KarteApp._();

  /// ビジターIDを返します。
  ///
  /// ユーザーを一意に識別するためのID（ビジターID）を返します。
  ///
  /// なお初期化が行われていない場合は空文字列を返します。
  static Future<String> get visitorId async {
    return await _channel.invokeMethod('KarteApp_getVisitorId', null, "")
        as FutureOr<String>;
  }

  /// オプトアウトの設定有無を返します。
  ///
  /// オプトアウトされている場合は、`true` を返し、されていない場合は `false` を返します。
  /// また初期化が行われていない場合は `false` を返します。
  static Future<bool> get isOptOut async {
    return await _channel.invokeMethod('KarteApp_isOptOut', null, false)
        as FutureOr<bool>;
  }

  /// オプトインします。
  ///
  /// 初期化が行われていない状態で呼び出した場合はオプトインは行われません。
  static void optIn() async {
    await _channel.invokeMethod('KarteApp_optIn');
  }

  /// オプトアウトします。
  ///
  /// 初期化が行われていない状態で呼び出した場合はオプトアウトは行われません。
  static void optOut() async {
    await _channel.invokeMethod('KarteApp_optOut');
  }

  /// ビジターIDを再生成します。
  ///
  /// ビジターIDの再生成は、現在のユーザーとは異なるユーザーとして計測したい場合などに行います。
  /// 例えば、アプリケーションでログアウトを行った場合などがこれに該当します。
  ///
  /// なお初期化が行われていない状態で呼び出した場合は再生成は行われません。
  static void renewVisitorId() async {
    await _channel.invokeMethod('KarteApp_renewVisitorId');
  }
}

/// イベントトラッキングを行うためのクラスです。
class Tracker {
  Tracker._();

  static Map? _normalize(Map? values) {
    return values?.map((k, v) =>
        MapEntry(k, v is DateTime ? v.millisecondsSinceEpoch ~/ 1000 : v)
    );
  }

  /// イベントの送信を行います。
  ///
  /// [name] はイベント名、 [values] はイベントに紐付けるカスタムオブジェクトを指定します。
  static void track(String name, [Map? values]) async {
    await _channel
        .invokeMethod('Tracker_track', {"name": name, "values": _normalize(values)});
  }

  /// Identifyイベントの送信を行います。
  ///
  /// [values] はIdentifyイベントに紐付けるカスタムオブジェクトを指定します。
  static void identify(Map values) async {
    await _channel.invokeMethod('Tracker_identify', {"values": values});
  }

  /// ユーザーIDを指定して、Identifyイベントの送信を行います。
  ///
  /// [userId] はユーザーを識別する一意なID、
  /// [values] はIdentifyイベントに紐付けるカスタムオブジェクトを指定します。
  static void identifyWithUserId(String userId, [Map? values]) async {
    await _channel
        .invokeMethod('Tracker_identify', {"values": _normalize(values), "userId": userId});
  }

  /// Attributeイベントの送信を行います。
  ///
  /// [values] はAttributeイベントに紐付けるカスタムオブジェクトを指定します。
  static void attribute(Map values) async {
    await _channel.invokeMethod('Tracker_attribute', {"values": _normalize(values)});
  }

  /// Viewイベントの送信を行います。
  ///
  /// [viewName] は画面名、 [title] はタイトル、
  /// [values] はViewイベントに紐付けるカスタムオブジェクトを指定します。
  static void view(String viewName, [String? title, Map? values]) async {
    await _channel.invokeMethod('Tracker_view',
        {"viewName": viewName, "title": title, "values": _normalize(values)});
  }
}

/// WebView 連携するためのクラスです。
///
/// WebページURLに連携用のクエリパラメータを付与した状態で、URLをWebViewで開くことでWebとAppのユーザーの紐付けが行われます。
/// なお連携を行うためにはWebページに、KARTEのタグが埋め込まれている必要があります。
class UserSync {
  UserSync._();

  /// 指定されたURL文字列にWebView連携用のクエリパラメータを付与します。
  ///
  /// [url] に連携するページのURL文字列を指定すると、連携用のクエリパラメータを付与したURL文字列を返します。
  /// 指定されたURL文字列の形式が正しくない場合、またはSDKの初期化が行われていない場合は、引数に指定したURL文字列を返します。
  @Deprecated(
      "User sync function using query parameters is deprecated. It will be removed in the future.")
  static Future<String> appendingQueryParameter(String url) async {
    return await _channel.invokeMethod(
            'UserSync_appendingQueryParameter', {"url": url}, url)
        as FutureOr<String>;
  }

  /// WebView 連携用のスクリプト(javascript)を返却します。
  ///
  /// ユーザースクリプトとしてWebViewに設定することで、WebView内のタグと連携されます。
  /// なおSDKの初期化が行われていない場合はnullを返却します。
  static Future<String?> getUserSyncScript() async {
    return await _channel.invokeMethod('UserSync_getUserSyncScript', null)
        as FutureOr<String?>;
  }
}
