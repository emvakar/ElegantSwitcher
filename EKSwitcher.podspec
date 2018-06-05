Pod::Spec.new do |s|
    s.platform = :ios
    s.ios.deployment_target = '10.0'
    s.name = "EKSwitcher"
    s.summary = "EKSwitcher is swift 4 framework extensions kit."
    s.requires_arc = true
    s.version = "1.0.0"
    s.license = { :type => "MIT", :file => "LICENSE" }
    s.author = { "Emil Karimov" => "emvakar@gmail.com" }
    s.homepage = "https://github.com/emvakar/ElegantSwitcher.git"
    s.source = { :git => "https://github.com/emvakar/ElegantSwitcher.git", :tag => "#{s.version}"}
    s.framework = "UIKit"
    s.source_files = "ElegantSwitcher/**/*.{swift}"
    s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
end
