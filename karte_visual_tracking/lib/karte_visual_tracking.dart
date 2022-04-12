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

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:karte_core/karte_core.dart';

const WrapperChannel _channel = const WrapperChannel('karte_visual_tracking');

/// ビジュアルトラッキングの管理を行うクラスです。
class VisualTracking {
  VisualTracking._();

  static const _pixelRatio = 2.0;

  /// 操作ログをハンドルします。
  ///
  /// 操作ログはペアリング時のみ送信されます。
  /// イベント発火条件定義に操作ログがマッチした際にビジュアルイベントが送信されます。
  ///
  /// [action] にアクション名を指定します。
  /// [targetText] にターゲット文字列を指定します。（Viewコンポーネントのタイトルなど）
  /// [actionId] アクションIDを指定します。（アクションIDにはアプリ再起動時も変化しない一意なIDを設定してください。）
  /// [renderRepaintBoundary] 画像データの取得元となるRenderRepaintBoundary。（ペアリング時の操作ログ送信でのみ利用されます。）
  /// [offset] RenderRepaintBoundaryと操作ログ対象Widgetの相対座標
  /// [size] 操作ログ対象Widgetのサイズ
  static Future<void> handle(
      {required String action,
      required String targetText,
      required String actionId,
      RenderRepaintBoundary? renderRepaintBoundary,
      Offset? offset,
      Size? size}) async {
    var imageData;

    final isPaired = await _channel.invokeMethod('VisualTracking_isPaired');
    if (isPaired) {
      imageData = await _imageData(renderRepaintBoundary);
    }

    final offsetX = offset != null ? _pixelRatio * offset.dx : null;
    final offsetY = offset != null ? _pixelRatio * offset.dy : null;
    final imageWidth = size != null ? _pixelRatio * size.width : null;
    final imageHeight = size != null ? _pixelRatio * size.height : null;
    await _channel.invokeMethod('VisualTracking_handle', {
      "action": action,
      "targetText": targetText,
      "actionId": actionId,
      "imageData": imageData,
      "offsetX": offsetX,
      "offsetY": offsetY,
      "imageWidth": imageWidth,
      "imageHeight": imageHeight,
    });
  }

  static Future<Uint8List?> _imageData(
      RenderRepaintBoundary? renderRepaintBoundary,
      [bool shouldRetry = true]) async {
    ui.Image? image;
    try {
      image = await renderRepaintBoundary?.toImage(pixelRatio: _pixelRatio);
      ByteData? byteData =
          await image?.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (_) {
      if (shouldRetry) {
        await Future.delayed(Duration(milliseconds: 50));
        return _imageData(renderRepaintBoundary, false);
      }
    }
    return null;
  }
}
