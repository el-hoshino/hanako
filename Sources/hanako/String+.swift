//
//  String+.swift
//  hanako
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
    
    static func randomString(ofLength length: Int, from types: Set<Character.Kind>, hyphenFrequency: Int) -> String {
        
        guard types.count > 0 else {
            let errorMessage = "No characters able to use in random string, please check your setting.\n"
            print(errorMessage)
            exit(EXIT_FAILURE)
        }
        
        let characterList = types.reduce(into: Set<Character>()) { (set, type) in
            let nextList: Set<Character>
            switch type {
            case .uppercasedAlphabet:
                nextList = Character.uppercaseCharacters
                
            case .lowercasedAlphabet:
                nextList = Character.lowercasedCharacters
                
            case .numeric:
                nextList = Character.numericCharacters
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
                    characterSet = Character.uppercaseCharacters
                    
                case .lowercasedAlphabet:
                    characterSet = Character.lowercasedCharacters
                    
                case .numeric:
                    characterSet = Character.numericCharacters
                }
                
                guard randomString.containsAnyCharacterInSet(characterSet) else {
                    return randomString(ofLength: length, from: types, hyphenFrequency: hyphenFrequency)
                }
                
            }
        }
        
        return randomString
        
    }
    
}
