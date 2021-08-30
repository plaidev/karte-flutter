package io.karte.flutter.karte_core_example

import io.flutter.app.FlutterApplication
import io.karte.android.KarteApp
import io.karte.android.core.logger.LogLevel

class Application : FlutterApplication() {

    override fun onCreate() {
        super.onCreate()
        KarteApp.setLogLevel(LogLevel.DEBUG)
        KarteApp.setup(this)
    }
}
