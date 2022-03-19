//
//  Copyright 2021 PLAID, Inc.
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
import KarteVisualTracking

internal class VisualTrackDelegateHook: VisualTrackingDelegate {
    private static let shared = VisualTrackDelegateHook()
    private var channel: FlutterMethodChannel?

    private init() {}
    
    static func sharedInstance(messenger: FlutterBinaryMessenger) -> VisualTrackDelegateHook {
        shared.channel = FlutterMethodChannel(name: "karte_visual_tracking_dart", binaryMessenger: messenger)
        return shared
    }
        
    func visualTrackingDevicePairingStatusUpdated(_ visualTracking: VisualTracking, isPaired: Bool) {
        DispatchQueue.main.async {
            self.channel?.invokeMethod("pairingStatusUpdated", arguments: isPaired)
        }
    }
}

internal struct DefaultFlutterAction: ActionProtocol {
    let action: String
    
    let actionId: String?
    
    let targetText: String?
    
    let screenName: String?
    
    let screenHostName: String?
    
    let imageProvider: ImageProvider?
    
    func image() -> UIImage? {
        return imageProvider?()
    }
}

public class SwiftKarteVisualTrackingPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "karte_visual_tracking", binaryMessenger: registrar.messenger())
        let instance = SwiftKarteVisualTrackingPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        VisualTracking.shared.delegate = VisualTrackDelegateHook.sharedInstance(messenger: registrar.messenger())
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
        case "VisualTracking":
            switch methodName {
            case "handle":
                let arguments = call.arguments as? [String:Any?]
                var imageProvider: ImageProvider? = nil
                if let imageData = arguments?["imageData"] as? FlutterStandardTypedData {
                    imageProvider = { () -> UIImage? in
                        let rgbaUint8 = [UInt8](imageData.data)
                        let data = NSData(bytes: rgbaUint8, length: rgbaUint8.count)
                        
                        guard let uiimage = UIImage(data: data as Data) else {
                            return nil
                        }
                        
                        guard let x = arguments?["offsetX"] as? Double,
                            let y = arguments?["offsetY"] as? Double,
                            let width = arguments?["imageWidth"] as? Double,
                            let height = arguments?["imageHeight"] as? Double else {
                                return uiimage
                        }
                        
                        if Int(uiimage.size.width - width) <= 0 && Int(uiimage.size.height - height) <= 0 {
                            return uiimage
                        }
                        
                        guard let cropImage = uiimage.cgImage?.cropping(to: .init(x: x, y: y, width: width, height: height)) else {
                            return nil
                        }
                        return UIImage(cgImage: cropImage)
                    }
                }
                
                if let actionName = arguments?["action"] as? String {
                    let action = DefaultFlutterAction(action: actionName,
                                                      actionId: arguments?["actionId"] as? String,
                                                      targetText: arguments?["targetText"] as? String,
                                                      screenName: nil,
                                                      screenHostName: nil,
                                                      imageProvider: imageProvider)
                    VisualTracking.handle(actionProtocol: action)
                } else {
                    Logger.warn(tag: .flutter, message: "VisualTracking.handle didn't get argument 'actionName', NOP.")
                }
                result(nil)
            case "isPaired":
                result(VisualTracking.shared.isPaired)
            default:
                result(FlutterMethodNotImplemented)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
