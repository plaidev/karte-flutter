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

import Flutter
import KarteCore
import KarteRemoteNotification

public class SwiftKarteNotificationPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "karte_notification", binaryMessenger: registrar.messenger())
        let instance = SwiftKarteNotificationPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (!call.method.contains("_")) {
            result(FlutterMethodNotImplemented)
            return
        }
        let classAndMethod = call.method.split(separator: "_", maxSplits: 2)
        let className = classAndMethod[0]
        let methodName = classAndMethod[1]
        switch className {
        case "Notification":
            switch methodName {
            case "registerFCMToken":
                if let token = (call.arguments as? [String:Any?])?["fcmToken"] as? String {
                    KarteApp.registerFCMToken(token)
                }
                result(nil)
            default:
                let message = (call.arguments as? [String:Any?])?["message"] as? [String:
                    Any]
                let notification = RemoteNotification(userInfo: message ?? [:])
                switch methodName {
                case "canHandle":
                    result(NSNumber(value: notification != nil))
                case "handle":
                    result(NSNumber(value: notification?.handle() ?? false))
                case "track":
                    notification?.track()
                    result(nil)
                case "url":
                    result(notification?.url?.absoluteString)
                default:
                    result(FlutterMethodNotImplemented)
                }
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
