//
//  Parser.swift
//  hanako
//
//  Created by 史翔新 on 2019/12/02.
//

import Foundation

final class Parser {
    
    enum ParsingError: Error {
        case invalidArguments(ArraySlice<String>)
    }
    
    enum Result {
        struct RandomString {
            struct Settings {
                var characters: Set<Character.Kind> = [.uppercasedAlphabet, .lowercasedAlphabet, .numeric]
                var length: Int = 10
                var hyphenFrequency: Int = 0
                var shouldCopyToPasteboard: Bool = true
            }
            let settings: Settings
            let generatedString: String
        }
        case showHelp
        case showVersion
        case generateString(RandomString)
    }
    
    func parse(_ arguments: [String]) throws -> Result {
        
        var parsingArguments = arguments.dropFirst()
        
        if let result = foundShouldFinishParsingCommand(from: parsingArguments) {
            return result
        }
        
        var settings = Result.RandomString.Settings()
        while !parsingArguments.isEmpty {
            try extractNormalParsingCommand(from: &parsingArguments, into: &settings)
        }
        
        let randomString = String.randomString(ofLength: settings.length,
                                               from: settings.characters,
                                               hyphenFrequency: settings.hyphenFrequency)
        
        return .generateString(.init(settings: settings, generatedString: randomString))
        
    }
    
}

extension Parser {
    
    private func foundShouldFinishParsingCommand(from arguments: ArraySlice<String>) -> Result? {
        
        if arguments.contains("-h") || arguments.contains("--help") {
            return .showHelp
            
        } else if arguments.contains("-v") || arguments.contains("--version") {
            return .showVersion
            
        } else {
            return nil
        }
        
    }
    
    private func extractNormalParsingCommand(from arguments: inout ArraySlice<String>, into settings: inout  Result.RandomString.Settings) throws {
        
        let argument = arguments.first
        switch argument {
        case "-nu", "--no-uppercase":
            settings.characters.remove(.uppercasedAlphabet)
            arguments.removeFirst()
            
        case "-nl", "--no-lowercase":
            settings.characters.remove(.lowercasedAlphabet)
            arguments.removeFirst()
            
        case "-nn", "--no-numeral":
            settings.characters.remove(.numeric)
            arguments.removeFirst()
            
        case "-nc", "--no-copy":
            settings.shouldCopyToPasteboard = false
            arguments.removeFirst()
            
        case "-l", "--length":
            guard arguments.count > 1, let lengthParameter = Int(arguments[1]) else {
                throw ParsingError.invalidArguments(arguments)
            }
            settings.length = lengthParameter
            arguments.removeFirst(2)
            
        case "-hf", "--hyphen-frequency":
            guard arguments.count > 1, let frequencyParameter = Int(arguments[1]) else {
                throw ParsingError.invalidArguments(arguments)
            }
            settings.hyphenFrequency = frequencyParameter
            arguments.removeFirst(2)
            
        case _:
            throw ParsingError.invalidArguments(arguments)
        }
        
    }
    
}
