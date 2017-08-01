//
//  VoiceSynthesizer.swift
//  Watson Conversation
//
//  Created by Marco Aurélio Bigélli Cardoso on 20/01/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import AVFoundation
import AudioToolbox

class WatsonVoiceSynthesizer: NSObject, VoiceSynthesizer, AVAudioPlayerDelegate {
    
    weak var delegate: VoiceSynthesizerDelegate?
    private var player: AVAudioPlayer?
    
    private var cacheOn = true
    var currentRequest: URLSessionDataTask?
    var currentText = ""
    var filename: String {
        let prefix = Settings.useTextToSpeech ? Settings.textToSpeechVoice : Settings.voiceSynthesisURL
        return String(prefix.hash) + "_" + String(currentText.lowercased().hash) + ".wav"
    }
    
    func synthesize(text: String) {
        
        if text == "" {
            delegate?.voiceSynthesizer?(self, didFinishSynthesis: "")
            delegate?.voiceSynthesizer?(self, didFinishSpeech: "")
            return
        }
        
        if let data = CacheUtils.read(from: filename) {
            play(audio: data)
            return
        }
        
        sendToAPI(text, completion: { data in
            self.play(audio: data)
            if self.cacheOn {
                CacheUtils.write(to: self.filename, data: data)
            }
        })
    }
    
    func cancel() {
        cacheOn = false
        currentRequest?.cancel()
        player?.stop()
        player = nil
//        delegate?.voiceSynthesizer?(self, didFinishSpeech: currentText)
    }
    
    // Activate Watson Text-to-Speech API for audio synthesis
    private func sendToAPI(_ text: String, completion: @escaping (Data) -> (Void)) {
        currentRequest = RestUtils.textToSpeechRequest(text: text,
            success: { data in
                var wav = data
                AudioUtils.repairWAVHeader(data: &wav)
                completion(wav)
                self.cacheOn = true
            }, failure: { reason in
                self.delegate?.voiceSynthesizer?(self, errorDidOccur: reason)
            })
        delegate?.voiceSynthesizer?(self, didStartSynthesis: currentText)
    }
    
    func play(audio: Data) {
        print(audio)
        delegate?.voiceSynthesizer?(self, didFinishSynthesis: currentText)
        delegate?.voiceSynthesizer?(self, didStartSpeech: currentText)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
          //teste-priscilla  try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(data: audio, fileTypeHint: AVFileTypeWAVE)
            player?.delegate = self
            player?.prepareToPlay()
            player?.play()
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
        } catch let error {
            print(error.localizedDescription)
            if error.localizedDescription == "The operation couldn’t be completed. (OSStatus error 1954115647.)" {
                delegate?.voiceSynthesizer?(self, errorDidOccur: "Invalid audio file format. Only WAV is supported in this app.")
            } else if error.localizedDescription == "The operation couldn’t be completed. (OSStatus error -39.)" {
                // Audio is empty, not really an error
            } else {
                delegate?.voiceSynthesizer?(self, errorDidOccur: error.localizedDescription)
            }
        }
    }
    
    
    // MARK: AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        delegate?.voiceSynthesizer?(self, didFinishSpeech: currentText)
        self.player = nil
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("[x] Audio Player Decode Error: \(error?.localizedDescription)")
    }
    
}
