//
//  Version.swift
//  hanako
//
//  Created by 史翔新 on 2019/12/02.
//

import Foundation

func printVersion() {
    
    let dictionary = Bundle.main.infoDictionary ?? {
        assertionFailure("Failed to find Info.plist")
        return [:]
    }()
    let version = dictionary["CFBundleShortVersionString"] as? String ?? {
        assertionFailure(#"Failed to find "CFBundleShortVersionString" value in dictionary \#(dictionary)"#)
        return "Unknown"
    }()
    
    print(version)
    
}
