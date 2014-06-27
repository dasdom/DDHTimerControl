Pod::Spec.new do |s|
  s.name             = "DDHTimerControl"
  s.version          = "1.0.0"
  s.summary          = "A UIControl subclass to input seconds or minutes."
  s.homepage         = "https://github.com/dasdom/DDHTimerControl"
  s.license          = 'MIT'
  s.author           = { "Dominik Hauser" => "dominik.hauser@dasdom.de" }
  s.source           = { :git => "https://github.com/dasdom/DDHTimerControl.git", :tag => s.version.to_s }
  s.screenshot       = "https://raw.githubusercontent.com/dasdom/DDHTimerControl/master/DDHTimerControlDemo/screenshot.png" 
  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'DDHTimerControl/*' 
end
