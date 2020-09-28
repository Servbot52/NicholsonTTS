//
//  Highlighter.swift
//  NicholsonTTS
//
//  Created by Kaj Nicholson on 9/21/20.
//  Copyright © 2020 Apple. All rights reserved.



import Foundation
import Cocoa

class highLigher{
    init(textview: NSTextView){
        textView = textview
        oldAttributes = textView.attributedString()
    }
    // MARK: - Highlighting
    let textView: NSTextView
    var oldAttributes: NSAttributedString
    
    var currenltyLighted = false
    
    func applyHighlightToRange(range: NSRange){
        guard let textStorage = textView.textStorage else { return }
        
        textStorage.beginEditing()
        
        oldAttributes = textStorage.attributedSubstring(from: range)
        textStorage.addAttribute(NSAttributedString.Key.backgroundColor, value: NSColor.yellow, range: range)
        
        textStorage.endEditing()
    }
    
    func removeHighlightFromRange(range: NSRange){
        guard let textStorage = textView.textStorage else { return }
        
        textStorage.beginEditing()
        textStorage.addAttribute(NSAttributedString.Key.backgroundColor, value: NSColor.white, range: range)
        textStorage.endEditing()
    }
    

}
 
