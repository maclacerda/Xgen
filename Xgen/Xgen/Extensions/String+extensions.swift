//
//  String+extensions.swift
//  Xgen
//
//  Created by Marcos Ferreira on 08/09/22.
//

import Foundation

extension String {
    
    // MARK: - Properties
    
    var isYesOrNo: Bool {
        return self == "n" || self == "y"
    }
    
    // MARK: - Methods
    
    func asBool() -> Bool {
        return (self as NSString).boolValue
    }
    
}
