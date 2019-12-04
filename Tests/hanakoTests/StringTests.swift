//
//  StringTests.swift
//  hanakoTests
//
//  Created by 史 翔新 on 2019/12/04.
//

import XCTest
@testable import hanako

final class StringTests: XCTestCase {
    
    func testCharacterSet() {
        
        let testString = "abc"
        for character in testString {
            XCTAssertTrue(testString.characterSet.contains(character))
        }
        for character in "def" {
            XCTAssertFalse(testString.characterSet.contains(character))
        }
                
    }
    
    func testContainsAnyCharacterInSet() {
        
        typealias TestCase = (testString: String, shouldReturnTrueCharacterSet: Set<Character>, shouldReturnFalseCharacterSet: Set<Character>)
        let testCases: [TestCase] = [
            ("abc", "Aa1".characterSet, "def".characterSet),
            ("abc", "abc".characterSet, "".characterSet),
        ]
        for testCase in testCases {
            XCTAssertTrue(testCase.testString.containsAnyCharacterInSet(testCase.shouldReturnTrueCharacterSet))
            XCTAssertFalse(testCase.testString.containsAnyCharacterInSet(testCase.shouldReturnFalseCharacterSet))
        }
        
    }
    
    func testRandomString() {
        
        typealias TestCase = (length: Int, types: Set<Character.Kind>)
        let testCases: [TestCase] = [
            (6, [.lowercasedAlphabet]),
            (4, [.uppercasedAlphabet, .numeric]),
            (9, [.numeric, .lowercasedAlphabet]),
            (5, [.lowercasedAlphabet, .uppercasedAlphabet, .numeric]),
        ]
        for testCase in testCases {
            let result = String.randomString(ofLength: testCase.length, from: testCase.types, hyphenFrequency: 0)
            XCTAssertEqual(result.count, testCase.length)
            for type in testCase.types {
                XCTAssertTrue(result.containsAnyCharacterInSet(type.characterSet))
            }
            for type in Character.Kind.all(excluding: testCase.types) {
                XCTAssertFalse(result.containsAnyCharacterInSet(type.characterSet))
            }
        }
        
    }
    
}

private extension Character.Kind {
    
    static func all(excluding: Set<Self>) -> Set<Self> {
        let all: Set<Self> = [.uppercasedAlphabet, .lowercasedAlphabet, .numeric]
        let excluded = all.filter({ !excluding.contains($0) })
        return excluded
    }
    
}
