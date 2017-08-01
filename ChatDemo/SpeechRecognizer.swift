//
//  SpeechRecognizer.swift
//  Watson Conversation
//
//  Created by Marco Aurélio Bigélli Cardoso on 10/04/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

@objc protocol SpeechRecognizer: class {
    weak var delegate: SpeechRecognizerDelegate? { get set }
    func startRecording()
    func cancel()
}

@objc protocol SpeechRecognizerDelegate: class {
    @objc optional func speechRecognizerDidStart(_ recognizer: SpeechRecognizer)
    @objc optional func speechRecognizer(_ recognizer: SpeechRecognizer, didFinishRecognition result: String)
    @objc optional func speechRecognizer(_ recognizer: SpeechRecognizer, errorDidOccur error: String)
}
