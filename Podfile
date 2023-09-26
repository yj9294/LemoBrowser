# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
source 'https://cdn.cocoapods.org/'

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            end
        end
    end
end

target 'Lemon' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Lemon
  pod 'GoogleMLKit/Translate'
  pod 'GoogleMLKit/LanguageID'
  pod 'GoogleMLKit/TextRecognition'
  pod 'GoogleMLKit/TextRecognitionChinese'
  pod 'GoogleMLKit/TextRecognitionDevanagari'
  pod 'GoogleMLKit/TextRecognitionJapanese'
  pod 'GoogleMLKit/TextRecognitionKorean'
  pod 'GADUtil'
end
