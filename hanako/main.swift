//
//  main.swift
//  hanako
//
//  Created by 史翔新 on 2016/06/30.
//  Copyright © 2016年 史翔新. All rights reserved.
//

import Cocoa

private extension Int {
	
	static func createRandom(under limit: Int) -> Int {
		let random = arc4random_uniform(UInt32(limit))
		return Int(random)
	}
	
}

private extension String {
	
	var characterArray: [String] {
		return self.characters.map({ (c) -> String in
			return "\(c)"
		})
	}
	
	func containsCharacterInArray(_ array: [String]) -> Bool {
		
		for character in array {
			if self.contains(character) {
				return true
			}
		}
		
		return false
		
	}
	
}

private extension Array {
	
	func getRandomElement() -> Element {
		let randomIndex = Int.createRandom(under: self.count)
		return self[randomIndex]
	}
	
}

private let uppercaseStrings: [String] = {
	let string = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	return string.characterArray
}()

private let lowercasedStrings: [String] = {
	let string = "abcdefghijklmnopqrstuvwxyz"
	return string.characterArray
}()

private let numberStrings: [String] = {
	let string = "0123456789"
	return string.characterArray
}()

private enum CharacterType {
	case uppercasedAlphabet
	case lowercasedAlphabet
	case numeral
}

private var types: Set<CharacterType> = [.uppercasedAlphabet, .lowercasedAlphabet, .numeral]
private var shouldCopyToPasteboard = true
private var length = 10
private var hyphenFrequency = 0

func printHelp() {
	
	let help =
	"hanako is a random string generator.\n" +
	"\n" +
	"Usage:\n" +
	"\t$ hanako [options]\n" +
	"\n" +
	"Arguments:\n" +
	"\t-h / --help: Help. (This will ignore all other arguments and won't perform an output.)\n" +
	"\t-nu / --no-uppercase: Don't use uppercased string for the output.\n" +
	"\t-nl / --no-lowercase: Don't use lowercased string for the output.\n" +
	"\t-nn / --no-numeral: Don't use numeral string for the output.\n" +
	"\t-nc / --no-copy: Don't copy the result to pasteboard" +
	"\t-l [length] / --length [length]: Output length. Replace [length] with a number. Default length is 10.\n" +
	"\t-hf [frequency] / --hyphen-frequency [frequency]: Insert a hyphen after every certain characters. Replace [frequncy] with a number. e.g.: abc-def-ghi if you set frequency to 3, abcdefghi if you set frequncy to 0. Default frequency is 0, and hyphens are also counted in the length.\n"
	
	print(help)
	
}

func printVersion() {
	
	let version = "1.0.2"
	print(version)
	
}

func printError() {
	
	let errorMessage = "Invalid arguments. Please enter -h to get help.\n"
	print(errorMessage)
	
}

func createRandomString() -> String {
	
	guard types.count > 0 else {
		let errorMessage = "No characters able to use in random string, please check your setting.\n"
		print(errorMessage)
		exit(EXIT_FAILURE)
	}
	
	let characterList = types.reduce([]) { (list, type) -> [String] in
		let nextList: [String]
		switch type {
		case .uppercasedAlphabet:
			nextList = uppercaseStrings
			
		case .lowercasedAlphabet:
			nextList = lowercasedStrings
			
		case .numeral:
			nextList = numberStrings
		}
		return list + nextList
	}
	
	let randomString: String
	if hyphenFrequency > 0 {
		let hyphenPosition = hyphenFrequency + 1
		randomString = (1 ... length).reduce("") { (string, index) -> String in
			if index % hyphenPosition == 0 {
				return string + "-"
			} else {
				return string + characterList.getRandomElement()
			}
		}
		
	} else {
		randomString = (1 ... length).reduce("") { (string, _) -> String in
			return string + characterList.getRandomElement()
		}
	}
	
	if length >= types.count {
		
		for type in types {
			
			let characterArray: [String]
			switch type {
			case .uppercasedAlphabet:
				characterArray = uppercaseStrings
				
			case .lowercasedAlphabet:
				characterArray = lowercasedStrings
				
			case .numeral:
				characterArray = numberStrings
			}
			
			guard randomString.containsCharacterInArray(characterArray) else {
				return createRandomString()
			}
			
		}
	}
	
	return randomString
	
}

func copyStringToPasteboard(_ string: String) {
	
	let board = NSPasteboard.general()
	board.clearContents()
	
	let item = NSPasteboardItem()
	item.setString(string, forType: NSPasteboardTypeString)
	board.writeObjects([item])
	
}

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
				types.remove(.numeral)
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
		
		let result = createRandomString()
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
