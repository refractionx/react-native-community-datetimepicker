require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = "RNDateTimePicker"
  s.version      = package['version']
  s.summary      = package['description']
  s.description  = package['description']
  s.license      = package['license']
  s.author       = package['author']
  s.homepage     = package['homepage']
  s.platforms     = { :ios => "11.0", :osx => "10.15" }
  s.source       = { :git => "https://github.com/react-native-community/datetimepicker", :tag => "v#{s.version}" }
  s.ios.source_files = "ios/**/*.{h,m,mm,cpp}"
  s.osx.source_files = "macos/**/*.{h,m,mm,cpp}"
  s.requires_arc = true

  if ENV['RCT_NEW_ARCH_ENABLED'] == '1'
    install_modules_dependencies(s)
  else
    s.exclude_files = "ios/fabric"
    s.exclude_files = "macos/fabric"

    s.dependency "React-Core"
  end
end
