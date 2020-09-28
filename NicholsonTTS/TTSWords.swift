//
//  TTSWords.swift
//  NicholsonTTS
//
//  Created by Kaj Nicholson on 9/17/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import Cocoa

class TTSWords{
    
    init(vControl: ViewController){
        vC = vControl
        stopReadingLocation = vC.TextViewer.string.count
        sectionLocation = 0
        sectionLength = 0
        hLighter = highLigher(textview: vC.TextViewer)
    }
    
    let vC: ViewController
    var ttsEngine: TTSEngine{ get{ return vC.ttsEngine } }
    
    var stopReadingLocation: Int
    var sectionLocation: Int
    var sectionLength: Int
    var readOn = false
    var readSwitch = TTSState.stop
    
    let hLighter: highLigher
    //let highlighter:
    // MARK: - Speak Button Functions
    func pressForSpeech(){
        let selectedRange = vC.TextViewer.selectedRange()
        let endOfString = vC.TextViewer.string.count
        
        
        sectionLocation = selectedRange.location
        if(sectionLocation == endOfString){
            sectionLocation = 0
        }

        stopReadingLocation = selectedRange.length + selectedRange.location
        if(selectedRange.length == 0){
            stopReadingLocation = endOfString
        }
        sectionLength = 0
        
        getNextSection()
        pressForResume()
    }
    
    func pressForPause(){
        readOn = false
        readSwitch = TTSState.pause
        ttsEngine.stopRead()
        sectionLocation = lastRange.location
        sectionLength = lastRange.length
        readSectionEnd()
    }
    
    func pressForResume(){
        readOn = true
        readSwitch = TTSState.read
        readSentance()
    }
    
    func ceilClickedSoEnd(){
        readOn = false
        readSwitch = TTSState.stop
        vC.RButton.title = "Read"
        if( ttsEngine.checkIfSpeaking() ){
            ttsEngine.stopRead()
            readSectionEnd()
        }
    }
    
    
    // MARK: - Sentance Builder
    func getNextSection(){
        if(sectionLength != 0){
            sectionLocation += sectionLength
            sectionLocation = sectionBuilder.startPoint(theString: vC.TextViewer.string, loc: sectionLocation, stopLoc: stopReadingLocation)
            if(sectionLocation == stopReadingLocation){
                readSwitch = TTSState.stop
                readOn = false
                vC.RButton.title = "Read"
                return
            }
        }
        sectionLength = sectionBuilder.sentanceLength(theString: vC.TextViewer.string, sectionLocation: sectionLocation, stopLocation: stopReadingLocation)
    }
    
    // MARK: - Read Control
    func readSentance(){
        if(readOn == true){
            readSectionStart()
        }
    }
    
    var lastRange = NSMakeRange(0,0)
    
    func readSectionStart(){
        let nsRange = NSMakeRange(sectionLocation, sectionLength)
        
        if(isNSRangeVisible(theRange: nsRange) == false){
            scrollToNSRange(theRange: nsRange)
        }
        
        hLighter.applyHighlightToRange(range: nsRange)
        
        lastRange = nsRange
        
        if let readRange = sectionBuilder.makeRange(theString: vC.TextViewer.string, loc: sectionLocation, len: sectionLength) {
            let readableString = String(vC.TextViewer.string[readRange])
            ttsEngine.read(sentance: readableString)
        }
        getNextSection()
    }
    
    func readSectionEnd(){
        hLighter.removeHighlightFromRange(range: lastRange)
        readSentance()
    }
    
    // MARK: - Move To Range
    func isNSRangeVisible(theRange: NSRange) -> Bool{
        let visibleRange = vC.TextViewer.accessibilityVisibleCharacterRange()
        let intersect = NSIntersectionRange(visibleRange, theRange)
        return NSEqualRanges(theRange, intersect)
    }
    func scrollToNSRange(theRange: NSRange){
        let yInt = theRange.lowerBound
        let scrollPoint = NSPoint(x: 0, y: yInt)
        vC.TextViewer.scroll(scrollPoint)
    }
}

enum TTSState{
    case read
    case pause
    case stop
}
