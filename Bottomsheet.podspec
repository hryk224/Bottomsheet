Pod::Spec.new do |s|
  s.name         = "Bottomsheet"
  s.version      = “1.1.0”
  s.summary      = "Component which presents a dismissible view from the bottom of the screen."
  s.homepage     = "https://github.com/hryk224/Bottomsheet"
  s.screenshots  = "https://github.com/hryk224/Bottomsheet/wiki/images/sample3.gif"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "hyyk224" => "hryk224@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/hryk224/Bottomsheet.git", :tag => "#{s.version}" }
  s.source_files  = "Bottomsheet/*.{h,swift}"
  s.frameworks = "UIKit"
  s.requires_arc = true
end
