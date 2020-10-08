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

#import "KarteCorePlugin.h"
#if __has_include(<karte_core/karte_core-Swift.h>)
#import <karte_core/karte_core-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "karte_core-Swift.h"
#endif

#define STR_EXPAND(x) #x
#define STR(x) STR_EXPAND(x)

@implementation KarteCorePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftKarteCorePlugin registerWithRegistrar:registrar];
}

+ (void)load {
  [SwiftKarteCorePlugin _krt_load];
}
@end

NSString * KRTFlutterCurrentLibraryVersion(void) {
    return [NSString stringWithUTF8String:STR(KARTE_FLUTTER_VERSION)];
}
