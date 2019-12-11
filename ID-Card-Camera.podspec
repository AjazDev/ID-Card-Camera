Pod::Spec.new do |s|
  s.name             = 'ID-Card-Camera'
  s.module_name      = 'IDCardCamera'
  s.version          = '1.0.0'
  s.summary          = 'Detects an ID card in a camera view and returns the de-warped image of the ID card.'
  s.homepage         = 'https://github.com/AppliedRecognition'
  s.license          = { :type => 'MIT', :file => 'LICENCE' }
  s.author           = { 'jakubdolejs' => 'jakubdolejs@gmail.com' }
  s.source           = { :git => 'https://github.com/AppliedRecognition/ID-Card-Camera.git', :tag => "v#{s.version}" }
  s.platform	     = :ios, '11.0'
  s.source_files = 'IDCardCamera/*.swift'
  s.resources = 'IDCardCamera/*.{xcassets,xib}'
  s.frameworks = 'UIKit', 'Vision', 'Accelerate', 'CoreMedia', 'AVFoundation'
end