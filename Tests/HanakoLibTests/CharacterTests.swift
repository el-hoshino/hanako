//
//  CharacterTests.swift
//  hanakoTests
//
//  Created by 史 翔新 on 2019/12/04.
//

import XCTest
@testable import HanakoLib

final class CharacterTests: XCTestCase {
    
    func testCharacterSet() {
        
        typealias TestCase = (characterKind: Character.Kind, shouldContainingCharacters: [Character], shouldNotContainingCharacters: [Character])
        let testCases: [TestCase] = [
            (.uppercasedAlphabet, "ABC".characters, "abc123".characters),
            (.lowercasedAlphabet, "abc".characters, "ABC123".characters),
            (.numeric, "123".characters, "ABCabc".characters)
        ]
        
        for testCase in testCases {
            testCase.shouldContainingCharacters.forEach {
                XCTAssertTrue(testCase.characterKind.characterSet.contains($0))
            }
            testCase.shouldNotContainingCharacters.forEach {
                XCTAssertFalse(testCase.characterKind.characterSet.contains($0))
            }
        }
                
    }
    
    static var allTests = [
        ("testCharacterSet", testCharacterSet),
    ]
    
}

private extension String {
    
    var characters: [Character] {
        return map({ $0 })
    }
    
}
