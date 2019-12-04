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
            set.formUnion(type.characterSet)
        }
        
        let random: String
        if hyphenFrequency > 0 {
            let hyphenPosition = hyphenFrequency + 1
            random = (1 ... length).reduce("") { (string, index) -> String in
                if index % hyphenPosition == 0 {
                    return string + "-"
                } else {
                    return string + "\(characterList.unsafeRandomElement())"
                }
            }
            
        } else {
            random = (1 ... length).reduce("") { (string, _) -> String in
                return string + "\(characterList.unsafeRandomElement())"
            }
        }
        
        if length >= types.count {
            
            for type in types {
                
                guard random.containsAnyCharacterInSet(type.characterSet) else {
                    return randomString(ofLength: length, from: types, hyphenFrequency: hyphenFrequency)
                }
                
            }
        }
        
        return random
        
    }
    
}
