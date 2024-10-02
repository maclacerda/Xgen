//
//  Parameters.swift
//  Xgen
//
//  Created by Marcos Ferreira on 08/09/22.
//

import Foundation

struct Parameters {
    var podName: String = ""
    var podPrefixName: String = ""
    var podVersion: String = "1.0.0"
    var shouldCreatePodFile: Bool = true
    var shouldCreateMockStructure: Bool = false
    var shouldCreateSampleProject: Bool = false
    var shouldCreateUnitTestsStructure: Bool = true
    var shouldCreateReadmeFile: Bool = true
    var shouldCreateMakeFile: Bool = true
    var shouldCreateCodeOwnersFile: Bool = false
}
