//
//  Podspec.swift
//  Xgen
//
//  Created by Marcos Ferreira on 09/09/22.
//

enum Podspec {
    case content(_ podName: String, repoName: String, author: String, authorMail: String)
    
    var value: String {
        switch self {
        case .content(let podName, let repoName, let author, let authorMail):
            return """
            Pod::Spec.new do |s|
                s.name             = '{PODNAME}'
                s.version          = '1.0.0'
                s.summary          = '{PODNAME} Module'
                s.description      = 'SantanderPT {PODNAME} Module.'
                s.homepage         = 'https://github.com/santander-group-europe/{REPO_NAME}'
                s.license          = { :type => 'MIT', :file => 'LICENSE' }
                s.author           = { '{AUTHOR}' => '{AUTHOR_MAIL}' }

                #---------- Source Location ----------#
                s.source           = { :git => "https://github.com/santander-group-europe/{REPO_NAME}.git", :tag => s.version.to_s }
              
                #---------- Deployment Target ----------#
                s.swift_version    = '5.0'
                s.ios.deployment_target = '12.4'

                #---------- Project Linking ----------#
                s.source_files = '{PODNAME}/Sources/**/*.{swift}'
                s.resources    = '{PODNAME}/Resources/**/*.{ttf,xib,storyboard,xcassets,strings,plist,json,html}'
            end
            """
                .replacingOccurrences(of: "{PODNAME}", with: podName)
                .replacingOccurrences(of: "{REPO_NAME}", with: repoName)
                .replacingOccurrences(of: "{AUTHOR}", with: author)
                .replacingOccurrences(of: "{AUTHOR_MAIL}", with: authorMail)
        }
    }
}
