package io.karte.flutter.visual_tracking;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.karte.android.core.logger.Logger;
import io.karte.android.visualtracking.BasicAction;
import io.karte.android.visualtracking.ImageProvider;
import io.karte.android.visualtracking.VisualTracking;

public class KarteVisualTrackingPlugin implements FlutterPlugin, MethodCallHandler {

    private static final String LOG_TAG = "KarteFlutter";
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "karte_visual_tracking");
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
        KarteVisualTrackingPlugin plugin = new KarteVisualTrackingPlugin();
        MethodChannel channel = new MethodChannel(registrar.messenger(), "karte_visual_tracking");
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
        if ("VisualTracking".equals(className)) {
            handleVisualTrackingMethodCall(methodName, call, result);
        } else {
            result.notImplemented();
        }
    }

    private void handleVisualTrackingMethodCall(String methodName, final MethodCall call, Result result) {
        switch (methodName) {
            case "handle":
                String actionName = call.argument("action");
                if (actionName == null) {
                    return;
                }
                ImageProvider imageProvider = null;
                final byte[] imageData = call.argument("imageData");
                if (imageData != null) {
                    imageProvider = new ImageProvider() {
                        @Nullable
                        @Override
                        public Bitmap image() {
                            Bitmap bitmap = BitmapFactory.decodeByteArray(imageData, 0, imageData.length);
                            double x = call.argument("offsetX");
                            double y = call.argument("offsetY");
                            double width = call.argument("imageWidth");
                            double height = call.argument("imageHeight");

                            Bitmap croppedBitmap = Bitmap.createBitmap(bitmap, (int) x, (int) y, (int) width, (int) height);
                            bitmap.recycle();

                            return croppedBitmap;
                        }
                    };
                }

                BasicAction action = new BasicAction(
                        actionName,
                        (String) call.argument("actionId"),
                        (String) call.argument("targetText"),
                        imageProvider);

                VisualTracking.handle(action);
                result.success(null);
                break;
            case "isPaired":
                result.success(VisualTracking.isPaired());
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
