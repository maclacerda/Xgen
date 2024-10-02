//
//  FilesContent.swift
//  Xgen
//
//  Created by Marcos Ferreira on 09/09/22.
//

import Foundation

protocol Content {
    var command: String { get }
}

extension Content {
    var command: String {
        return ""
    }
}

enum FilesContent {
    
    enum Structure: Content {
        case cleanProject(_ podName: String)
        case postgen
        case xcodeversion(_ podName: String, hasSample: Bool)
        case projectYml
        case readme(_ podName: String, repoName: String, repoPath: String, author: String, authorMail: String)
        case makefile(_ podName: String)
        case codeowners
        case license
        case podfile(_ podName: String, hasSample: Bool, hasTests: Bool)
        case podspec(_ podName: String, repoName: String, author: String, authorMail: String)
        
        private var content: String {
            switch self {
            case .cleanProject(let podName):
                return CleanProject.content(podName).value
            case .postgen:
                return Postgen.content.value
            case .xcodeversion(let podName, let hasSample):
                return Xcodeversion.content(podName, hasSample: hasSample).value
            case .projectYml:
                return ProjectYML.content.value
            case .readme(let podName, let repoName, let repoPath, let author, let authorMail):
                return Readme.content(podName, repoName: repoName, repoPath: repoPath, author: author, authorMail: authorMail).value
            case .makefile(let podName):
                return Makefile.content(podName).value
            case .codeowners:
                return CodeOwners.content.value
            case .license:
                return License.content.value
            case .podfile(let podName, let hasSample, let hasTests):
                return Podfile.content(podName, hasSample: hasSample, hasTests: hasTests).value
            case .podspec(let podName, let repoName, let author, let authorMail):
                return Podspec.content(podName, repoName: repoName, author: author, authorMail: authorMail).value
            }
        }
        
        var command: String {
            return String(format: "echo \"%@\" >> %@", self.content, self.fileName)
        }

        var fileName: String {
            switch self {
            case .podspec(let podName, _, _, _):
                return String(format: "%@.podspec", podName)
            case .readme:
                return "README.md"
            case .license:
                return "LICENSE"
            case .makefile:
                return "Makefile"
            case .podfile:
                return "Podfile"
            case .codeowners:
                return "CODEOWNERS"
            case .projectYml:
                return "project.yml"
            case .xcodeversion:
                return "scripts/xcodeversion.rb"
            case .postgen:
                return "scripts/postgen.sh"
            case .cleanProject:
                return "scripts/cleanProject.sh"
            }
        }
    }
    
    enum Pod: CaseIterable, Content {
        case strings
        case header
        case plist
    }
    
    enum Sample: CaseIterable, Content {
        case accentColor
        case appIcon
        case contents
        case storyboard
        case launcher
        case coordinator
        case appdelegate
        case plist
    }
    
    enum Mocks: CaseIterable, Content {
        
    }
    
    enum Tests: CaseIterable, Content {
        case plist
    }
    
}
