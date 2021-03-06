#
# Be sure to run `pod lib lint ReactiveTexture.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ReactiveTexture'
  s.version          = '0.8'
  s.summary          = 'ReactiveSwift support for Texture'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  ReactiveSwift support for Texture framework.
                         DESC

  s.homepage         = 'https://bitbucket.org/mmulyar/reactivetexture.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mikhailmulyar' => 'mulyarm@gmail.com' }
  s.source           = { :git => 'https://bitbucket.org/mmulyar/reactivetexture.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'
  s.source_files = 'ReactiveTexture/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ReactiveTexture' => ['ReactiveTexture/Assets/*.png']
  # }

  s.dependency 'Texture', '~> 3.0'
  s.dependency 'ReactiveCocoa', '~> 11.0'

end
