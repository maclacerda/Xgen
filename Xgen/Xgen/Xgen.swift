//
//  Xgen.swift
//  Xgen
//
//  Created by Marcos Ferreira on 07/09/22.
//

import Foundation

enum OptionType: String {
    case help = "h"
    case unknown
    
    init(value: String) {
        switch value {
        case "h": self = .help
        default: self = .unknown
        }
    }
}

class Xgen {

    // MARK: - Properties

    private let console = ConsoleIO()
    private let manager = PodManager.shared

    // MARK: - Methods
    
    func interactiveMode() {
        console.writeMessage("\n⚙️  Welcome to Xgen. This program create a base project structure for your Pod.For help type: 'Xgen -h'")
        console.writeMessage("-----------------------------------------------------------------------------------------------------\n")
        manager.getPodParameters(console)

        do {
            try manager.generatePod(console)
        } catch {
            console.writeMessage("\n💥 An error ocurred, please try again. \(error.localizedDescription)", to: .error)
        }
    }

    func staticMode() {
        let option = OptionType(value: CommandLine.argument)
        make(option)
    }
    
    private func make(_ option: OptionType) {
        switch option {
        case .help: console.printHelp()
        case .unknown: console.printUnknown()
        }
    }

}
