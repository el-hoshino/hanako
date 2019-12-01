//
//  Pasteboard.swift
//  hanako
//
//  Created by 史翔新 on 2019/12/02.
//

import Cocoa

func copyStringToPasteboard(_ string: String) {
    
    let board = NSPasteboard.general
    board.clearContents()
    
    let item = NSPasteboardItem()
    item.setString(string, forType: .string)
    board.writeObjects([item])
    
}
