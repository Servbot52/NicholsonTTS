//
//  VoicesOptions.swift
//  NicholsonTTS
//
//  Created by Kaj Nicholson on 9/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import AVFoundation
import Cocoa

struct VoiceOptions{
    static func buildVoiceList(combo: NSComboBox){
        combo.removeAllItems()
        
        for voice in AVSpeechSynthesisVoice.speechVoices(){
            if(voice.language == AVSpeechSynthesisVoice.currentLanguageCode()){
                combo.addItem(withObjectValue: voice.name)
            }
        }
        
        let defaults = UserDefaults.standard
        if let voiceName = defaults.string(forKey: defaultsVoice.voiceName) {
            combo.selectItem(withObjectValue: voiceName)
        }
    }
    
    static func getVoiceFromName(voiceName: String) -> AVSpeechSynthesisVoice?{
        for voice in AVSpeechSynthesisVoice.speechVoices(){
            if(voice.name == voiceName){
                return voice
            }
        }
        return AVSpeechSynthesisVoice(language: AVSpeechSynthesisVoice.currentLanguageCode())
    }
    
    /*
    static func buildVoiceListGender(gender: AVSpeechSynthesisVoiceGender, menuSec: NSMenu){
        
        for voice in AVSpeechSynthesisVoice.speechVoices(){
            if(voice.language == AVSpeechSynthesisVoice.currentLanguageCode()){
                if(voice.gender == gender){
                    
                }
            }
        }
        
    }*/
    
}
struct defaultsVoice {
    static let voiceName = "Ava"
    static let voiceRate = "0.5"
}
