//
//  VoiceSynthesizer.swift
//  Watson Conversation
//
//  Created by Marco Aurélio Bigélli Cardoso on 27/04/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

@objc protocol VoiceSynthesizer: class {
    weak var delegate: VoiceSynthesizerDelegate? { get set }
    func synthesize(text: String)
    func cancel()
}

@objc protocol VoiceSynthesizerDelegate: class {
    @objc optional func voiceSynthesizer(_ synthesizer: VoiceSynthesizer, didStartSynthesis text: String)
    @objc optional func voiceSynthesizer(_ synthesizer: VoiceSynthesizer, didFinishSynthesis text: String)
    @objc optional func voiceSynthesizer(_ synthesizer: VoiceSynthesizer, didStartSpeech text: String)
    @objc optional func voiceSynthesizer(_ synthesizer: VoiceSynthesizer, didFinishSpeech text: String)
    @objc optional func voiceSynthesizer(_ synthesizer: VoiceSynthesizer, errorDidOccur error: String)
}
