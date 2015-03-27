Pod::Spec.new do |s|
  s.name     = 'SLAlertView'
  s.version  = '1.0.1'
  s.license  = 'MIT'
  s.summary  = 'iOS Custom Alert View.'
  s.homepage = 'https://github.com/SugarLSG/SLAlertView'
  s.authors  = { 'sugar.lin' => '339426723@qq.com' }
  s.source   = { :git => 'https://github.com/SugarLSG/SLAlertView.git', :tag => s.version, :submodules => true }
  s.requires_arc = true

  s.ios.deployment_target = '7.0'

  #s.public_header_files = 'SLStaticLibrary/*.h'
  s.source_files = 'SLAlertView/*.{h,m}'
  s.resource = 'SLAlertView/SLAlertView.bundle'
end
