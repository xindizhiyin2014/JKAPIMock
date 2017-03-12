#
# Be sure to run `pod lib lint JKAPIMock.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JKAPIMock'
  s.version          = '0.1.0'
  s.summary          = 'this is a tool to help iOS developer mock API data to support parallel development.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
this is a tool to help iOS developer mock API data to support parallel development,if have any question please contact with jack
                       DESC

  s.homepage         = 'https://github.com/xindizhiyin2014/JKAPIMock'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'HHL110120' => '929097264@qq.com' }
  s.source           = { :git => 'https://github.com/xindizhiyin2014/JKAPIMock.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'JKAPIMock/Classes/**/*'
  
  # s.resource_bundles = {
  #   'JKAPIMock' => ['JKAPIMock/Assets/*.png']
  # }

   s.public_header_files = 'JKAPIMock/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'GYHttpMock'
end
