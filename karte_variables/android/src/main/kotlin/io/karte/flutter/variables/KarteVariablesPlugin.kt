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
package io.karte.flutter.variables

import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.karte.android.core.logger.Logger
import io.karte.android.utilities.toList
import io.karte.android.utilities.toMap
import io.karte.android.variables.Variables
import org.json.JSONArray
import org.json.JSONObject

private const val LOG_TAG = "KarteFlutter"
/** KarteVariablesPlugin */
public class KarteVariablesPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "karte_variables")
        channel.setMethodCallHandler(this);
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "karte_variables")
            channel.setMethodCallHandler(KarteVariablesPlugin())
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        Logger.d(LOG_TAG, "onMethodCall ${call.method}")
        if (!call.method.contains("_")) {
            result.notImplemented()
            return
        }
        val (className, methodName) = call.method.split("_", limit = 2)
        when (className) {
            "Variables" -> when (methodName) {
                "fetchWithResult" -> Variables.fetch { Handler(Looper.getMainLooper()).post { result.success(it) } }
                "get" -> {
                    call.argument<String>("key")?.let {
                        result.success(Variables.get(it).name)
                    } ?: run {
                        Logger.w(LOG_TAG, "Variables.get didn't get argument 'key', return empty Variable instance.")
                        result.success("")
                    }
                }
                "trackOpen" -> {
                    val names = call.argument<List<String>>("variableNames") ?: listOf()
                    val variables = names.map { Variables.get(it) }
                    val values = call.argument<Map<String, Any?>>("values")
                    Variables.trackOpen(variables, values)
                    result.success(null)
                }
                "trackClick" -> {
                    val names = call.argument<List<String>>("variableNames") ?: listOf()
                    val variables = names.map { Variables.get(it) }
                    val values = call.argument<Map<String, Any?>>("values")
                    Variables.trackClick(variables, values)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
            "Variable" -> {
                val name = call.argument<String>("name") ?: ""
                if (name.isEmpty()) {
                    Logger.w(LOG_TAG, "Variable has empty name, return default value.")
                }
                val variable = Variables.get(name)
                val defaultValue = call.argument<Any>("default")
                when (methodName) {
                    "getString" -> result.success(variable.string(defaultValue as String))
                    "getInteger" -> {
                        val default = if (defaultValue is Int) defaultValue.toLong() else defaultValue as Long
                        result.success(variable.long(default))
                    }
                    "getDouble" -> result.success(variable.double(defaultValue as Double))
                    "getBoolean" -> result.success(variable.boolean(defaultValue as Boolean))
                    "getArray" -> {
                        result.success(variable.jsonArray(JSONArray(defaultValue as List<*>)).toList())
                    }
                    "getObject" -> {
                        result.success(variable.jsonObject(JSONObject(defaultValue as Map<String, *>)).toMap())
                    }
                    else -> result.notImplemented()
                }
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
