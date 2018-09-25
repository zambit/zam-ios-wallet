use_frameworks!

target "wallet" do
  pod "PromiseKit", "~> 6.0"
  pod "FlagKit", "~> 2.0.1"
  pod "PhoneNumberKit", "~> 2.1"
  pod "ESTabBarController-swift"
  pod "Hero"
  pod "DifferenceKit"

  post_install do |installer|
    	installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.0'
            end
    	end
  end
end
