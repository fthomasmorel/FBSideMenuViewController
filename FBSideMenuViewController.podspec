Pod::Spec.new do |s|
  s.name             = "FBSideMenuViewController"
  s.version          = "0.1.0"
  s.summary          = "A nice way to interact with a side menu"
  s.homepage         = "https://github.com/fthomasmorel/FBSideMenuViewController"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "fthomasmorel" => "fthomasm@insa-rennes.fr" }
  s.source           = { :git => "https://github.com/fthomasmorel/FBSideMenuViewController.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.1'
  s.requires_arc = true

  s.source_files = 'Pod/*'

end
