#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint karte_visual_tracking.podspec' to validate before publishing.
#
require "yaml"

pubspec = YAML.load_file("../pubspec.yaml")

Pod::Spec.new do |s|
  s.name             = 'karte_visual_tracking'
  s.version          = pubspec['version']
  s.summary          = pubspec['description']
  s.description      = <<-DESC
Flutter plugin for KARTE Visual Tracking.
                       DESC
  s.homepage         = pubspec['homepage']
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'karte_core'
  s.dependency 'KarteVisualTracking', '~> 2'
  s.platform = :ios, '9.0'
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.1'
end
