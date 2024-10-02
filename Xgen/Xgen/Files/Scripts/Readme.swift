//
//  Readme.swift
//  Xgen
//
//  Created by Marcos Ferreira on 09/09/22.
//

enum Readme {
    case content(_ podName: String, repoName: String, repoPath: String, author: String, authorMail: String)
    
    var value: String {
        switch self {
        case .content(let podName, let repoName, let repoPath, let author, let authorMail):
            let unitTestSnippet = """
            
            # Unit Tests ✅

            This module has unit tests and the ideal is to keep the minimum coverage of 80% for new developments.

            <br/>

            """
            
            return """
            # {PODNAME}

            [![Build](https://img.shields.io/github/workflow/status/santander-group-europe/{REPO_NAME}/{REPO_NAME}-build?style=flat-square)]()
            [![Version](https://img.shields.io/cocoapods/v/{PODNAME}?style=flat-square)](https://cocoapods.org/pods/{PODNAME})
            [![License](https://img.shields.io/cocoapods/l/{PODNAME}?style=flat-square)](https://cocoapods.org/pods/{PODNAME})
            [![Platform](https://img.shields.io/cocoapods/p/{PODNAME}?style=flat-square)](https://cocoapods.org/pods/{PODNAME})

            This repo contains the sources of {PODNAME} module of Santander One App project. This module only attends the Portugal country.

            <br/>

            # Architecture ⚙️

            The architecture used to build this module was MVVM-C (Model / View / ViewModel - Coordinator).

            <br/>

            # Pre-Requirements ⚠️

            * Homebrew [see more](https://brew.sh)
            * Ruby 2.6.3+ (inside MacOS)
            * Swift 5.0+
            * Xcode 13+

            <br/>

            # Tools used 🛠

            * Xcodegen 2.20.0+ [see more](https://github.com/yonaskolb/XcodeGen)
            * Swiftlint 0.48.0+ [see more](https://github.com/realm/SwiftLint)
            * Cocoapods
            * xcodeproj (Ruby gem)

            <br/>

            # Envrioment Setup 🖥

            Follow the bellow steps to setup your envrioment.

            * Checkout this repo on your preference folder.
            * Open the previous folder on terminal{HAS_MAKEFILE}
            <br/>

            # Local Build 🛠

            Open project folder in terminal, and type xcodegen.

            <br/>{HAS_UNIT_TEST}

            # Installation 📦

            {PODNAME} is available through [CocoaPods](https://cocoapods.org). To install
            this pod, add to your Podfile the desired option:

            For the framework generated from the mat:

            <br/>

            # How to run the project? 💡

            To run this project, go to the scheme selector ({PODNAME} and {PODNAME}Sample) and select one according to what you want to run.

            <br/>

            # And how to runt the unit tests? 💡

            The tests are linked to the {PODNAME} scheme. Hold down the Run button and change it to Tests.
            <br/>
            We recommend running the unit tests in the iPhone 8 simulator to avoid possible errors in the treadmill test step.

            <br/>

            # Acceptance criteria in PR 📝

            All PR for the following branches must be approved by at least one of the project's [CODEOWNERS](CODEOWNERS).

            - master
            - develop
            - release

            <br/>

            # How to release a new pod version? 📐

            For release new versions for this pod, follow these steps:

            - Create and checkout a new branch with prefix: release/candidate-x.x.x replacing the x.x.x for version you want to rollout, with base in release branch. This branch is a mirror of master.
            - In the created branch open the version file in your liked editor and change the first line of file with the x.x.x version number, and the last line with your build version. After this, save and close the file.
            - Run the xcodegen command, this step is responsible for update the files: {PODNAME}.podspec and README.md with new generated version.
            - Commit and push the changes in your branch, and open the PR to release branch.

            <br/>

            # Author ©️

            {AUTHOR}, {AUTHOR_MAIL}

            <br/>

            # License 📄

            {PODNAME} is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
            """
                .replacingOccurrences(of: "{HAS_UNIT_TEST}", with: unitTestSnippet)
                .replacingOccurrences(of: "{REPO_NAME}", with: repoName)
                .replacingOccurrences(of: "{REPO_PATH}", with: repoPath.lowercased())
                .replacingOccurrences(of: "{AUTHOR}", with: author)
                .replacingOccurrences(of: "{AUTHOR_MAIL}", with: authorMail)
                .replacingOccurrences(of: "{PODNAME}", with: podName)
        }
    }
}

