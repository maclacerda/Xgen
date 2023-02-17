//
//  Makefile.swift
//  Xgen
//
//  Created by Marcos Ferreira on 09/09/22.
//

enum Makefile {
    case content(_ podName: String)
    
    var value: String {
        switch self {
        case .content(let podName):
            return """
            setup_environment:
                @echo "Installing project dependencies for setup"
                @echo "Download and install Homebrew"
                @echo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                @echo "Download and install cocoapods"
                @brew install cocoapods
                @echo "Download and install swiftlint"
                @brew install swiftlint
                @echo "Download and install xcodegen"
                @brew install xcodegen
                @echo "Download and install ruby gems"
                @sudo gem install xcodeproj
                @echo "Setup completed"

            config_scripts_permissions:
                @echo "Applying the scripts permissions"
                @chmod 775 scripts/*.sh
                @echo "Permissions granted successfull"

            project:
                @echo "Generating Project"
                @xcodegen
                @echo "Project generated"

            project_and_open:
                @echo "Generating Project"
                @xcodegen
                @echo "Opening Project"
                @open {PODNAME}.xcodeproj

            clean:
                @echo "Remove all cached dependencies"
                @sh scripts/cleanProject.sh
            """
                .replacingOccurrences(of: "{PODNAME}", with: podName)
        }
    }
}
