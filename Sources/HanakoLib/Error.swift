//
//  Error.swift
//  HanakoLib
//
//  Created by 史翔新 on 2019/12/02.
//

import Foundation

public func printError(_ error: Error) {
    
    let errorMessage = """
        Error: \(error)
        Please enter -h to get help."
        """
    print(errorMessage)
    
}
