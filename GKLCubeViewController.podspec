Pod::Spec.new do |s|
  s.name          = "GKLCubeViewController"
  s.version       = "0.0.1"
  s.summary       = "A 3D rotatable polygon to hold your UIViewControllers"
  s.homepage      = "https://github.com/pyro2927/GKLCubeViewController"
  s.license       = "MIT"
  s.authors       = { "Joe Pintozzi" => "joseph.pintozzi@gmail.com", "Rob Ryan" => "robert.ryan@mindspring.com" }
  s.source        = { :git => "https://github.com/pyro2927/GKLCubeViewController.git" }
  s.platform      = :ios, '5.0'
  s.source_files  = 'CubeViewController/GKLCubeViewController.{h,m}'
  s.framework     = 'QuartzCore'
  s.requires_arc  = true
end
