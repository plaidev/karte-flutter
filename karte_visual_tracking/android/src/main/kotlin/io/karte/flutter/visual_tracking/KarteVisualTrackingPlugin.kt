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
package io.karte.flutter.visual_tracking

import android.graphics.BitmapFactory
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.karte.android.core.logger.Logger
import io.karte.android.visualtracking.*

private const val LOG_TAG = "KarteFlutter"

/** KarteVisualTrackingPlugin */
class KarteVisualTrackingPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "karte_visual_tracking")
        channel.setMethodCallHandler(this)
        setDelegate(flutterPluginBinding.binaryMessenger)
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
            val channel = MethodChannel(registrar.messenger(), "karte_visual_tracking")
            val plugin = KarteVisualTrackingPlugin()
            channel.setMethodCallHandler(plugin)
            plugin.setDelegate(registrar.messenger())
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
            "VisualTracking" ->
                when (methodName) {
                    "handle" -> {
                        val actionName = call.argument<String>("action") ?: return
                        var imageProvider: ImageProvider? = null
                        call.argument<ByteArray>("imageData")?.let {
                            imageProvider = ImageProvider { BitmapFactory.decodeByteArray(it, 0, it.size) }
                        }
                        val action = BasicAction(
                                actionName,
                                call.argument<String>("actionId"),
                                call.argument<String>("targetText"),
                                imageProvider)
                        VisualTracking.handle(action)
                        result.success(null)
                    }
                    "isPaired" -> {
                        result.success(VisualTracking.isPaired)
                    }
                    else -> result.notImplemented()
                }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun setDelegate(messenger: BinaryMessenger) {
        VisualTracking.delegate = object : VisualTrackingDelegate() {
            override fun onDevicePairingStatusUpdated(isPaired: Boolean) {
                Logger.d(LOG_TAG, "onDevicePairingStatusUpdated called isPaired=$isPaired")
                val channel = MethodChannel(messenger, "karte_visual_tracking_dart")
                Handler(Looper.getMainLooper()).post {
                    channel.invokeMethod("pairingStatusUpdated", isPaired)
                }
            }
        }
    }
}
