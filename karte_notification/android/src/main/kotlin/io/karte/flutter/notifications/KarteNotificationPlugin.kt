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
package io.karte.flutter.notifications

import android.content.Context
import android.os.AsyncTask
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
import io.karte.android.notifications.MessageHandler
import io.karte.android.notifications.Notifications

private const val LOG_TAG = "KarteFlutter"

/** KarteNotificationPlugin */
class KarteNotificationPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "karte_notification")
        channel.setMethodCallHandler(this);
        context = flutterPluginBinding.applicationContext
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
            val plugin = KarteNotificationPlugin()
            val channel = MethodChannel(registrar.messenger(), "karte_notification")
            channel.setMethodCallHandler(plugin)
            plugin.context = registrar.context()
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
            "Notification" -> when (methodName) {
                "registerFCMToken" -> {
                    call.argument<String>("fcmToken")?.let {
                        Notifications.registerFCMToken(it)
                    }
                    result.success(null)
                }
                else -> {
                    val message = call.argument<Map<String, Any?>>("message")

                    val data = if (message != null) {
                        @Suppress("UNCHECKED_CAST")
                        message.get("data") as? Map<String, String>
                    } else {
                        call.argument<Map<String, String>>("data")
                    }
                    when (methodName) {
                        "canHandle" -> {
                            if (data != null) {
                                result.success(MessageHandler.canHandleMessage(data))
                            } else {
                                result.success(false)
                            }
                        }
                        "handle" -> {
                            if (data != null) {
                                if (isMainThread) {
                                    AsyncTask.execute {
                                        val handled = MessageHandler.handleMessage(context, data)
                                        Handler(Looper.getMainLooper()).post { result.success(handled) }
                                    }
                                } else {
                                    result.success(MessageHandler.handleMessage(context, data))
                                }
                            } else {
                                result.success(false)
                            }
                        }
                        "url" -> {
                            if (data != null) {
                                result.success(MessageHandler.extractKarteAttributes(data)?.link)
                            } else {
                                result.success(null)
                            }
                        }
                        else -> result.notImplemented()
                    }
                }
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private val isMainThread: Boolean
        get() = Looper.myLooper() == Looper.getMainLooper()
}
