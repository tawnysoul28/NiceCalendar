#
# Be sure to run `pod lib lint NiceCalendar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NiceCalendar'
  s.version          = '0.1.0'
  s.summary          = 'NiceCalendar is a convinient calendar to choose dates.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
'NiceCalendar is an awesome pod aimed to make your life easier around choose dates in calendar'
                       DESC

  s.homepage         = 'https://github.com/tawnysoul28/NiceCalendar'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'tawnysoul28' => 'tawnysoul@gmail.com' }
  s.source           = { :git => 'https://github.com/tawnysoul28/NiceCalendar.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'NiceCalendar/Source/**/*'
  s.platforms = {
	  "ios": "11.0"
  }
  
  # s.resource_bundles = {
  #   'NiceCalendar' => ['NiceCalendar/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'HorizonCalendar', '~> 1.8.6'
end
