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
package io.karte.flutter.notifications;

import android.content.Context;
import android.os.AsyncTask;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.karte.android.core.logger.Logger;
import io.karte.android.notifications.KarteAttributes;
import io.karte.android.notifications.MessageHandler;
import io.karte.android.notifications.Notifications;

public class KarteNotificationPlugin implements FlutterPlugin, MethodCallHandler {

    private static final String LOG_TAG = "KarteFlutter";

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Context context;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "karte_notification");
        channel.setMethodCallHandler(this);
        context = flutterPluginBinding.getApplicationContext();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        Logger.d(LOG_TAG, "onMethodCall " + call.method);
        if (!call.method.contains("_")) {
            result.notImplemented();
            return;
        }
        String[] methodParts = call.method.split("_", 2);
        String className = methodParts[0];
        String methodName = methodParts[1];
        if ("Notification".equals(className)) {
            handleNotificationMethodCall(methodName, call, result);
        } else {
            result.notImplemented();
        }
    }

    private void handleNotificationMethodCall(String methodName, MethodCall call, final Result result) {
        if ("registerFCMToken".equals(methodName)) {
            String fcmToken = call.argument("fcmToken");
            if (fcmToken != null) {
                Notifications.registerFCMToken(fcmToken);
            }
            result.success(null);
            return;
        }

        Map<String, Object> message = call.argument("message");
        Map<String, String> data = null;
        if (message != null) {
            try {
                data = (Map<String, String>) message.get("data");
            } catch (Exception ignored) {
            }
        } else {
            data = call.argument("data");
        }
        switch (methodName) {
            case "canHandle":
                if (data != null) {
                    result.success(MessageHandler.canHandleMessage(data));
                } else {
                    result.success(false);
                }
                break;
            case "handle":
                if (data != null) {
                    if (isMainThread()) {
                        final Map<String, String> d = data;
                        AsyncTask.execute(new Runnable() {
                            @Override
                            public void run() {
                                final boolean handled = MessageHandler.handleMessage(context, d);
                                new Handler(Looper.getMainLooper()).post(new Runnable() {
                                    @Override
                                    public void run() {
                                        result.success(handled);
                                    }
                                });
                            }
                        });
                    } else {
                        result.success(MessageHandler.handleMessage(context, data));
                    }
                } else {
                    result.success(false);
                }
                break;
            case "url":
                if (data != null) {
                    KarteAttributes attributes = MessageHandler.extractKarteAttributes(data);
                    if (attributes != null)
                        result.success(attributes.link);
                    else
                        result.success(null);
                } else {
                    result.success(null);
                }
                break;
            default:
                result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    private boolean isMainThread() {
        return Looper.myLooper() == Looper.getMainLooper();
    }
}
