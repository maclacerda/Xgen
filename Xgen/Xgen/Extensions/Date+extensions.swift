//
//  Date+extensions.swift
//  Xgen
//
//  Created by Marcos Ferreira on 09/09/22.
//

import Foundation

extension Date {
    static var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"

        return dateFormatter.string(from: self.now)
    }
}
