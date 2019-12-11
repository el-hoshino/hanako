//
//  Parser.swift
//  HanakoLib
//
//  Created by 史翔新 on 2019/12/02.
//

import Foundation

public final class Parser {
    
    enum ParsingError: Error {
        case invalidArguments(ArraySlice<String>)
    }
    
    public enum Result {
        public struct RandomString {
            public struct Settings {
                public var characters: Set<Character.Kind> = [.uppercasedAlphabet, .lowercasedAlphabet, .numeric]
                public var length: Int = 10
                public var hyphenFrequency: Int = 0
                public var shouldCopyToPasteboard: Bool = true
            }
            public let settings: Settings
            public let generatedString: String
        }
        case showHelp
        case showVersion
        case generateString(RandomString)
    }
    
    public init() {
        
    }
    
    public func parse(_ arguments: [String]) throws -> Result {
        
        var parsingArguments = arguments.dropFirst()
        
        if let result = foundShouldFinishParsingCommand(from: parsingArguments) {
            return result
        }
        
        var settings = Result.RandomString.Settings()
        while !parsingArguments.isEmpty {
            try extractNormalParsingCommand(from: &parsingArguments, into: &settings)
        }
        
        let randomString = try String.randomString(ofLength: settings.length,
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
            guard let lengthParameter = arguments.second.intValue else {
                throw ParsingError.invalidArguments(arguments)
            }
            settings.length = lengthParameter
            arguments.removeFirst(2)
            
        case "-hf", "--hyphen-frequency":
            guard let frequencyParameter = arguments.second.intValue else {
                throw ParsingError.invalidArguments(arguments)
            }
            settings.hyphenFrequency = frequencyParameter
            arguments.removeFirst(2)
            
        case _:
            throw ParsingError.invalidArguments(arguments)
        }
        
    }
    
}

private extension ArraySlice {
    
    private var validIndexRange: Range<Int> {
        return startIndex ..< endIndex
    }
    
    var second: Element? {
        let secondIndex = index(after: startIndex)
        guard validIndexRange.contains(secondIndex) else {
            return nil
        }
        return self[secondIndex]
    }
    
}

private extension Optional where Wrapped == String {
    
    var intValue: Int? {
        return flatMap({ Int($0) })
    }
    
}
