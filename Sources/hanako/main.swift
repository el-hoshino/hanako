//
//  main.swift
//  hanako
//
//  Created by 史翔新 on 2016/06/30.
//  Copyright © 2016年 史翔新. All rights reserved.
//

import Foundation

private var types: Set<Character.Kind> = [.uppercasedAlphabet, .lowercasedAlphabet, .numeric]
private var shouldCopyToPasteboard = true
private var length = 10
private var hyphenFrequency = 0

func parseCommand() {
	
	let arguments = Array(CommandLine.arguments.dropFirst())
	
	if arguments.contains("-h") || arguments.contains("--help") {
		
		printHelp()
		
		exit(EXIT_SUCCESS)
		
	}
	else if arguments.contains("-v") || arguments.contains("--version") {
		
		printVersion()
		
		exit(EXIT_SUCCESS)
		
	}
	else {
		var arguments = arguments
		while let argument = arguments.first {
			switch argument {
			case "-nu", "--no-uppercase":
				types.remove(.uppercasedAlphabet)
				arguments.removeFirst()
				
			case "-nl", "--no-lowercase":
				types.remove(.lowercasedAlphabet)
				arguments.removeFirst()
				
			case "-nn", "--no-numeral":
				types.remove(.numeric)
				arguments.removeFirst()
				
			case "-nc", "--no-copy":
				shouldCopyToPasteboard = false
				arguments.removeFirst()
				
			case "-l", "--length":
				guard arguments.count > 1, let lengthParameter = Int(arguments[1]) else {
					printError()
					exit(EXIT_FAILURE)
				}
				length = lengthParameter
				arguments.removeFirst(2)
				
			case "-hf", "--hyphen-frequency":
				guard arguments.count > 1, let frequencyParameter = Int(arguments[1]) else {
					printError()
					exit(EXIT_FAILURE)
				}
				hyphenFrequency = frequencyParameter
				arguments.removeFirst(2)
				
			default:
				printError()
				exit(EXIT_FAILURE)
			}
		}
		
        let result = String.randomString(ofLength: length, from: types, hyphenFrequency: hyphenFrequency)
		print("Generated string: \(result)")
		
		if shouldCopyToPasteboard {
			copyStringToPasteboard(result)
			print("Result has been copied to your clipboard, you can use cmd + v to paste it.")
		}
		
		print()
		
		exit(EXIT_SUCCESS)
		
	}
	
}

parseCommand()
