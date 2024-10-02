//
//  PodManager.swift
//  Xgen
//
//  Created by Marcos Ferreira on 08/09/22.
//

import Foundation

enum PodManagerError: Error {
    case commandError(String)
    case fillError(String)
}

final class PodManager {
    
    // MARK: - Properties
    
    static let shared: PodManager = PodManager()
    private var parameters: Parameters
    private var console: ConsoleIO?
    private var structureContents = [FilesContent.Structure]()
    private var podContents = [FilesContent.Pod]()
    private var sampleContents = [FilesContent.Sample]()
    private var mocksContents = [FilesContent.Mocks]()
    private var testsContents = [FilesContent.Tests]()
    
    var arguments: Parameters {
        return parameters
    }
    
    // MARK: - Initializer
    
    private init() {
        self.parameters = Parameters()
    }
    
    // MARK: - Methods
    
    func getPodParameters(_ console: ConsoleIO) {
        self.console = console
        
        getProjectName()
        getPodPrefixName()
        shouldCreatePodFile()
        shouldAddMock()
        shouldAddSample()
        shouldAddReadme()
        shouldAddMakeFile()
        shouldAddCodeOwners()
    }
    
    func generatePod(_ console: ConsoleIO) throws {
        self.console = console

        var commands = [Commands]()
        
        // Add all commands to create Pod structure
        let podName = parameters.podPrefixName + parameters.podName
        
        commands.append(.folder(name: podName))
        commands.append(.subfolder(root: podName, name: "Resources"))
        commands.append(.subfolder(root: "\(podName)/Resources", name: "Assets.xcassets"))
        commands.append(.subfolder(root: "\(podName)/Resources", name: "Localizables"))
        commands.append(.file(root: "\(podName)/Resources/Localizables", name: podName, type: "strings"))
        podContents.append(.strings)
        commands.append(.subfolder(root: podName, name: "Sources"))
        commands.append(.subfolder(root: "\(podName)/Sources", name: "Features"))
        commands.append(.file(root: podName, name: "Info", type: "plist"))
        podContents.append(.plist)
        commands.append(.file(root: podName, name: podName, type: "h"))
        podContents.append(.header)
        commands.append(.podspec(podName))
        structureContents.append(.podspec(podName, repoName: "repo-name", author: "author", authorMail: "authorMail"))
        commands.append(.versionFile(version: parameters.podVersion, build: "1"))
        commands.append(.license)
        structureContents.append(.license)
        commands.append(.projectYml)
        structureContents.append(.projectYml)
        commands.append(.folder(name: "scripts"))
        commands.append(.file(root: "scripts", name: "cleanProject", type: "sh"))
        structureContents.append(.cleanProject(podName))
        commands.append(.file(root: "scripts", name: "postgen", type: "sh"))
        structureContents.append(.postgen)
        commands.append(.file(root: "scripts", name: "xcodeversion", type: "rb"))
        structureContents.append(.xcodeversion(podName, hasSample: parameters.shouldCreateSampleProject))
        
        if parameters.shouldCreatePodFile {
            commands.append(.podfile)
            structureContents.append(.podfile(podName,
                                              hasSample: parameters.shouldCreateSampleProject,
                                              hasTests: parameters.shouldCreateUnitTestsStructure
                                             )
            )
        }
        
        if parameters.shouldCreateMockStructure {
            commands.append(.folder(name: podName + "Mocks"))
        }
        
        if parameters.shouldCreateSampleProject {
            let sampleName = podName + "Sample"

            commands.append(.folder(name: sampleName))
            commands.append(.subfolder(root: sampleName, name: "Assets.xcassets"))
            commands.append(.subfolder(root: "\(sampleName)/Assets.xcassets", name: "AccentColor.colorset"))
            sampleContents.append(.accentColor)
            commands.append(.subfolder(root: "\(sampleName)/Assets.xcassets", name: "AppIcon.appiconset"))
            sampleContents.append(.appIcon)
            commands.append(.file(root: "\(sampleName)/Assets.xcassets", name: "Contents", type: "json"))
            sampleContents.append(.contents)
            commands.append(.subfolder(root: sampleName, name: "Base.lproj"))
            commands.append(.file(root: "\(sampleName)/Base.lproj", name: "LaunchScreen", type: "storyboard"))
            sampleContents.append(.storyboard)
            commands.append(.subfolder(root: sampleName, name: "Scenes"))
            commands.append(.subfolder(root: "\(sampleName)/Scenes", name: "Launcher"))
            commands.append(.file(root: "\(sampleName)/Scenes/Launcher", name: "LauncherViewController", type: "swift"))
            sampleContents.append(.launcher)
            commands.append(.file(root: sampleName, name: "AppBuilderCoordinator", type: "swift"))
            sampleContents.append(.coordinator)
            commands.append(.file(root: sampleName, name: "AppDelegate", type: "swift"))
            sampleContents.append(.appdelegate)
            commands.append(.file(root: sampleName, name: "Info", type: "plist"))
            sampleContents.append(.plist)
        }
        
        if parameters.shouldCreateUnitTestsStructure {
            let testsName = podName + "Tests"
            commands.append(.folder(name: testsName))
            commands.append(.file(root: testsName, name: "Info", type: "plist"))
            testsContents.append(.plist)
        }
        
        if parameters.shouldCreateReadmeFile {
            commands.append(.readme)
            structureContents.append(.readme(podName, repoName: "repo-name", repoPath: "path/repo", author: "author", authorMail: "authorMail"))
        }
        
        if parameters.shouldCreateMakeFile {
            commands.append(.makefile)
            structureContents.append(.makefile(podName))
        }
        
        if parameters.shouldCreateCodeOwnersFile {
            commands.append(.codeowners)
            structureContents.append(.codeowners)
        }
        
        // Perfom commands
        console.writeMessage("\n⚡️ Generating Pod, wait a minute please...☕️")
        try makeCommands(commands)
        
        console.writeMessage("\n📄 Filling files...")
        try fillFiles()
        
        // Finish
        console.writeMessage("\n✅ Completed.\n")
    }
    
