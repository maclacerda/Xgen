//
//  CodeOwners.swift
//  Xgen
//
//  Created by Marcos Ferreira on 09/09/22.
//

enum CodeOwners {
    case content
    
    var value: String {
        switch self {
        case .content:
            return "# Add the @username to define the code owners from your pod"
        }
    }
}
