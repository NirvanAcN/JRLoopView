#
#  Be sure to run `pod spec lint JRTest.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

s.name             = "JRLoopView"
s.version          = "1.0.0"
s.summary          = "JRLoopView 轮播图"

s.description      = <<-DESC
v1.0.0:
1.设置加载图片的方式:网络图片.url, 网络图片.urlString, 本地图片.name
2.设置占位图
3.设置图片ContentMode
4.设置自动滚动时间间隔
        DESC

s.homepage         = "https://github.com/NirvanAcN/JRLoopView"

s.license          = 'MIT'
s.author           = { "NirvanAcN" => "mahaomeng@gmail.com" }
s.source           = { :git => "https://github.com/NirvanAcN/JRLoopView.git", :tag => s.version.to_s }
s.social_media_url = 'http://weibo.com/2743943525'

s.ios.deployment_target = '8.0'
s.platform     = :ios, '8.0'
s.source_files = 'JRLoopView/Classes/**/*'

s.dependency 'SDWebImage'
s.dependency 'JRTimer'

s.frameworks = 'UIKit'

end
