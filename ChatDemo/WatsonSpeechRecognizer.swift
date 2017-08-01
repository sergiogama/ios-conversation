//
//  WatsonSpeechRecognizer.swift
//  Watson Conversation
//
//  Created by Marco Aurélio Bigélli Cardoso on 09/04/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import AVFoundation
import SpeechToTextV1

private let SilenceIntervalSinceLastSpokenWord = TimeInterval(2.0)
private let SilenceIntervalSinceRecordingStart = TimeInterval(15.0)

class WatsonSpeechRecognizer: NSObject, SpeechRecognizer, AVAudioRecorderDelegate {
    weak var delegate: SpeechRecognizerDelegate?
    
    let speechToText: SpeechToText
    private var submitTimer: Timer?
    private var transcriptedText: String = ""
    
    override init() {
        let user = Settings.speechRecognitionUsername
        let pass = Settings.speechRecognitionPassword
        speechToText = SpeechToText(username: user, password: pass)
    }
    
    func startRecording() {
        transcriptedText = ""
        var settings = RecognitionSettings(contentType: .opus)
        settings.continuous = true
        settings.interimResults = true
        delegate?.speechRecognizerDidStart?(self)
        rescheduleSubmitTimer(silenceInterval: SilenceIntervalSinceRecordingStart)
        speechToText.recognizeMicrophone(settings: settings, model: Settings.speechToTextLanguage, customizationID: nil, learningOptOut: false, compress: true,
            failure: { failure in
                print(failure.localizedDescription)
                let message = self.messageForFailure(description: failure.localizedDescription)
                self.delegate?.speechRecognizer?(self, errorDidOccur: message)
            },
            success: { results in
                print(results.bestTranscript)
                self.transcriptedText = results.bestTranscript
                self.rescheduleSubmitTimer(silenceInterval: SilenceIntervalSinceLastSpokenWord)
            }
        )
    }
    
    func cancel() {
        transcriptedText = ""
        submitTranscription()
    }
    
    private func submitTranscription() {
        submitTimer?.invalidate()
        speechToText.stopRecognizeMicrophone()
        delegate?.speechRecognizer?(self, didFinishRecognition: transcriptedText)
    }
    
    private func rescheduleSubmitTimer(silenceInterval: TimeInterval) {
        submitTimer?.invalidate()
        submitTimer = Timer.scheduledTimer(
            withTimeInterval: silenceInterval,
            repeats: false,
            block: { _ in
                self.submitTranscription()
            }
        )
    }
    
    private func messageForFailure(description: String) -> String {
        switch description {
        case "Invalid HTTP upgrade": return "Not authorized (status code 401). Make sure the credentials supplied in the Settings are correct"
        case "The operation couldn’t be completed. (RestKit.RestError error 0.)": return "No internet connection"
        default: return "Unknown error"
        }
        
    }
    
}
