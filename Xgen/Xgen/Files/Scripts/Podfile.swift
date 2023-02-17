//
//  Podfile.swift
//  Xgen
//
//  Created by Marcos Ferreira on 09/09/22.
//

enum Podfile {
    case content(_ podName: String, hasSample: Bool, hasTests: Bool)
    
    var value: String {
        switch self {
        case .content(let podName, let hasSample, let hasTests):
            let testSnippet = """
            
              target '{PODNAME}Tests' do
                inherit! :search_paths
              end
            end
            """
            
            let sampleSnippet = """
            
            target '{PODNAME}Sample' do
              use_frameworks!
              pods_dependencies
            end
            
            """
            
            return """
            source 'https://github.com/CocoaPods/Specs.git'
            platform :ios, '12.4'

            #load "../OneApp/CorePods.rb"

            def pt_private_pods
              
            end

            def pl_thirdparty_library
              #pod 'CryptoSwift', '1.4.0'
              pod 'IQKeyboardManagerSwift', '6.5.6'
              pod 'Kingfisher', '5.15.8'
              #pod 'SwiftLint', '0.43.1'
              #pod 'lottie-ios'
              #pod 'SQLCipher', '4.4.2'
              #pod 'Alamofire-Synchronous', '4.0'
              #pod 'TealiumIOS', '5.6.6'
              #pod 'Dynatrace', '~> 8.239'
              #pod 'Firebase/Analytics'
              #pod 'Firebase/Messaging'
              #pod 'Firebase/DynamicLinks'
              #pod 'SelligentMobileSDK', :git => 'https://github.com/SelligentMarketingCloud/MobileSDK-iOS.git', :tag => '2.5.1'
              #pod 'Qualtrics'
            end

            # def core_test
            #   unit_test_commons
            #   core_test_data
            # end
              
            def pods_dependencies
            #   core_features
              pt_private_pods
              pl_thirdparty_library
            end

            target '{PODNAME}' do
              use_frameworks!
              pods_dependencies
            {HAS_TESTS}
            {HAS_SAMPLE}
            post_install do |installer|
              installer.pods_project.targets.each do |target|
                target.build_configurations.each do |config|
                  config.build_settings['ENABLE_BITCODE'] = 'NO'
                  
                  if not ["deploy"].include? config.name
                    config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
                    config.build_settings['GCC_OPTIMIZATION_LEVEL'] = '0'
                    config.build_settings['ONLY_ACTIVE_ARCH'] = 'YES'
                    config.build_settings['SWIFT_VERSION'] = '5.0'
                    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
                    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.4'
                    config.build_settings['ENABLE_TESTABILITY'] = 'YES'
                  end

                  if config.name == "Release" || config.name == "Pre-appstore"
                    config.build_settings['ENABLE_BITCODE'] = 'YES'
                    config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Osize'
                  else
                    config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['$(inherited)', '-D INSECURE_WEBVIEWS']
                  end
                end
              end
            end
            """
                .replacingOccurrences(of: "{HAS_TESTS}", with: hasTests ? testSnippet : "end")
                .replacingOccurrences(of: "{HAS_SAMPLE}", with: hasSample ? sampleSnippet : "")
                .replacingOccurrences(of: "{PODNAME}", with: podName)
        }
    }
}
