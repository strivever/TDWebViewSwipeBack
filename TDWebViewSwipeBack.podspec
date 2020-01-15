#
# Be sure to run `pod lib lint TDWebViewSwipeBack.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TDWebViewSwipeBack'
  s.version          = '0.1.2'
  s.summary          = 'iOS webview and WKWebView swipe back '

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/strivever/TDWebViewSwipeBack.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '458362366@qq.com' => '458362366@qq.com' }
  s.source           = { :git => 'https://github.com/strivever/TDWebViewSwipeBack.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'

  s.source_files = 'TDWebViewSwipeBack/Classes/*.{h,m}'
  
  s.public_header_files = 'TDWebViewSwipeBack/Classes/**/*.h'
  s.frameworks = 'UIKit'
end
