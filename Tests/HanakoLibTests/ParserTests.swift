//
//  ParserTests.swift
//  hanakoTests
//
//  Created by 史 翔新 on 2019/12/04.
//

import XCTest
@testable import HanakoLib

private enum ParsingTestResult {
    case success(Parser.Result)
    case parsingError(Parser.ParsingError)
    case generatingError(String.RandomStringGenerationError)
}

final class ParserTests: XCTestCase {
    
    func testParsing() {
        
        typealias TestCase = (command: String, expected: ParsingTestResult)
        let testCases: [TestCase] = [
            ("hanako", .success(.string(set: [.uppercasedAlphabet, .lowercasedAlphabet, .numeric], length: 10, hf: 0, copy: true))),
            ("hanako -h", .success(.showHelp)),
            ("hanako -h -v", .success(.showHelp)),
            ("hanako -h -l 13", .success(.showHelp)),
            ("hanako -v", .success(.showVersion)),
            ("hanako -v -nl", .success(.showVersion)),
            ("hanako -h", .success(.showHelp)),
            ("hanako -nu", .success(.string(set: [.lowercasedAlphabet, .numeric], length: 10, hf: 0, copy: true))),
            ("hanako -nl", .success(.string(set: [.uppercasedAlphabet, .numeric], length: 10, hf: 0, copy: true))),
            ("hanako -nn", .success(.string(set: [.uppercasedAlphabet, .lowercasedAlphabet], length: 10, hf: 0, copy: true))),
            ("hanako -nc", .success(.string(set: [.uppercasedAlphabet, .lowercasedAlphabet, .numeric], length: 10, hf: 0, copy: false))),
            ("hanako -l 16", .success(.string(set: [.uppercasedAlphabet, .lowercasedAlphabet, .numeric], length: 16, hf: 0, copy: true))),
            ("hanako -hf 3", .success(.string(set: [.uppercasedAlphabet, .lowercasedAlphabet, .numeric], length: 10, hf: 3, copy: true))),
            ("hanako -nu -nl -nc -l 15 -hf 3", .success(.string(set: [.numeric], length: 15, hf: 3, copy: false))),
            ("hanako -l", .parsingError(.invalidArguments(["-l"]))),
            ("hanako -l 3 -hf", .parsingError(.invalidArguments(["-hf"]))),
            ("hanako -l -hf 3", .parsingError(.invalidArguments(["-l", "-hf", "3"]))),
            ("hanako -nu -nl -nn", .generatingError(.noCaharactersAvailableToUseInGeneratingRandomString)),
        ]
        
        for testCase in testCases {
            do {
                let result = try Parser().parse(testCase.command.components(separatedBy: " "))
                XCTAssert(result.isIdentical(with: testCase.expected.forcedSuccess))
                if case .generateString(let generated) = result {
                    XCTAssert(generated.generatedString.matches(testCase.expected.forcedSuccess))
                }
                
            } catch let error as Parser.ParsingError {
                XCTAssert(error == testCase.expected.forcedParsingError)
                
            } catch let error as String.RandomStringGenerationError {
                XCTAssert(error == testCase.expected.forcedGenerationError)
                
            } catch {
                fatalError()
            }
        }
        
    }
    
    static var allTests = [
        ("testParsing", testParsing),
    ]
    
}

private extension Parser.Result {
    
    static func string(set characters: Set<Character.Kind>, length: Int, hf hyphenFrequency: Int, copy shouldCopyToPasteboard: Bool) -> Parser.Result {
        let settings = Parser.Result.RandomString.Settings(characters: characters,
                                                           length: length,
                                                           hyphenFrequency: hyphenFrequency,
                                                           shouldCopyToPasteboard: shouldCopyToPasteboard)
        return .generateString(.init(settings: settings, generatedString: ""))
    }
    
    func isIdentical(with other: Self) -> Bool {
        switch (self, other) {
        case (.showHelp, .showHelp),
             (.showVersion, .showVersion):
            return true
            
        case (.generateString(let s), .generateString(let o)):
            return s.settings == o.settings
            
        case _:
            return false
        }
    }
    
}

private extension Parser.Result.RandomString.Settings {
    
    static func == (lhs: Parser.Result.RandomString.Settings, rhs: Parser.Result.RandomString.Settings) -> Bool {
        return lhs.characters == rhs.characters
            && lhs.length == rhs.length
            && lhs.hyphenFrequency == rhs.hyphenFrequency
            && lhs.shouldCopyToPasteboard == rhs.shouldCopyToPasteboard
    }
    
    
}

private extension ParsingTestResult {
    
    var forcedSuccess: Parser.Result {
        switch self {
        case .success(let result):
            return result
        default:
            fatalError()
        }
    }
    
    var forcedParsingError: Parser.ParsingError {
        switch self {
        case .parsingError(let error):
            return error
        default:
            fatalError()
        }
    }
    
    var forcedGenerationError: String.RandomStringGenerationError {
        switch self {
        case .generatingError(let error):
            return error
        default:
            fatalError()
        }
    }
    
}

private extension Error {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        let l = lhs as! Parser.ParsingError
        let r = rhs as! Parser.ParsingError
        switch (l, r) {
        case (.invalidArguments(let l), .invalidArguments(let r)):
            return l == r
        }
    }
    
}

private extension String {
    
    func matches(_ expected: Parser.Result) -> Bool {
        
        guard case .generateString(let generated) = expected else {
            return false
        }
        
        let settings = generated.settings
        
        guard count == settings.length else {
            return false
        }
        
        guard settings.characters.allSatisfy({ containsAnyCharacterInSet($0.characterSet) }) else {
            return false
        }
        
        guard enumerated().allSatisfy({ (index, character) -> Bool in
            if settings.hyphenFrequency > 0, (index + 1) % (settings.hyphenFrequency + 1) == 0 {
                return character == "-"
            } else {
                return character != "-"
            }
        }) else {
            return false
        }
        
        return true
        
    }
    
}
