package com.example.karte_flutter

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService
import io.karte.android.KarteApp
import io.karte.android.core.logger.LogLevel
import io.karte.flutter.notifications.KarteNotificationPlugin

class Application : FlutterApplication(), PluginRegistry.PluginRegistrantCallback {

    override fun onCreate() {
        super.onCreate()

        FlutterFirebaseMessagingService.setPluginRegistrant(this)
        KarteApp.setLogLevel(LogLevel.DEBUG)
        KarteApp.setup(this)
    }

    override fun registerWith(registry: PluginRegistry?) {
        if (registry?.hasPlugin("io.flutter.plugins.firebasemessaging") == false) {
            FirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasemessaging"))
        }
        // Register karte_notifications to firebase_messaging's background FlutterNativeView, for handling background message.
        if (registry?.hasPlugin("io.karte.flutter.notifications") == false) {
            KarteNotificationPlugin.registerWith(registry.registrarFor("io.karte.flutter.notifications"))
        }
    }
}
