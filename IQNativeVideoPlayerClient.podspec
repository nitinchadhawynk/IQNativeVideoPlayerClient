#
# Be sure to run `pod lib lint IQNativeVideoPlayerClient.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'IQNativeVideoPlayerClient'
  s.version          = '1.0.6'
  s.summary          = 'IQNativeVideoPlayerClient provides a layer of Video Player.'
  s.description      = 'IQNativeVideoPlayerClient provides a layer of Video Player with bunch of capabilities like MultiAudio, Subtitles, ErrorHandling and more'
  s.homepage         = 'https://github.com/nitinchadhawynk/IQNativeVideoPlayerClient'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'nitinchadhawynk' => 'nitin.chadha@wynk.in' }
  s.source           = { :git => 'https://github.com/nitinchadhawynk/IQNativeVideoPlayerClient.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'
  s.tvos.deployment_target = '15.0'

  s.source_files = 'IQNativeVideoPlayerClient/Classes/**/*'
  
  # s.resource_bundles = {
  #   'IQNativeVideoPlayerClient' => ['IQNativeVideoPlayerClient/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'IQVideoPlayer', '1.0.8.5'
end
