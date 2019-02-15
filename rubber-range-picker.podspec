#
# Be sure to run `pod lib lint rubber-range-picker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'rubber-range-picker'
  s.version          = '0.8.0'
  s.swift_version    = '4.2'
  s.summary          = 'Two-sided slider with elastic behavior'
  s.homepage         = 'https://github.com/Cuberto/rubber-range-picker'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Anton Skopin' => 'askopin@gmail.com' }
  s.source           = { :git => 'https://github.com/Cuberto/rubber-range-picker.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/cuberto'

  s.ios.deployment_target = '9.3'

  s.source_files = 'rubber-range-picker/Classes/**/*'
end
