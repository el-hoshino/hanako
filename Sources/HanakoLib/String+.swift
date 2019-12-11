//
//  String+.swift
//  HanakoLib
//
//  Created by 史翔新 on 2019/12/02.
//

import Foundation

extension String {
    
    var characterSet: Set<Character> {
        return reduce(into: Set<Character>()) { (result, character) in
            result.insert(character)
        }
    }
    
    func containsAnyCharacterInSet(_ set: Set<Character>) -> Bool {
        
        for character in set {
            if self.contains(character) {
                return true
            }
        }
        
        return false
        
    }
    
}

extension String {
    
    enum RandomStringGenerationError: Error {
        case noCaharactersAvailableToUseInGeneratingRandomString
    }
    
    static func randomString(ofLength length: Int, from types: Set<Character.Kind>, hyphenFrequency: Int) throws -> String {
        
        func shouldInsertHyphen(at index: Int) -> Bool {
            
            let insertsHyphen = (hyphenFrequency > 0)
            let hyphenPosition = hyphenFrequency + 1
            
            return insertsHyphen && (index % hyphenPosition == 0)
            
        }
        
        guard types.count > 0 else {
            throw RandomStringGenerationError.noCaharactersAvailableToUseInGeneratingRandomString
        }
        
        let characterList = types.reduce(into: Set<Character>()) { (set, type) in
            set.formUnion(type.characterSet)
        }
        
        let random = (1 ... length).reduce(into: "") { (result, index) in
            if shouldInsertHyphen(at: index) {
                result.append("-")
            } else {
                result.append(characterList.unsafeRandomElement())
            }
        }
        
        if length >= types.count {
            for type in types {
                guard random.containsAnyCharacterInSet(type.characterSet) else {
                    return try randomString(ofLength: length, from: types, hyphenFrequency: hyphenFrequency)
                }
            }
        }
        
        return random
        
    }
    
}
