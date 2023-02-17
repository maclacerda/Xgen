//
//  Postgen.swift
//  Xgen
//
//  Created by Marcos Ferreira on 09/09/22.
//

enum Postgen {
    case content
    
    var value: String {
        switch self {
        case .content:
            return """
            ruby scripts/xcodeversion.rb

            if [ -z $WORKSPACE ]
            then
                echo "Installing dependencies"
                pod install
            fi
            """
        }
    }
}
