//
//  CleanProject.swift
//  Xgen
//
//  Created by Marcos Ferreira on 09/09/22.
//

enum CleanProject {
    case content(_ podName: String)
    
    var value: String {
        switch self {
        case .content(let podName):
            return """
            #!bin/bash

            cd ..
            rm -rf ~/Library/Developer/Xcode/DerivedData/*
            rm -rf Pods/
            rm -rf Podfile.lock
            rm -rf {PODNAME}.xcodeproj
            rm -rf {PODNAME}.xcworkspace
            xcodegen
            """
                .replacingOccurrences(of: "{PODNAME}", with: podName)
        }
    }
}

