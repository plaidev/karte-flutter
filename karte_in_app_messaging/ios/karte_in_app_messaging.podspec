#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint karte_in_app_messaging.podspec' to validate before publishing.
#
require "yaml"

pubspec = YAML.load_file("../pubspec.yaml")

Pod::Spec.new do |s|
  s.name             = 'karte_in_app_messaging'
  s.version          = pubspec['version']
  s.summary          = pubspec['description']
  s.description      = <<-DESC
Flutter plugin for KARTE In-app Messaging.
                       DESC
  s.homepage         = pubspec['homepage']
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'KarteInAppMessaging', '~> 2'
  s.platform = :ios, '9.0'
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.1'
end
