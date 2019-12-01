//
//  Character+.swift
//  hanako
//
//  Created by 史翔新 on 2019/12/02.
//

import Foundation

extension Character {
    
    static let uppercaseCharacters: Set<Character> = {
        let string = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return string.characterSet
    }()

    static let lowercaseCharacters: Set<Character> = {
        let string = "abcdefghijklmnopqrstuvwxyz"
        return string.characterSet
    }()

    static let numericCharacters: Set<Character> = {
        let string = "0123456789"
        return string.characterSet
    }()

    enum Kind {
        case uppercasedAlphabet
        case lowercasedAlphabet
        case numeric
    }
    
}
