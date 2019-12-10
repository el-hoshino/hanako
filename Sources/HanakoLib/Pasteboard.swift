//
//  Pasteboard.swift
//  HanakoLib
//
//  Created by 史翔新 on 2019/12/02.
//

import Cocoa

extension NSPasteboard {
    
    func replacePasteboardItem(with text: String) {
        
        clearContents()
        
        let item = NSPasteboardItem()
        item.setString(text, forType: .string)
        writeObjects([item])
        
    }
    
}
