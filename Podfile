# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'NativeIconSpeaker' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
pod 'GoogleMaps'
pod 'GooglePlaces'
pod 'SwiftyJSON'
pod ‘Alamofire’
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
      config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.12'
    end
  end
end
  # Pods for NativeIconSpeaker

end
