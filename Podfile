# Uncomment this line to define a global platform for your project
platform :ios, '9.0'
use_frameworks!

target 'ProcedureKitMemoryLeaks' do

  pod 'ProcedureKit',
          :git => 'https://github.com/procedurekit/procedurekit',
          :branch => 'feature/OPR-622_memory_leaks',
          :commit => '6b1e40e591ece572ca0cb6aa28e9e1c1aa1c7aa5'

  pod 'ProcedureKit/Cloud',
          :git => 'https://github.com/procedurekit/procedurekit',
          :branch => 'feature/OPR-622_memory_leaks',
          :commit => '6b1e40e591ece572ca0cb6aa28e9e1c1aa1c7aa5'

      pod 'ProcedureKit/Mobile',
          :git => 'https://github.com/procedurekit/procedurekit',
          :branch => 'feature/OPR-622_memory_leaks',
          :commit => '6b1e40e591ece572ca0cb6aa28e9e1c1aa1c7aa5'

end

# Post pod install hook to set the Swift Version to use in build settings.
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
