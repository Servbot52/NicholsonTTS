//
//  ViewController.swift
//  NicholsonTTS
//
//  Created by Kaj Nicholson on 9/24/20.
//  Copyright © 2020 Kaj Nicholson. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        VoiceOptions.buildVoiceList(combo: voiceCombo)
        ttsWord = TTSWords(vControl: self)
        ttsEngine = TTSEngine(vControl: self)
        
        TextViewer.delegate = self
        TextViewer.isContinuousSpellCheckingEnabled = true
        
        //undoManager?.prepare(withInvocationTarget: self)
        
    }
    
    var ttsEngine: TTSEngine!
    var ttsWord: TTSWords!

    var programStarted = false
    
    @IBOutlet var TextViewer: NSTextView!
    @IBOutlet weak var RButton: NSButton!
    @IBOutlet weak var rateSlider: NSSlider!
    @IBOutlet weak var voiceCombo: NSComboBox!
    

    // MARK: - Reactions To Controls
    @IBAction func ReadButton(_ sender: Any) {
        programStarted = true
        switch ttsWord.readSwitch{
        case TTSState.stop:
            RButton.title = "Pause"
            ttsWord.pressForSpeech()
        case .read:
            RButton.title = "Resume"
            ttsWord.pressForPause()
        case .pause:
            RButton.title = "Pause"
            ttsWord.pressForResume()
        }
    }
    @IBAction func rateSlideChange(_ sender: Any) {
        ttsEngine.changeRate()
    }
    
    @IBAction func voiceComboAction(_ sender: Any) {
        guard let vName = voiceCombo.objectValueOfSelectedItem as! String? else{
            return
        }
        if let currentVoice = ttsEngine.voice?.name{
            if(vName == currentVoice){ return }
        }
        ttsEngine.setVoice(voiceName: vName)
    }
}

extension ViewController{
// MARK: - Base Parts
    override func viewDidAppear() {
        super.viewDidAppear()
    }
    
    override var representedObject: Any? {
        didSet {
            // Pass down the represented object to all of the child view controllers.
            for child in children {
                child.representedObject = representedObject
            }
        }
    }
    
    weak var document: Document? {
        if let docRepresentedObject = representedObject as? Document {
            return docRepresentedObject
        }
        return nil
    }

    // MARK: - NSTextViewDelegate
    func textDidBeginEditing(_ notification: Notification) {
        document?.objectDidBeginEditing(self)
    }
    func textDidEndEditing(_ notification: Notification) {
        document?.objectDidEndEditing(self)
    }


    //click on textView
    func textView(_: NSTextView, clickedOn: NSTextAttachmentCellProtocol, in: NSRect, at: Int){
        if(programStarted){
            ttsWord.ceilClickedSoEnd()
        }
    }
    //selection changes
    func textViewDidChangeSelection(_: Notification){
        if(programStarted){
            ttsWord.ceilClickedSoEnd()
        }
    }
}
