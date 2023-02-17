//
//  CommandLine+extensions.swift
//  Xgen
//
//  Created by Marcos Ferreira on 08/09/22.
//

import Foundation

extension CommandLine {
    
    static var argument: String {
        let argument = CommandLine.arguments[1]

        // Get the simple argument value, discard the '-'
        let index = argument.index(argument.startIndex, offsetBy: 1)
        
        return String(argument[index...])
    }
    
}
