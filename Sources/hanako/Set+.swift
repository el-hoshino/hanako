//
//  Set+.swift
//  hanako
//
//  Created by 史翔新 on 2019/12/02.
//

import Foundation

extension Set where Element == Character {
    
    func unsafeRandomElement() -> Element {
        return randomElement() ?? {
            assertionFailure("Trying to extract random element from an empty array.")
            return " "
        }()
    }
    
}
