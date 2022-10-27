Pod::Spec.new do |s|
  s.name             = 'Preference'
  s.version          = '1.0.2'
  s.summary          = 'The property wrapper for UserDefaults.'
  s.description      = <<-DESC
Preference provides property wrapper for UserDefaults and custom Combine publisher that bind a stream for changes.
                       DESC
  s.homepage         = 'https://github.com/hdtls/swift-preference'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Junfeng Zhang' => 'ph.gitio@gmail.com' }
  s.source           = { :git => 'https://github.com/hdtls/swift-preference.git', :tag => s.version }

  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'

  s.source_files = 'Sources/Preference/*.swift'

  s.swift_version = '5'
end
