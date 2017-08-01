//
//  Settings.swift
//  Watson Conversation
//
//  Created by Marco Aurélio Bigélli Cardoso on 02/02/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

class Settings {
    
    static var speechRecognitionUsername = ""
    static var speechRecognitionPassword = ""
    static var useSpeechToText = false
    static var useNativeRecognition = true
    static var speechToTextLanguage = ""
    static var nativeRecognitionLanguage = ""
    
    static var orchestratorUsername = ""
    static var orchestratorPassword = ""
    static var useConversation = true
    static var conversationWorkspace = ""
    static var customOrchestratorURL = ""
    static var messageURL: String {
        get {
            if useConversation {
                return "https://gateway.watsonplatform.net/conversation/api/v1/workspaces/\(conversationWorkspace)/message?version=2017-04-21"
            } else {
                return customOrchestratorURL
            }
        }
    }
    
    static var voiceSynthesisUsername = ""
    static var voiceSynthesisPassword = ""
    static var useTextToSpeech = false
    static var useNativeSynthesis = true
    static var textToSpeechVoice = ""
    static var nativeSynthesisVoice = ""
    static var customVoiceSynthesisURL = ""
    static var voiceSynthesisURL: String {
        get {
            if useTextToSpeech {
                return "https://stream.watsonplatform.net/text-to-speech/api/v1/synthesize?voice=\(textToSpeechVoice)"
            } else {
                return customVoiceSynthesisURL
            }
        }
    }
    
    static func saveToDisk() {
        UserDefaults.standard.set(speechRecognitionUsername, forKey: "speechRecognitionUsername")
        UserDefaults.standard.set(speechRecognitionPassword, forKey: "speechRecognitionPassword")
        UserDefaults.standard.set(useSpeechToText, forKey: "useSpeechToText")
        UserDefaults.standard.set(useNativeRecognition, forKey: "useNativeRecognition")
        UserDefaults.standard.set(speechToTextLanguage, forKey: "speechToTextLanguage")
        UserDefaults.standard.set(nativeRecognitionLanguage, forKey: "nativeRecognitionLanguage")
        
        UserDefaults.standard.set(orchestratorUsername, forKey: "orchestratorUsername")
        UserDefaults.standard.set(orchestratorPassword, forKey: "orchestratorPassword")
        UserDefaults.standard.set(useConversation, forKey: "useConversation")
        UserDefaults.standard.set(conversationWorkspace, forKey: "conversationWorkspace")
        UserDefaults.standard.set(customOrchestratorURL, forKey: "customOrchestratorURL")
        
        UserDefaults.standard.set(voiceSynthesisUsername, forKey: "voiceSynthesisUsername")
        UserDefaults.standard.set(voiceSynthesisPassword, forKey: "voiceSynthesisPassword")
        UserDefaults.standard.set(useTextToSpeech, forKey: "useTextToSpeech")
        UserDefaults.standard.set(useNativeSynthesis, forKey: "useNativeSynthesis")
        UserDefaults.standard.set(textToSpeechVoice, forKey: "textToSpeechVoice")
        UserDefaults.standard.set(nativeSynthesisVoice, forKey: "nativeSynthesisVoice")
        UserDefaults.standard.set(customVoiceSynthesisURL, forKey: "customVoiceSynthesisURL")
    }
    
    static func loadFromDisk() {
        speechRecognitionUsername = UserDefaults.standard.value(forKey: "speechRecognitionUsername") as? String ?? ""
        speechRecognitionPassword = UserDefaults.standard.value(forKey: "speechRecognitionPassword") as? String ?? ""
        useSpeechToText = UserDefaults.standard.value(forKey: "useSpeechToText") as? Bool ?? false
        useNativeRecognition = UserDefaults.standard.value(forKey: "useNativeRecognition") as? Bool ?? true
        speechToTextLanguage = UserDefaults.standard.value(forKey: "speechToTextLanguage") as? String ?? "en-US_BroadbandModel"
        nativeRecognitionLanguage = UserDefaults.standard.value(forKey: "nativeRecognitionLanguage") as? String ?? "en-US"
        
        orchestratorUsername = UserDefaults.standard.value(forKey: "orchestratorUsername") as? String ?? ""
        orchestratorPassword = UserDefaults.standard.value(forKey: "orchestratorPassword") as? String ?? ""
        useConversation = UserDefaults.standard.value(forKey: "useConversation") as? Bool ?? true
        conversationWorkspace = UserDefaults.standard.value(forKey: "conversationWorkspace") as? String ?? ""
        customOrchestratorURL = UserDefaults.standard.value(forKey: "customOrchestratorURL") as? String ?? ""

        voiceSynthesisUsername = UserDefaults.standard.value(forKey: "voiceSynthesisUsername") as? String ?? ""
        voiceSynthesisPassword = UserDefaults.standard.value(forKey: "voiceSynthesisPassword") as? String ?? ""
        useTextToSpeech = UserDefaults.standard.value(forKey: "useTextToSpeech") as? Bool ?? false
        useNativeSynthesis = UserDefaults.standard.value(forKey: "useNativeSynthesis") as? Bool ?? true
        textToSpeechVoice = UserDefaults.standard.value(forKey: "textToSpeechVoice") as? String ?? "en-US_MichaelVoice"
        nativeSynthesisVoice = UserDefaults.standard.value(forKey: "nativeSynthesisVoice") as? String ?? "en-US"
        customVoiceSynthesisURL = UserDefaults.standard.value(forKey: "customVoiceSynthesisURL") as? String ?? ""
    }
    
    static func clearAudioCache() {
        let fileManager = FileManager.default
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/"
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: documentsPath)
            for filePath in filePaths {
                print(filePath)
                try fileManager.removeItem(atPath: documentsPath + filePath)
            }
        } catch {
            print("Could not clear audio cache: \(error)")
        }
    }
}