    // MARK: - Helpers
    
    private func makeCommands(_ commands: [Commands]) throws {
        try commands.forEach {
            let commandOutput = shell($0.command)

            if !commandOutput.isEmpty {
                throw PodManagerError.commandError(commandOutput)
            }
        }
    }
    
    private func fillFiles() throws {
        try structureContents.forEach {
            let commandOutput = shell($0.command)

            if !commandOutput.isEmpty {
                throw PodManagerError.fillError(commandOutput)
            }
        }

        try podContents.forEach {
            let commandOutput = shell($0.command)

            if !commandOutput.isEmpty {
                throw PodManagerError.fillError(commandOutput)
            }
        }

        try sampleContents.forEach {
            let commandOutput = shell($0.command)

            if !commandOutput.isEmpty {
                throw PodManagerError.fillError(commandOutput)
            }
        }

        try mocksContents.forEach {
            let commandOutput = shell($0.command)

            if !commandOutput.isEmpty {
                throw PodManagerError.fillError(commandOutput)
            }
        }

        try testsContents.forEach {
            let commandOutput = shell($0.command)

            if !commandOutput.isEmpty {
                throw PodManagerError.fillError(commandOutput)
            }
        }
    }
    
    private func getProjectName() {
        guard let console = self.console else { return }

        console.writeMessage("📝 What is the name of your pod?")
        let podName = console.getInput()
        
        parameters.podName = podName
    }
    
    private func getPodPrefixName() {
        guard let console = self.console else { return }
        
        console.writeMessage("\n📝 What is your pod name prefix? (Default is: \"\")")
        let prefixName = console.getInput()
        
        if !prefixName.isEmpty {
            parameters.podPrefixName = prefixName
        }
    }
    
    private func shouldCreatePodFile() {
        guard let console = self.console else { return }
        var shouldCreatePodFile: String

        repeat {
            console.writeMessage("\n📄 Add Podfile from your Pod? (y/n)")
            shouldCreatePodFile = console.getInput().lowercased()
        } while (shouldCreatePodFile.isEmpty || !shouldCreatePodFile.isYesOrNo)
        
        parameters.shouldCreatePodFile = shouldCreatePodFile.asBool()
    }
    
    private func shouldAddMock() {
        guard let console = self.console else { return }
        var shouldAddMock: String
        
        repeat {
            console.writeMessage("\n🥸 Create a mock structure from your Pod? (y/n)")
            shouldAddMock = console.getInput()
        } while(shouldAddMock.isEmpty || !shouldAddMock.isYesOrNo)
        
        parameters.shouldCreateMockStructure = shouldAddMock.asBool()
    }
    
    private func shouldAddSample() {
        guard let console = self.console else { return }
        var shouldAddSample: String
        
        repeat {
            console.writeMessage("\n🏗  Create a sample project from your Pod? (y/n)")
            shouldAddSample = console.getInput()
        } while(shouldAddSample.isEmpty || !shouldAddSample.isYesOrNo)
        
        parameters.shouldCreateSampleProject = shouldAddSample.asBool()
    }
    
    private func shouldAddReadme() {
        guard let console = self.console else { return }
        var shouldAddReadme: String
        
        repeat {
            console.writeMessage("\n🧾 Create a README.md file from your Pod? (y/n)")
            shouldAddReadme = console.getInput()
        } while(shouldAddReadme.isEmpty || !shouldAddReadme.isYesOrNo)
        
        parameters.shouldCreateReadmeFile = shouldAddReadme.asBool()
    }
    
    private func shouldAddMakeFile() {
        guard let console = self.console else { return }
        var shouldAddMakeFile: String
        
        repeat {
            console.writeMessage("\n🛠  Create a Makefile from your Pod? (y/n)")
            shouldAddMakeFile = console.getInput()
        } while(shouldAddMakeFile.isEmpty || !shouldAddMakeFile.isYesOrNo)
        
        parameters.shouldCreateMakeFile = shouldAddMakeFile.asBool()
    }
    
    private func shouldAddCodeOwners() {
        guard let console = self.console else { return }
        var shouldAddCodeOwners: String
        
        repeat {
            console.writeMessage("\n🤝 Create a CODEOWNERS file from your Pod? (y/n)")
            shouldAddCodeOwners = console.getInput()
        } while(shouldAddCodeOwners.isEmpty || !shouldAddCodeOwners.isYesOrNo)
        
        parameters.shouldCreateCodeOwnersFile = shouldAddCodeOwners.asBool()
    }
    
}
