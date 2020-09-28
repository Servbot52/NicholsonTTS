//
//  TTSEngine.swift
//  NicholsonTTS
//
//  Created by Kaj Nicholson on 9/17/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import AVFoundation

class TTSEngine: NSObject, AVSpeechSynthesizerDelegate {
    let synth = AVSpeechSynthesizer()
    
    init(vControl: ViewController){
        vC = vControl
        super.init()
        synth.delegate = self
        
        let defaults = UserDefaults.standard
        if let voiceName = defaults.string(forKey: defaultsVoice.voiceName) {
            setVoice(voiceName: voiceName)
        }
        if let voiceRate = defaults.string(forKey: defaultsVoice.voiceRate) {
            speed = Float(voiceRate) ?? Float(0.5)
            vControl.rateSlider.doubleValue = Double(speed * Float(vControl.rateSlider.maxValue))
        }
    }
    
    var vC: ViewController
    var ttsWord: TTSWords{ get{ return vC.ttsWord } }
    
    var voice: AVSpeechSynthesisVoice! = AVSpeechSynthesisVoice(language: AVSpeechSynthesisVoice.currentLanguageCode())
    var speed: Float = 0.5
    
    func setVoice(voiceName: String){
        voice = VoiceOptions.getVoiceFromName(voiceName: voiceName)
        if let vName = vC.voiceCombo.objectValueOfSelectedItem as! String? {
            if(voice.name != vName){
                vC.voiceCombo.selectItem(withObjectValue: voice.name)
            }
        }
        let defaults = UserDefaults.standard
        defaults.set(voice.name, forKey: defaultsVoice.voiceName)
    }
    func changeRate(){
        let maxSlid = vC.rateSlider.maxValue
        let maxVoice = Float(1.0)
        speed = Float(vC.rateSlider.doubleValue / maxSlid) * maxVoice
        
        let defaults = UserDefaults.standard
        defaults.set(String(speed), forKey: defaultsVoice.voiceRate)
    }
    
    func read(sentance: String){
        let utterance = AVSpeechUtterance(string: sentance)
        utterance.voice = voice
        utterance.rate = speed
        
        synth.speak(utterance)
    }
    
    func stopRead(){
        synth.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    func checkIfSpeaking() -> Bool{
        return synth.isSpeaking
    }
    
    //finish say word?
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        //let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
        //mutableAttributedString.addAttribute(.foregroundColor, value: NSColor.red, range: characterRange)
        //label.attributedText = mutableAttributedString
    }

    //finish talking
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        ttsWord.readSectionEnd()
    }
}
