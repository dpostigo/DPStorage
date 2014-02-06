Pod::Spec.new do |s|
  s.name         = "DPStorage"
  s.version      = "0.0.6"
  s.summary      = "Storage classes"
  s.homepage     = "http://dpostigo.com"
  s.license      = 'BSD'
  s.author       = { "Dani Postigo" => "dani@firstperson.is" }
  s.source       = { :git => "https://github.com/dpostigo/DPStorage.git", :tag => s.version.to_s }
  s.requires_arc = true


  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.8'

  s.source_files = 'DPStorage/**/*.{h,m}'
  


  s.dependency   'AutoCoding'
  s.dependency   'NSObject+AutoDescription'
  s.dependency   'DPKit'
  s.dependency   'DPObject'








end
