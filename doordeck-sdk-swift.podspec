Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '10.0'
s.name = "doordeck-sdk-swift"
s.summary = "Doordeck allows you to unlock your access control doors via your phone, visit Doordeck.com for more details"
s.requires_arc = true

# 2
s.version = "0.0.2"

# 3
s.license = { :type => "Apache", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Doordeck" => "support@doordeck.com" }

# 5 - Replace this URL with your own GitHub page's URL (from the address bar)
s.homepage = "https://github.com/doordeck/doordeck-sdk-swift"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/doordeck/doordeck-sdk-swift.git" , 
             :tag => "#{s.version}" }

# 7
s.framework = "UIKit"
s.dependency 'Alamofire', '~> 4.8'
s.dependency 'Cache', '~> 5.2'
s.dependency 'QRCodeReader.swift', '~> 10.0'
s.dependency 'ReachabilitySwift', '~> 4.3'
s.dependency 'SwiftyRSA', '~> 1.5'

# 8
s.source_files = "doordeck-sdk-swift/**/*.{swift}"

# 9
s.resources = "doordeck-sdk-swift/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

# 10
s.swift_version = "5"

end
