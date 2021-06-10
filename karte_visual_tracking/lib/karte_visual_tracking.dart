//
//  Copyright 2021 PLAID, Inc.
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
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:karte_core/karte_core.dart';

const WrapperChannel _channel = const WrapperChannel('karte_visual_tracking');

const MethodChannel _dartChannel =
    const MethodChannel('karte_visual_tracking_dart');

Future<dynamic> _handleDartMethod(MethodCall call) async {
  switch (call.method) {
    case 'pairingStatusUpdated':
      print("pairingStatusUpdated was called isPaired = ${call.arguments}");
      VisualTracking._paired = call.arguments;
      return Future.value(null);
    default:
      throw MissingPluginException(
          "No implementation found for method ${call.method}");
  }
}

/// ビジュアルトラッキングの管理を行うクラスです。
class VisualTracking {
  VisualTracking._();

  static bool _paired = false;

  static bool get _isPaired {
    if (!_dartChannel.checkMethodCallHandler(_handleDartMethod)) {
      _dartChannel.setMethodCallHandler(_handleDartMethod);
      _channel
          .invokeMethod('VisualTracking_isPaired')
          .then((value) => {_paired = value});
    }
    return _paired;
  }

  /// 操作ログをハンドルします。
  ///
  /// 操作ログはペアリング時のみ送信されます。
  /// イベント発火条件定義に操作ログがマッチした際にビジュアルイベントが送信されます。
  ///
  /// [action] にアクション名を指定します。
  /// [targetText] にターゲット文字列を指定します。（Viewコンポーネントのタイトルなど）
  /// [actionId] アクションIDを指定します。（アクションIDにはアプリ再起動時も変化しない一意なIDを設定してください。）
  /// [globalKey] 画像データ生成対象のWidgetに紐づくglobalKeyを指定します。（ペアリング時の操作ログ送信でのみ利用されます。）
  static Future<void> handle(String action, String targetText, String actionId,
      [GlobalKey? globalKey]) async {
    var imageData;
    if (VisualTracking._isPaired) {
      imageData = await _imageData(globalKey);
    }
    await _channel.invokeMethod('VisualTracking_handle', {
      "action": action,
      "targetText": targetText,
      "actionId": actionId,
      "imageData": imageData
    });
  }

  static Future<Uint8List?> _imageData(GlobalKey? globalKey,
      [bool shouldRetry = true]) async {
    if (globalKey == null) return null;

    ui.Image? image;
    RenderRepaintBoundary? boundary =
        globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    try {
      image = await boundary?.toImage(pixelRatio: 2.0);
      ByteData? byteData =
          await image?.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (_) {
      if (shouldRetry) {
        await Future.delayed(Duration(milliseconds: 50));
        return _imageData(globalKey, false);
      }
    }
    return null;
  }
}
