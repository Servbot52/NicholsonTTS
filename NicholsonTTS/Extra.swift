//
//  Little Extentions.swift
//  NicholsonTTS
//
//  Created by Kaj Nicholson on 9/17/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import Cocoa

struct alertStuff{
    static func gen(theMessage: String){
        let alert = NSAlert()
        alert.messageText = theMessage
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}
