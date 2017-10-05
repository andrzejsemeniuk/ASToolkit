#
#  Be sure to run `pod spec lint ASToolkit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "ASToolkit"
  s.version      = "0.1.4.1"
  s.summary      = "A utility framework of useful and convenient additions and extensions to iOS in Swift"
  s.description  = "A utility framework of useful and convenient additions and extensions to iOS in Swift!"
  s.homepage     = "https://github.com/andrzejsemeniuk/ASToolkit"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = "Andrzej Semeniuk"
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/andrzejsemeniuk/ASToolkit.git", :tag => "release/#{s.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.source_files  = "ASToolkit", "ASToolkit/**/*.{h,swift}"
  
  s.exclude_files = "ASToolkitTests/**", "UIViewShowcase/**", "UIViewShowcaseTests", "UIViewShowcaseUITests"

  s.requires_arc  = true

  s.pod_target_xcconfig =  {
        'SWIFT_VERSION' => '3.2',
  }

end
