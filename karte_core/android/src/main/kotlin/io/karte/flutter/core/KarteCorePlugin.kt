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
package io.karte.flutter.core

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.karte.android.KarteApp
import io.karte.android.core.library.Library
import io.karte.android.core.logger.Logger
import io.karte.android.core.usersync.UserSync
import io.karte.android.tracking.Tracker

private const val LOG_TAG = "KarteFlutter"

/** KarteCorePlugin */
class KarteCorePlugin : FlutterPlugin, MethodCallHandler, Library {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "karte_core")
        channel.setMethodCallHandler(this)
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
            val channel = MethodChannel(registrar.messenger(), "karte_core")
            channel.setMethodCallHandler(KarteCorePlugin())
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
            "KarteApp" -> when (methodName) {
                "getVisitorId" -> result.success(KarteApp.visitorId)
                "isOptOut" -> result.success(KarteApp.isOptOut)
                "optIn" -> {
                    KarteApp.optIn()
                    result.success(null)
                }
                "optOut" -> {
                    KarteApp.optOut()
                    result.success(null)
                }
                "renewVisitorId" -> {
                    KarteApp.renewVisitorId()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
            "Tracker" -> {
                val values = call.argument<HashMap<String, Any?>>("values")
                when (methodName) {
                    "track" -> {
                        val name = call.argument<String>("name")
                        if (name != null) Tracker.track(name, values)
                        else Logger.w(LOG_TAG, "Tracker.track didn't get argument 'name', NOP.")
                        result.success(null)
                    }
                    "identify" -> {
                        val userId = call.argument<String>("userId")
                        if (userId != null) Tracker.identify(userId, values)
                        else Tracker.identify(values ?: mapOf<String, Any?>())
                        result.success(null)
                    }
                    "attribute" -> {
                        Tracker.attribute(values ?: mapOf<String, Any?>())
                        result.success(null)
                    }
                    "view" -> {
                        val viewName = call.argument<String>("viewName")
                        val title = call.argument<String>("title")
                        if (viewName != null) Tracker.view(viewName, title, values)
                        else Logger.w(LOG_TAG, "Tracker.view didn't get argument 'viewName', NOP")
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
            "UserSync" -> when (methodName) {
                "appendingQueryParameter" -> {
                    val url = call.argument<String>("url")
                    if (url != null) {
                        result.success(UserSync.appendUserSyncQueryParameter(url))
                    } else {
                        Logger.w(LOG_TAG, "UserSync.appendingQueryParameter didn't get argument 'url', return null.")
                        result.success(null)
                    }
                }
                "getUserSyncScript" -> {
                    result.success(UserSync.getUserSyncScript())
                }
                else -> result.notImplemented()
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    //region Library
    override val isPublic: Boolean = true
    override val name: String = "flutter"
    override val version: String = BuildConfig.LIB_VERSION
    override fun configure(app: KarteApp) {}
    override fun unconfigure(app: KarteApp) {}
    //endregion
}
