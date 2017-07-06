Pod::Spec.new do |s|

  s.platform = :ios
  s.ios.deployment_target = '9.0'
  s.name = "JackpotRising"
  s.summary = "Jackpot Rising is a patent pending software solution that you can integrate into your games, that enables your users to compete against."
  s.requires_arc = true
 
  s.version = "3.0"
  s.license = { :type => "Apache", :file => "LICENSE" }
  s.author = { "Nick Wallace" => "developer@jackpotrising.com" }
 
  s.homepage = "https://github.com/JackpotRising"
 
  s.source = { :git => "https://github.com/prethushpj1/jrv3.git", :tag => "#{s.version}"}

  s.framework = 'UIKit', 'Accelerate', 'MobileCoreServices', 'QuartzCore', 'Security', 'CoreLocation'

  s.source_files = 'JackpotRising/**/*.{swift,h,m}'

  s.module_map = 'JackpotRising/module.modulemap'
  s.resources = 'JackpotRising/Resources/*.{xcassets,ttf}',
                'JackpotRising/Views/*.{storyboard,xib}'

  s.libraries = 'icucore'

  s.pod_target_xcconfig = { "OTHER_LDFLAGS" => "$(inherited) -ObjC", "EMBEDDED_CONTENT_CONTAINS_SWIFT" => "YES", 'CLANG_ENABLE_MODULES' => 'YES', 'DEFINES_MODULE' => 'YES', 'SWIFT_VERSION' => '3.0'}

  s.user_target_xcconfig = { "OTHER_LDFLAGS" => "$(inherited) -ObjC", "EMBEDDED_CONTENT_CONTAINS_SWIFT" => "YES", 'CLANG_ENABLE_MODULES' => 'YES', 'DEFINES_MODULE' => 'YES', 'SWIFT_VERSION' => '3.0'}

end