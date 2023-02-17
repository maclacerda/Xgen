//
//  main.swift
//  Xgen
//
//  Created by Marcos Ferreira on 07/09/22.
//

import Foundation

let xgen = Xgen()

if CommandLine.argc < 2 {
    xgen.interactiveMode()
} else {
    xgen.staticMode()
}
