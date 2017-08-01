//
//  NativeTTSVoiceViewController.swift
//  Watson Conversation
//
//  Created by Marco Aurélio Bigélli Cardoso on 10/04/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import UIKit
import Speech

class NativeTTSVoiceViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var picker: UIPickerView!
    
    var pickerData = AVSpeechSynthesisVoice.speechVoices().map { $0.language }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.dataSource = self
        picker.delegate = self
        
        if pickerData.contains(Settings.nativeSynthesisVoice) {
            picker.selectRow(pickerData.index(of: Settings.nativeSynthesisVoice)!, inComponent: 0, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Settings.saveToDisk()
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Settings.nativeSynthesisVoice = pickerData[row]
    }
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
}
