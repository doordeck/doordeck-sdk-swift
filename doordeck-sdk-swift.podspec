Pod::Spec.new do | spec |

spec.platform = :ios
spec.ios.deployment_target = '10.0'
spec.name = "doordeck-sdk-swift"
spec.social_media_url = "https://twitter.com/doordeck"
spec.summary = "Doordeck allows you to unlock your access control doors via your phone, visit Doordeck.com for more details"
spec.requires_arc = true


spec.version = "0.1.0"

spec.license = { :type => "Apache", :file => "LICENSE" }

spec.author = { "Doordeck" => "support@doordeck.com" }

spec.homepage = "https://github.com/doordeck/doordeck-sdk-swift"

spec.source = { :git => "https://github.com/doordeck/doordeck-sdk-swift.git" ,
             :tag => "#{spec.version}" }

spec.ios.framework = "UIKit"
spec.dependency 'DoordeckSDK' , '~> 0.106.0'
spec.dependency 'QRCodeReader.swift', '~> 10.0'
spec.dependency 'ReachabilitySwift', '~> 4.3'

spec.source_files = "doordeck-sdk-swift/**/*.{h,swift,storyboard,xib,xcassets,plist,png,jpeg,jpg}"

spec.pod_target_xcconfig = {"PRODUCT_BUNDLE_IDENTIFIER" => "com.doordeck.doordeck-sdk-swiftTests" ,"DEVELOPMENT_TEAM" => "Doordeck limited"}

#spec.resources = "doordeck-sdk-swift/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

spec.swift_version = '4.2'

end
