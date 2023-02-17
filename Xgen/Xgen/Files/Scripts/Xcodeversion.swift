//
//  Xcodeversion.swift
//  Xgen
//
//  Created by Marcos Ferreira on 09/09/22.
//

enum Xcodeversion {
    case content(_ podName: String, hasSample: Bool)
    
    var value: String {
        switch self {
        case .content(let podName, let hasSample):
            return """
            require 'xcodeproj'

            project_path = '{PODNAME}.xcodeproj'
            project = Xcodeproj::Project.open(project_path)
            version = ""
            buildVersion = "0"

            versionFile = File.read("version").split
            version = versionFile[0]
            buildVersion = versionFile[1]

            # Update project version

            project.targets.each do |target|
                if target.name == "{PODNAME}"{HAS_SAMPLE}then
                    target.build_configurations.each do |config|
                        puts config.name
                        config.build_settings['MARKETING_VERSION'] = version
                        config.build_settings['CURRENT_PROJECT_VERSION'] = buildVersion
                        puts 'MARKETING_VERSION = ' + version
                        puts 'CURRENT_PROJECT_VERSION = ' + buildVersion
                    end
                end
            end

            project.save

            # Update .podspec version

            podspec_path = '{PODNAME}.podspec'
            podspec = File.read(podspec_path)
            new_podspec = podspec.gsub(/s.version\\s[^a-zA-Z0-9]+.*'/, "s.version = '" + version + "'")

            File.open(podspec_path, "w") { |file|
                file.puts new_podspec
            }

            # Update README version

            readme_path = 'README.md'
            readme = File.read(readme_path)
            new_readme = readme.gsub(/[0-9]+.*'/, version + "'")

            File.open(readme_path, "w") { |file|
                file.puts new_readme
            }

            puts 'Podspec Version = ' + version
            puts 'README Version = ' + version
            puts 'MARKETING_VERSION = ' + version
            puts 'CURRENT_PROJECT_VERSION = ' + buildVersion
            """
                .replacingOccurrences(of: "{HAS_SAMPLE}", with: hasSample ? " || target.name == \"{PODNAME}Sample\" " : " ")
                .replacingOccurrences(of: "{PODNAME}", with: podName)
        }
    }
}
