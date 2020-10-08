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
import KarteInAppMessaging

public class SwiftKarteInAppMessagingPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "karte_in_app_messaging", binaryMessenger: registrar.messenger())
        let instance = SwiftKarteInAppMessagingPlugin()
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
        case "InAppMessaging":
            switch methodName {
            case "isPresenting":
                result(NSNumber(value: InAppMessaging.shared.isPresenting))
            case "dismiss":
                InAppMessaging.shared.dismiss()
                result(nil)
            case "suppress":
                InAppMessaging.shared.suppress()
                result(nil)
            case "unsuppress":
                InAppMessaging.shared.unsuppress()
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
