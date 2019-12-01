//
//  main.swift
//  hanako
//
//  Created by 史翔新 on 2016/06/30.
//  Copyright © 2016年 史翔新. All rights reserved.
//

import Foundation

private extension String {
	
	var characterSet: Set<Character> {
		return reduce(into: Set<Character>()) { (result, character) in
			result.insert(character)
		}
	}
	
	func containsAnyCharacterInSet(_ array: Set<Character>) -> Bool {
		
		for character in array {
			if self.contains(character) {
				return true
			}
		}
		
		return false
		
	}
	
}

extension Set where Element == Character {
	
	func unsafeRandomElement() -> Element {
    	return randomElement() ?? {
	    	assertionFailure("Trying to extract random element from an empty array.")
	    	return " "
    	}()
	}
	
}

private let uppercaseStrings: Set<Character> = {
	let string = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	return string.characterSet
}()

private let lowercasedStrings: Set<Character> = {
	let string = "abcdefghijklmnopqrstuvwxyz"
	return string.characterSet
}()

private let numberStrings: Set<Character> = {
	let string = "0123456789"
	return string.characterSet
}()

enum CharacterType {
	case uppercasedAlphabet
	case lowercasedAlphabet
	case numeral
}

private var types: Set<CharacterType> = [.uppercasedAlphabet, .lowercasedAlphabet, .numeral]
private var shouldCopyToPasteboard = true
private var length = 10
private var hyphenFrequency = 0

func createRandomString(ofLength length: Int, from types: Set<CharacterType>, hyphenFrequency: Int) -> String {
	
	guard types.count > 0 else {
		let errorMessage = "No characters able to use in random string, please check your setting.\n"
		print(errorMessage)
		exit(EXIT_FAILURE)
	}
	
	let characterList = types.reduce(into: Set<Character>()) { (set, type) in
		let nextList: Set<Character>
		switch type {
		case .uppercasedAlphabet:
			nextList = uppercaseStrings
			
		case .lowercasedAlphabet:
			nextList = lowercasedStrings
			
		case .numeral:
			nextList = numberStrings
		}
		set.formUnion(nextList)
	}
	
	let randomString: String
	if hyphenFrequency > 0 {
		let hyphenPosition = hyphenFrequency + 1
		randomString = (1 ... length).reduce("") { (string, index) -> String in
			if index % hyphenPosition == 0 {
				return string + "-"
			} else {
				return string + "\(characterList.unsafeRandomElement())"
			}
		}
		
	} else {
		randomString = (1 ... length).reduce("") { (string, _) -> String in
			return string + "\(characterList.unsafeRandomElement())"
		}
	}
	
	if length >= types.count {
		
		for type in types {
			
			let characterSet: Set<Character>
			switch type {
			case .uppercasedAlphabet:
				characterSet = uppercaseStrings
				
			case .lowercasedAlphabet:
				characterSet = lowercasedStrings
				
			case .numeral:
				characterSet = numberStrings
			}
			
			guard randomString.containsAnyCharacterInSet(characterSet) else {
				return createRandomString(ofLength: length, from: types, hyphenFrequency: hyphenFrequency)
			}
			
		}
	}
	
	return randomString
	
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
		
		let result = createRandomString(ofLength: length, from: types, hyphenFrequency: hyphenFrequency)
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
