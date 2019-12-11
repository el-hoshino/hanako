//
//  main.swift
//  hanako
//
//  Created by 史翔新 on 2016/06/30.
//  Copyright © 2016年 史翔新. All rights reserved.
//

import Cocoa
import HanakoLib

let arguments = CommandLine.arguments
let parser = Parser()

do {
    let result = try parser.parse(arguments)
    switch result {
    case .showHelp:
        printHelp()
        
    case .showVersion:
        printVersion()
        
    case .generateString(let result):
        let resultString = result.generatedString
        print("Generated string: \(resultString)")
        if result.settings.shouldCopyToPasteboard {
            NSPasteboard.general.replacePasteboardItem(with: resultString)
            print("Result has been copied to your clipboard, you can use cmd + v to paste it.")
        }
    }
    
    print()
    exit(EXIT_SUCCESS)
    
} catch let error {
    printError(error)
    exit(EXIT_FAILURE)
}
