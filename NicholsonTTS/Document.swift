//
//  Document.swift
//  NicholsonTTS
//
//  Created by Kaj Nicholson on 9/24/20.
//  Copyright © 2020 Kaj Nicholson. All rights reserved.
//

import Cocoa

class Document: NSDocument {

    @objc var attrString = NSAttributedString()
    var contentViewController: ViewController!
    
    
    var viewController: ViewController? {
        return windowControllers[0].contentViewController as? ViewController
    }
    
    override init() {
        super.init()
        // Add your subclass-specific initialization here.        
    }

    override class var autosavesInPlace: Bool {
        return true
    }
    // This enables asynchronous-writing.
    override func canAsynchronouslyWrite(to url: URL, ofType typeName: String, for saveOperation: NSDocument.SaveOperationType) -> Bool {
        return true
    }
    
    override class func canConcurrentlyReadDocuments(ofType: String) -> Bool {
        //if(ofType == "public.plain-text"){ return true }
        if(ofType == "public.rtf"){ return true }
        return false
    }
    
    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        /*
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as! NSWindowController
        self.addWindowController(windowController)*/
        
        // Returns the storyboard that contains your document window.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        if let windowController =
            storyboard.instantiateController(
                withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as? NSWindowController {
            addWindowController(windowController)
            
            // Set the view controller's represented object as your document.
            if let contentVC = windowController.contentViewController as? ViewController {
                contentVC.representedObject = attrString
                contentViewController = contentVC
            }
        }
        
        /*
        hasUndoManager = true
        undoManager?.prepare(withInvocationTarget: attrString)
        
        undoManager?.enableUndoRegistration()
        */
    }

    
    override func data(ofType typeName: String) throws -> Data {
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
        
        // Save the text view contents to disk
        if let textView = viewController?.TextViewer {
            let rangeLength = textView.string.count
            
            textView.breakUndoCoalescing()
            let textRange = NSRange(location: 0, length: rangeLength)
            if let contents = textView.rtf(from: textRange) {
                return contents
            }
        }
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    override func read(from data: Data, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
        // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
        // If you override either of these, you should also override -isEntireFileLoaded to return false if the contents are lazily loaded.
        
        if let contents = NSAttributedString(rtf: data, documentAttributes: nil) {
            attrString = contents
        }
    }

    @objc func windowDidMiniaturize(aNotification: Notification) {
        saveText()
    }
    
    func saveText() {
        if let textView = viewController?.TextViewer {
            attrString = textView.attributedString()
        }
    }    
    
}
