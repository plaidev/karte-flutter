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

public class SwiftKarteCorePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "karte_core", binaryMessenger: registrar.messenger())
        let instance = SwiftKarteCorePlugin()
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
        case "KarteApp":
            switch methodName {
            case "getVisitorId":
                result(KarteApp.visitorId)
            case "isOptOut":
                result(KarteApp.isOptOut)
            case "optIn":
                KarteApp.optIn()
                result(nil)
            case "optOut":
                KarteApp.optOut()
                result(nil)
            case "renewVisitorId":
                KarteApp.renewVisitorId()
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        case "Tracker":
            let arguments = call.arguments as? [String:Any?]
            let values: [String:JSONConvertible]
            if let v = arguments?["values"] as? [String:Any] {
                values = JSONConvertibleConverter.convert(v)
            } else {
                values = [:]
            }
            switch methodName {
            case "track":
                if let name = arguments?["name"] as? String {
                    Tracker.track(name, values: values)
                } else {
                    Logger.warn(tag: .flutter, message: "Tracker.track didn't get argument 'name', NOP.")
                }
                result(nil)
            case "identify":
                if let userId = arguments?["userId"] as? String {
                    Tracker.identify(userId, values)
                } else {
                    Tracker.identify(values)
                }
                result(nil)
            case "attribute":
                Tracker.attribute(values)
                result(nil)
            case "view":
                if let viewName = arguments?["viewName"] as? String {
                    Tracker.view(viewName, title: arguments?["title"] as? String, values: values)
                } else {
                    Logger.warn(tag: .flutter, message: "Tracker.view didn't get argument 'viewName', NOP.")
                }
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        case "UserSync":
            let arguments = call.arguments as? [String:Any?]
            switch methodName{
            case "appendingQueryParameter":
                if let url = arguments?["url"] as? String {
                    result(UserSync.appendingQueryParameter(url))
                } else {
                    Logger.warn(tag: .flutter, message: "UserSync.appendingQueryParameter didn't get argument 'url', return null.")
                    result(nil)
                }
            case "getUserSyncScript":
                result(UserSync.getUserSyncScript())
            default:
                result(FlutterMethodNotImplemented)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

extension SwiftKarteCorePlugin: Library {
    public static var name: String {
        "flutter"
    }
    
    public static var version: String {
        KRTFlutterCurrentLibraryVersion()
    }
    
    public static var isPublic: Bool {
        true
    }
    
    public static func configure(app: KarteApp) {
    }
    
    public static func unconfigure(app: KarteApp) {
    }
    
    @objc
    public class func _krt_load() {
        KarteApp.register(library: self)
    }
}

public extension Logger.Tag {
    static let flutter = Logger.Tag("FL", version: SwiftKarteCorePlugin.version)
}
