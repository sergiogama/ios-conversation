
//  Watson.swift
//  Watson Conversation
//
//  Created by Marco Aurélio Bigélli Cardoso on 19/01/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import AVFoundation
import AudioToolbox

class Watson: NSObject {
    
    weak var delegate: WatsonDelegate?
    
    let speechRecognizer: SpeechRecognizer
    let languageClassifier: LanguageClassifier
    let voiceSynthesizer: VoiceSynthesizer
    
    var state: WatsonState = .idle
    
    var scheduledActions: [WatsonAction] = []
    var lastTranscription = ""
    var lastAnswer = ""
    
    override init() {
        // Initialize all three modules and set delegate to self
        if Settings.useSpeechToText {
            speechRecognizer = WatsonSpeechRecognizer()
        } else {
            speechRecognizer = NativeSpeechRecognizer()
        }
        
        languageClassifier = LanguageClassifier()
        
        if Settings.useNativeSynthesis {
            voiceSynthesizer = NativeVoiceSynthesizer()
        } else {
            voiceSynthesizer = WatsonVoiceSynthesizer()
        }
        
        super.init()
        speechRecognizer.delegate = self
        languageClassifier.delegate = self
        voiceSynthesizer.delegate = self
    }
    
    // MARK: - Interface
    
    // Interaction may start/stop at any point: recognition, orchestration or synthesis.
    
    func startListening() {
        schedule(RecognitionAction())
        schedule(ClassificationAction())
        schedule(SynthesisAction())
    }
    
    func answer(_ question: String) {
        schedule(ClassificationAction(question: question))
        schedule(SynthesisAction())
    }
    
    func speak(_ text: String) {
        schedule(SynthesisAction(text: text))
    }
    
    func stop() {
        scheduledActions.removeAll()
        switch state {
        case .idle: break
        case .listening: speechRecognizer.cancel()
        case .classifying: languageClassifier.cancel()
        case .synthesizing: voiceSynthesizer.cancel()
        case .speaking: voiceSynthesizer.cancel()
        }
        setState(.idle)
    }
    
    // MARK: - Private
    
    fileprivate func setState(_ newState: WatsonState) {
        state = newState
        delegate?.didChangeState(to: newState)
        if state == .idle {
            nextAction()
        }
    }
    
    private func schedule(_ action: WatsonAction) {
        scheduledActions.append(action)
        if state == .idle {
            nextAction()
        }
    }
    
    private func nextAction() {
        guard let action = scheduledActions.first else { return }
        scheduledActions.remove(at: 0)
        if action is RecognitionAction {
            speechRecognizer.startRecording()
        }
        else if action is ClassificationAction {
            languageClassifier.classify(text: action.data as? String ?? lastTranscription)
        }
        else if action is SynthesisAction {
            voiceSynthesizer.synthesize(text: action.data as? String ?? lastAnswer)
        }
    }
}


// MARK: SpeechRecognizerDelegate
extension Watson: SpeechRecognizerDelegate {
    
    func speechRecognizerDidStart(_ recognizer: SpeechRecognizer) {
        setState(.listening)
    }
    
    func speechRecognizer(_ recognizer: SpeechRecognizer, didFinishRecognition result: String) {
        lastTranscription = result
        setState(.idle)
    }
    
    func speechRecognizer(_ recognizer: SpeechRecognizer, errorDidOccur error: String) {
        stop()
        delegate?.didFail(module: "SpeechRecognizer", description: error)
    }
    
}

// MARK: - LanguageClassifierDelegate
extension Watson: LanguageClassifierDelegate {
    
    func languageClassifier(_ classifier: LanguageClassifier, didStartClassifying text: String) {
        setState(.classifying)
    }
    
    func languageClassifier(_ classifier: LanguageClassifier, didFinishClassifying result: String) {
        lastAnswer = result
        setState(.idle)
    }
    
    func languageClassifier(_ classifier: LanguageClassifier, errorDidOccur error: String) {
        stop()
        delegate?.didFail(module: "LanguageClassifier", description: error)
    }

}

// MARK: - VoiceSynthesizerDelegate
extension Watson: VoiceSynthesizerDelegate {
    
    func voiceSynthesizer(_ synthesizer: VoiceSynthesizer, didStartSynthesis text: String) {
        setState(.synthesizing)
    }
    
    func voiceSynthesizer(_ synthesizer: VoiceSynthesizer, didStartSpeech text: String) {
        setState(.speaking)
    }
    
    func voiceSynthesizer(_ synthesizer: VoiceSynthesizer, didFinishSpeech text: String) {
        setState(.idle)
    }
    
    func voiceSynthesizer(_ synthesizer: VoiceSynthesizer, errorDidOccur error: String) {
        delegate?.didFail(module: "VoiceSynthesizer", description: error)
        stop()
    }

}

// MARK: - Auxiliary definitions

protocol WatsonAction {
    var data: Any? { get }
}

struct RecognitionAction: WatsonAction {
    var data: Any?
}

struct ClassificationAction: WatsonAction {
    var data: Any?
    init(question: String? = nil) {
        self.data = question
    }
}

struct SynthesisAction: WatsonAction {
    let data: Any?
    init(text: String? = nil) {
        self.data = text
    }
}

enum WatsonState {
    case idle
    case listening
    case classifying
    case synthesizing
    case speaking
}

protocol WatsonDelegate: class {
    func didChangeState(to newState: WatsonState)
    func didFail(module: String, description: String)
}
