#
# Be sure to run `pod lib lint DBLineChart.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DBLineChart'
  s.version          = '0.0.2'
  s.summary          = 'LineChart'
  s.description      = 'LineChart'

  s.homepage         = 'https://github.com/DanboDuan/DBLineChart'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'bob' => 'bob170131@gmail.com' }
  s.source           = { :git => 'https://github.com/DanboDuan/DBLineChart.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.public_header_files = 'DBLineChart/LineChart/Header/*.h'
  s.default_subspec = 'LineChart'
  s.requires_arc = true
  s.frameworks = 'Foundation', 'CoreFoundation', 'CoreText', 'CoreGraphics', 'UIKit'

  s.subspec 'Utility' do |utility|
      utility.source_files = 'DBLineChart/Utility/**/*.{h,m,c}'
  end

  s.subspec 'LineChart' do |lineChart|
      lineChart.source_files = 'DBLineChart/LineChart/**/*.{h,m,c}'
      lineChart.dependency 'DBLineChart/Utility'
  end

end
