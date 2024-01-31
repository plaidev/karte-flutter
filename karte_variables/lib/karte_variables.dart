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
import 'package:karte_core/utils.dart';

const WrapperChannel _channel = const WrapperChannel('karte_variables');

/// 設定値の取得・管理を司るクラスです。
class Variables {
  Variables._();

  /// 設定値を取得し、端末上にキャッシュします。
  ///
  /// 取得完了後に成否の結果を返します。
  static Future<bool> fetch() async {
    return await _channel.invokeMethod('Variables_fetchWithResult', null, false)
        as FutureOr<bool>;
  }

  /// 指定されたキーに関連付けられた設定値にアクセスします。
  /// なお設定値にアクセスするには事前に `Variables.fetch()` を呼び出しておく必要があります。
  ///
  /// [key] に検索するためのキーを指定すると、キーに関連付けられた設定値を返します。
  static Future<Variable> get(String key) async {
    final name = await _channel.invokeMethod('Variables_get', {"key": key}, "");
    return new Variable._(name);
  }

  /// 指定された設定値に関連するキャンペーン情報を元に効果測定用のイベント（message_open）を発火します。
  ///
  /// [variables] に設定値の配列を、 [values] にイベントに紐付けるカスタムオブジェクトを指定します。
  static Future<void> trackOpen(List<Variable> variables, [Map? values]) async {
    List<String> names =
        List<String>.from(variables.map((e) => e.name), growable: false);
    await _channel.invokeMethod(
        'Variables_trackOpen', {"variableNames": names, "values": normalize(values)});
  }

  /// 指定された設定値に関連するキャンペーン情報を元に効果測定用のイベント（message_click）を発火します。
  ///
  /// [variables] に設定値の配列を、 [values] にイベントに紐付けるカスタムオブジェクトを指定します。
  static Future<void> trackClick(List<Variable> variables, [Map? values]) async {
    List<String> names =
        List<String>.from(variables.map((e) => e.name), growable: false);
    await _channel.invokeMethod(
        'Variables_trackClick', {"variableNames": names, "values": normalize(values)});
  }
}

/// 設定値とそれに付随する情報を保持するためのクラスです。
class Variable {
  var name;

  Variable._(this.name);

  /// 設定値（文字列）を返します。
  ///
  /// なお設定値が未定義の場合は、デフォルト値を返します。
  ///
  /// [defaultValue] にデフォルト値を指定します。
  Future<String> getString(String defaultValue) async {
    return await _channel.invokeMethod(
        'Variable_getString',
        {"name": name, "default": defaultValue},
        defaultValue) as FutureOr<String>;
  }

  /// 設定値（整数）を返します。
  ///
  /// なお設定値が数値でない場合は、デフォルト値を返します。
  ///
  /// [defaultValue] にデフォルト値を指定します。
  Future<int> getInteger(int defaultValue) async {
    return await _channel.invokeMethod('Variable_getInteger',
        {"name": name, "default": defaultValue}, defaultValue) as FutureOr<int>;
  }

  /// 設定値（浮動小数点数）を返します。
  ///
  /// なお設定値が数値でない場合は、デフォルト値を返します。
  ///
  /// [defaultValue] にデフォルト値を指定します。
  Future<double> getDouble(double defaultValue) async {
    return await _channel.invokeMethod(
        'Variable_getDouble',
        {"name": name, "default": defaultValue},
        defaultValue) as FutureOr<double>;
  }

  /// 設定値（ブール値）を返します。
  ///
  /// 設定値が未定義の場合は、デフォルト値を返します。
  ///
  /// [defaultValue] にデフォルト値を指定します。
  Future<bool> getBoolean(bool defaultValue) async {
    return await _channel.invokeMethod(
        'Variable_getBoolean',
        {"name": name, "default": defaultValue},
        defaultValue) as FutureOr<bool>;
  }

  /// 設定値（配列）を返します。
  ///
  /// 以下の場合においてデフォルト値を返します。
  /// - 設定値が未定義の場合
  /// - 設定値（JSON文字列）のパースができない場合
  ///
  /// [defaultValue] にデフォルト値を指定します。
  Future<List> getArray(List defaultValue) async {
    return await _channel.invokeMethod(
        'Variable_getArray',
        {"name": name, "default": defaultValue},
        defaultValue) as FutureOr<List<dynamic>>;
  }

  /// 設定値（辞書）を返します。
  ///
  /// 以下の場合においてデフォルト値を返します。
  /// - 設定値が未定義の場合
  /// - 設定値（JSON文字列）のパースができない場合
  ///
  /// [defaultValue] にデフォルト値を指定します。
  Future<Map> getObject(Map defaultValue) async {
    return await _channel.invokeMethod(
        'Variable_getObject',
        {"name": name, "default": defaultValue},
        defaultValue) as FutureOr<Map<dynamic, dynamic>>;
  }
}
