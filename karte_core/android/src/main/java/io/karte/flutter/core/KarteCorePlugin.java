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
package io.karte.flutter.core;

import android.content.Intent;

import androidx.annotation.NonNull;

import java.util.HashMap;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.karte.android.KarteApp;
import io.karte.android.core.library.Library;
import io.karte.android.core.logger.Logger;
import io.karte.android.core.usersync.UserSync;
import io.karte.android.tracking.Tracker;

/**
 * KarteCorePlugin
 */
public class KarteCorePlugin implements FlutterPlugin, ActivityAware, MethodCallHandler,
        PluginRegistry.NewIntentListener, Library {

    private static final String LOG_TAG = "KarteFlutter";
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;

    //region FlutterPlugin
    @Override
    public void onAttachedToEngine(@NonNull FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "karte_core");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
    //endregion

    //region MethodCallHandler
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
        switch (className) {
            case "KarteApp":
                handleKarteAppMethodCall(methodName, result);
                break;
            case "Tracker":
                handleTrackerMethodCall(methodName, call, result);
                break;
            case "UserSync":
                handleUserSyncMethodCall(methodName, call, result);
                break;
            default:
                result.notImplemented();
        }
    }

    private void handleKarteAppMethodCall(String methodName, Result result) {
        switch (methodName) {
            case "getVisitorId":
                result.success(KarteApp.getVisitorId());
                break;
            case "isOptOut":
                result.success(KarteApp.isOptOut());
                break;
            case "optIn":
                KarteApp.optIn();
                result.success(null);
                break;
            case "optOut":
                KarteApp.optOut();
                result.success(null);
                break;
            case "renewVisitorId":
                KarteApp.renewVisitorId();
                result.success(null);
                break;
            default:
                result.notImplemented();
        }
    }

    private void handleTrackerMethodCall(String methodName, MethodCall call, Result result) {
        HashMap<String, Object> values = call.argument("values");
        switch (methodName) {
            case "track":
                String name = call.argument("name");
                if (name != null) {
                    Tracker.track(name, values);
                } else {
                    Logger.w(LOG_TAG, "Tracker.track didn't get argument 'name', NOP.");
                }
                result.success(null);
                break;
            case "identify":
                String userId = call.argument("userId");
                if (userId != null) {
                    Tracker.identify(userId, values);
                } else {
                    Tracker.identify(values != null ? values : new HashMap<String, Object>());
                }
                result.success(null);
                break;
            case "attribute":
                Tracker.attribute(values);
                result.success(null);
                break;
            case "view":
                String viewName = call.argument("viewName");
                String title = call.argument("title");
                if (viewName != null) {
                    Tracker.view(viewName, title, values);
                } else {
                    Logger.w(LOG_TAG, "Tracker.view didn't get argument 'viewName', NOP");
                }
                result.success(null);
                break;
            default:
                result.notImplemented();
        }
    }

    private void handleUserSyncMethodCall(String methodName, MethodCall call, Result result) {
        switch (methodName) {
            case "appendingQueryParameter":
                String url = call.argument("url");
                if (url != null) {
                    result.success(UserSync.appendUserSyncQueryParameter(url));
                } else {
                    Logger.w(LOG_TAG, "UserSync.appendingQueryParameter didn't get argument 'url', return null.");
                    result.success(null);
                }
                break;
            case "getUserSyncScript":
                result.success(UserSync.getUserSyncScript());
                break;
            default:
                result.notImplemented();
        }
    }
    //endregion

    //region ActivityAware
    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        binding.addOnNewIntentListener(this);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
        binding.addOnNewIntentListener(this);
    }

    @Override
    public void onDetachedFromActivity() {
    }
    //endregion

    //region NewIntentListener
    @Override
    public boolean onNewIntent(@NonNull Intent intent) {
        KarteApp.onNewIntent(intent);
        return false;
    }
    //endregion

    //region Library
    @Override
    public boolean isPublic() {
        return true;
    }

    @NonNull
    @Override
    public String getName() {
        return "flutter";
    }

    @NonNull
    @Override
    public String getVersion() {
        return BuildConfig.LIB_VERSION;
    }

    @Override
    public void configure(@NonNull KarteApp app) {
    }

    @Override
    public void unconfigure(@NonNull KarteApp app) {
    }
    //endregion
}
