#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'open_file'
  s.version          = '0.0.1'
  s.summary          = 'A plug-in that can call native APP to open files with string result in flutter, support iOS(DocumentInteraction) / android(intent) / PC(ffi) / web(dart:html)'
  s.description      = <<-DESC
A new Flutter project.
                       DESC
  s.homepage         = 'https://github.com/crazecoder/open_file'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'crazecoder' => '21527312@qq.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  
  s.ios.deployment_target = '8.0'
end

