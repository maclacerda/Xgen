//
//  Commands.swift
//  Xgen
//
//  Created by Marcos Ferreira on 08/09/22.
//

import Foundation

enum Commands {
    case folder(name: String)
    case subfolder(root: String, name: String)
    case podfile
    case podspec(_ podName: String)
    case file(root: String? = nil, name: String, type: String? = nil)
    case readme
    case codeowners
    case makefile
    case license
    case projectYml
    case versionFile(version: String, build: String)
    
    var command: String {
        switch self {
        case .folder(let name):
            return "mkdir \(name)"

        case .subfolder(let root, let name):
            return "mkdir -p \(root)/\(name)"

        case .podfile:
            return "touch Podfile"
            
        case .podspec(let podName):
            return "touch \(podName).podspec"

        case .file(let root, let name, let type):
            var owner: String = ""
            
            if let root = root {
                owner = root
            }

            if let type = type {
                if owner.isEmpty {
                    return "touch \(name).\(type)"
                } else {
                    return "touch \(owner)/\(name).\(type)"
                }
            } else {
                if owner.isEmpty {
                    return "touch \(name)"
                } else {
                    return "touch \(owner)/\(name)"
                }
            }

        case .readme:
            return "touch README.md"

        case .codeowners:
            return "touch CODEOWNERS"

        case .makefile:
            return "touch Makefile"
            
        case .license:
            return "touch LICENSE"
            
        case .projectYml:
            return "touch project.yml"

        case .versionFile(let version, let build):
            let content = String(format: "%@\n%@", version, build)
            return "printf \"\(content)\" > version"
        }
    }
}
