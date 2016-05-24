Pod::Spec.new do |s|
  s.name         = 'BlueSteel'
  s.version      = '2.3.3'
  s.summary      = 'Avro encoding/decoding library for Swift.'
  s.homepage     = 'https://github.com/gilt/BlueSteel'
  s.license      = { :type => 'MIT' }
  s.source       = { :git => 'https://github.com/gilt/BlueSteel', :tag => s.version }
  s.ios.deployment_target = '7.3'
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.dependency 'SwiftyJSON', '<=2.3.3'
  s.requires_arc = true
  s.source_files = "Sources/*.swift"
end
