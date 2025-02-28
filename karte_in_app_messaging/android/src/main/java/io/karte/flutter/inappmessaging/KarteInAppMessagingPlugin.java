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
package io.karte.flutter.inappmessaging;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.karte.android.core.logger.Logger;
import io.karte.android.inappmessaging.InAppMessaging;

public class KarteInAppMessagingPlugin implements FlutterPlugin, MethodCallHandler {

    private static final String LOG_TAG = "KarteFlutter";

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "karte_in_app_messaging");
        channel.setMethodCallHandler(this);
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
        if ("InAppMessaging".equals(className)) {
            handleInAppMessagingMethodCall(methodName, result);
        } else {
            result.notImplemented();
        }
    }

    private void handleInAppMessagingMethodCall(String methodName, Result result) {
        switch (methodName) {
            case "isPresenting":
                result.success(InAppMessaging.isPresenting());
                break;
            case "dismiss":
                InAppMessaging.dismiss();
                result.success(null);
                break;
            case "suppress":
                InAppMessaging.suppress();
                result.success(null);
                break;
            case "unsuppress":
                InAppMessaging.unsuppress();
                result.success(null);
                break;
            default:
                result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
