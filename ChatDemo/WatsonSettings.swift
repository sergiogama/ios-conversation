//
//  WatsonSettings.swift
//  Watson Conversation
//
//  Created by Marco Aurélio Bigélli Cardoso on 16/04/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

class WatsonSettings {
    var speechRecognitionUsername = ""
    var speechRecognitionPassword = ""
    var useSpeechToText = true
    var useNativeRecognition = false
    var speechToTextLanguage = ""
    var nativeRecognitionLanguage = ""
    
    var orchestratorUsername = ""
    var orchestratorPassword = ""
    var useConversation = true
    var conversationWorkspace = ""
    var customOrchestratorURL = ""
    var messageURL: String {
        get {
            if useConversation {
                return "https://gateway.watsonplatform.net/conversation/api/v1/workspaces/\(conversationWorkspace)/message?version=2016-09-20"
            } else {
                return customOrchestratorURL
            }
        }
    }
    
    var voiceSynthesisUsername = ""
    var voiceSynthesisPassword = ""
    var useTextToSpeech = true
    var textToSpeechVoice = "pt-BR_IsabelaVoice"
    var customVoiceSynthesisURL = ""
    var voiceSynthesisURL: String {
        get {
            if useTextToSpeech {
                return "https://stream.watsonplatform.net/text-to-speech/api/v1/synthesize?voice=\(textToSpeechVoice)"
            } else {
                return customVoiceSynthesisURL
            }
        }
    }
}

class SpeechRecognitionSettings {
    var username = ""
    var password = ""
    var type: SpeechRecognitionType = .watson
    var language = "pt-BR"
    var url = ""
}

enum SpeechRecognitionType {
    case watson, ios, custom
}

class OrchestrationSettings {
    var username = ""
    var password = ""
    var type: OrchestrationType = .watson
    var url = ""
}

enum OrchestrationType {
    case watson, custom
}

class VoiceSynthesisSettings {
    var username = ""
    var password = ""
    var type: VoiceSynthesisType = .watson
    var language = "pt-BR"
    var url = ""
}

enum VoiceSynthesisType {
    case watson, custom
}
