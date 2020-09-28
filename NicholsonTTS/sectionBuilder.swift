//
//  sectionBuilder.swift
//  NicholsonTTS
//
//  Created by Kaj Nicholson on 9/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct sectionBuilder{
    static let endStringChar = [".", "!","?","\n","\u{2026}"]
    static let afterEndChar = endStringChar + ["\"",")","]","}","\u{2047}"]
    
    static let startChar = [" ", "\n", "\t"]
    
    static func startPoint(theString: String, loc: Int, stopLoc: Int) -> Int
    {
        var searchValue = loc
        
        while searchValue < stopLoc {
            if let checkRange = makeRange(theString: theString, loc: searchValue, len: 1) {
                var startHere = true
                for theChar in startChar{
                    if(theChar == String( theString[checkRange] ) ){
                        startHere = false
                    }
                }
                if startHere { return searchValue }
            }
            searchValue += 1
        }
        return stopLoc
    }
    
    static func makeRange(theString: String, loc: Int, len: Int) -> Range<String.Index>?
    {
        let nsRange = NSMakeRange(loc, len)
        return Range(nsRange, in: theString)
    }
    
    static func sentanceLength(theString: String, sectionLocation: Int, stopLocation: Int) -> Int{
        var searchValue = sectionLocation
        
        while searchValue < stopLocation {
            if let checkRange = makeRange(theString: theString, loc: searchValue, len: 1) {
                for theChar in endStringChar{
                    if(theChar == String( theString[checkRange] ) ){
                        let endPoint = nextCharIncluder(theString: theString, start: searchValue+1, stop: stopLocation)
                        return endPoint - sectionLocation
                    }
                }
            }
            searchValue += 1
        }
        
        return stopLocation - sectionLocation
    }
    
    static func nextCharIncluder(theString: String, start: Int, stop: Int) -> Int{
        var check = start
        while check < stop{
            if let checkRange = makeRange(theString: theString, loc: check, len: 1) {
                var foundEnd = true
                for theChar in afterEndChar{
                    if(theChar == theString[checkRange]){
                        foundEnd = false
                    }
                }
                if(foundEnd){return check}
            }
            check += 1
        }
        return stop
    }
    
}
