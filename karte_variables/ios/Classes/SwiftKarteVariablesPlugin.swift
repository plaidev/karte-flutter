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
import karte_core
import KarteVariables

public class SwiftKarteVariablesPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "karte_variables", binaryMessenger: registrar.messenger())
        let instance = SwiftKarteVariablesPlugin()
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
        let arguments = call.arguments as? [String:Any?] ?? [:]
        switch className {
        case "Variables":
            switch methodName {
            case "fetchWithResult":
                Variables.fetch {success in
                    DispatchQueue.main.async {
                        result(NSNumber(value: success))
                    }
                }
            case "get":
                if let key = arguments["key"] as? String {
                    result(Variables.variable(forKey: key).name)
                } else {
                    Logger.warn(tag: .flutter, message: "Variables.get didn't get argument 'key', return empty Variable instance.")
                    result("")
                }
            case "trackOpen":
                let names = arguments["variableNames"] as? [String] ?? []
                let variables = names.map {Variables.variable(forKey: $0)}
                let values = convertValues(arguments["values"])
                Tracker.trackOpen(variables: variables, values: values)
                result(nil)
            case "trackClick":
                let names = arguments["variableNames"] as? [String] ?? []
                let variables = names.map {Variables.variable(forKey: $0)}
                let values = convertValues(arguments["values"])
                Tracker.trackClick(variables: variables, values: values)
                result(nil)
            case "clearCache":
                let key = arguments["key"] as? String ?? ""
                Variables.clearCache(forKey: key)
                result(nil)
            case "clearCacheAll":
                Variables.clearCacheAll()
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        case "Variable":
            let name = arguments["name"] as? String ?? ""
            if (name.isEmpty) {
                Logger.warn(tag: .flutter, message: "Variable has empty name, return default value.")
            }
            let variable = Variables.variable(forKey: name)
            let defaultValue = arguments["default"]
            switch methodName {
            case "getString":
                result(variable.string(default: defaultValue as! String))
            case "getInteger":
                let def = defaultValue as! NSNumber
                result(NSNumber(value: variable.integer(default: def.intValue)))
            case "getDouble":
                let def = defaultValue as! NSNumber
                result(NSNumber(value: variable.double(default: def.doubleValue)))
            case "getBoolean":
                let def = defaultValue as! NSNumber
                result(NSNumber(value: variable.bool(default: def.boolValue)))
            case "getArray":
                result(variable.array(default: defaultValue as! [Any]))
            case "getObject":
                result(variable.dictionary(default: defaultValue as! [String:Any]))
            default:
                result(FlutterMethodNotImplemented)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func convertValues(_ values: Any??) -> [String:JSONConvertible] {
        guard let values = values as? [String:Any] else {
            return [:]
        }
        return JSONConvertibleConverter.convert(values)
    }
}
