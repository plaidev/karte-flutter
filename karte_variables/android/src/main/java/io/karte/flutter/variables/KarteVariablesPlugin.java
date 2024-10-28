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
package io.karte.flutter.variables;

import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.karte.android.core.logger.Logger;
import io.karte.android.utilities.ExtensionsKt;
import io.karte.android.variables.FetchCompletion;
import io.karte.android.variables.Variable;
import io.karte.android.variables.Variables;

public class KarteVariablesPlugin implements FlutterPlugin, MethodCallHandler {

    private static final String LOG_TAG = "KarteFlutter";

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "karte_variables");
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
    public static void registerWith(Registrar registrar) {
        KarteVariablesPlugin plugin = new KarteVariablesPlugin();
        MethodChannel channel = new MethodChannel(registrar.messenger(), "karte_variables");
        channel.setMethodCallHandler(plugin);
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
        switch (className) {
            case "Variables":
                handleVariablesMethodCall(methodName, call, result);
                break;
            case "Variable":
                handleVariableMethodCall(methodName, call, result);
                break;
            default:
                result.notImplemented();
        }
    }

    private void handleVariablesMethodCall(String methodName, MethodCall call, final Result result) {
        List<String> names;
        List<Variable> variables;
        Map<String, Object> values;
        switch (methodName) {
            case "fetchWithResult":
                Variables.fetch(new FetchCompletion() {
                    @Override
                    public void onComplete(final boolean success) {
                        new Handler(Looper.getMainLooper()).post(new Runnable() {
                            @Override
                            public void run() {
                                result.success(success);
                            }
                        });
                    }
                });
                break;
            case "get":
                String key = call.argument("key");
                if (key != null) {
                    Variable variable = Variables.get(key);
                    result.success(variable.getName());
                } else {
                    Logger.w(LOG_TAG, "Variables.get didn't get argument 'key', return empty Variable instance.");
                    result.success("");
                }
                break;
            case "trackOpen":
                names = call.argument("variableNames");
                variables = getVariables(names);
                values = call.argument("values");
                Variables.trackOpen(variables, values);
                result.success(null);
                break;
            case "clearCache":
                key = call.argument("key");
                if (key == null) {
                    key = "";
                }
                Variables.clearCacheByKey(key);
                result.success(null);
                break;
            case "clearCacheAll":
                Variables.clearCacheAll();
                result.success(null);
                break;
            case "trackClick":
                names = call.argument("variableNames");
                variables = getVariables(names);
                values = call.argument("values");
                Variables.trackClick(variables, values);
                result.success(null);
                break;
            default:
                result.notImplemented();
        }
    }

    private void handleVariableMethodCall(String methodName, MethodCall call, Result result) {
        String name = call.argument("name");
        if (name == null) {
            name = "";
        }
        if (name.isEmpty()) {
            Logger.w(LOG_TAG, "Variable has empty name, return default value.");
        }
        Variable variable = Variables.get(name);
        Object defaultValue = call.argument("default");
        switch (methodName) {
            case "getString":
                result.success(variable.getString((String) defaultValue));
                break;
            case "getInteger":
                Long def;
                if (defaultValue instanceof Integer) {
                    def = ((Integer) defaultValue).longValue();
                } else {
                    def = (Long) defaultValue;
                }
                result.success(variable.getLong(def));
                break;
            case "getDouble":
                result.success(variable.getDouble((Double) defaultValue));
                break;
            case "getBoolean":
                result.success(variable.getBoolean((Boolean) defaultValue));
                break;
            case "getArray":
                JSONArray jsonArray = new JSONArray((List<?>) defaultValue);
                result.success(ExtensionsKt.toList(variable.getJSONArray(jsonArray)));
                break;
            case "getObject":
                JSONObject jsonObject = new JSONObject((Map<String, ?>) defaultValue);
                result.success(ExtensionsKt.toMap(variable.getJSONObject(jsonObject)));
                break;
            default:
                result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    private List<Variable> getVariables(@Nullable List<String> names) {
        List<Variable> variables = new ArrayList<>();
        if (names == null) return variables;
        for (String name : names) {
            variables.add(Variables.get(name));
        }
        return variables;
    }
}
