use_frameworks!
inhibit_all_warnings!


target "doordeck-sdk-swift" do
  platform :ios, "10.0"
  pod "QRCodeReader.swift", "~> 10.0"
  pod "ReachabilitySwift", "~> 4.3"
  pod "Alamofire", "~> 4.8"
  pod "SwiftyRSA", "~> 1.5"
  pod "Cache", "~> 5.2"
  pod "Sodium", :git => "https://github.com/Westacular/swift-sodium.git", :branch => "fix_xcode10.2"
end

target "doordeck-sdk-swiftTests" do
  platform :ios, "10.0"
end

post_install do |installer|
  
  installer.pods_project.build_configurations.each do |config|
    config.build_settings.delete('CODE_SIGNING_ALLOWED')
    config.build_settings.delete('CODE_SIGNING_REQUIRED')
  end
  
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if target.name == 'JSONWebToken'
        print "JSONWebToken \n"
        system("rm -rf Pods/JSONWebToken/CommonCrypto")
      end
    end
  end
  
end
