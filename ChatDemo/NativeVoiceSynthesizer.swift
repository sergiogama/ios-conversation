//
//  NativeVoiceSynthesizer.swift
//  Watson Conversation
//
//  Created by Marco Aurélio Bigélli Cardoso on 27/04/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import Speech

class NativeVoiceSynthesizer: NSObject, VoiceSynthesizer, AVSpeechSynthesizerDelegate {
    
    weak var delegate: VoiceSynthesizerDelegate?
    let synthesizer = AVSpeechSynthesizer()

    override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    func synthesize(text: String) {
      //teste-priscilla   try? AVAudioSession.sharedInstance().setActive(true, with: .notifyOthersOnDeactivation)
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: Settings.nativeSynthesisVoice)
        
        synthesizer.speak(utterance)
    }

    func cancel() {
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        delegate?.voiceSynthesizer?(self, didStartSpeech: utterance.speechString)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        delegate?.voiceSynthesizer?(self, didFinishSpeech: utterance.speechString)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        delegate?.voiceSynthesizer?(self, didFinishSpeech: utterance.speechString)
    }
    
    
    
}
