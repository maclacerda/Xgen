//
//  ConsoleIO.swift
//  Xgen
//
//  Created by Marcos Ferreira on 07/09/22.
//

import Foundation

enum OutputType {
    case error
    case standard
}

class ConsoleIO {
    
    func writeMessage(_ message: String, to output: OutputType = .standard) {
        switch output {
        case .error:
            fputs("\u{001B}[0;31m\(message)\n", stderr)
        case .standard:
            print("\u{001B}[;m\(message)")
        }
    }
    
    func printHelp() {
        let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent

        writeMessage("usage:")
        writeMessage("\(executableName) -c string")
        writeMessage("or")
        writeMessage("\(executableName) -h to show help information")
        writeMessage("or")
        writeMessage("\(executableName) -u to show usage information")
        writeMessage("Type \(executableName) without an option to enter interactive mode.")
    }
    
    func printUnknown() {
        writeMessage("❌ Option not found, for available options type \"Xgen -h\"", to: .error)
    }
    
    func getInput() -> String {
        let keyboard = FileHandle.standardInput
        let inputData = keyboard.availableData
        let data = String(data: inputData, encoding: .utf8)
        
        return data?.trimmingCharacters(in: .newlines) ?? ""
    }

}
