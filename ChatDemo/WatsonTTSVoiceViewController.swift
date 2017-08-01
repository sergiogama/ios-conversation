//
//  WatsonTTSVoiceViewController.swift
//  Watson Conversation
//
//  Created by Marco Aurélio Bigélli Cardoso on 10/04/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import UIKit

class WatsonTTSVoiceViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var picker: UIPickerView!
    
    var pickerData = [
        "de-DE_BirgitVoice",
        "de-DE_DieterVoice",
        "en-GB_KateVoice",
        "en-US_AllisonVoice",
        "en-US_LisaVoice",
        "en-US_MichaelVoice",
        "es-ES_LauraVoice",
        "es-ES_EnriqueVoice",
        "es-LA_SofiaVoice",
        "es-US_SofiaVoice",
        "fr-FR_ReneeVoice",
        "it-IT_FrancescaVoice",
        "ja-JP_EmiVoice",
        "pt-BR_IsabelaVoice"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.dataSource = self
        picker.delegate = self
        
        if pickerData.contains(Settings.textToSpeechVoice) {
            picker.selectRow(pickerData.index(of: Settings.textToSpeechVoice)!, inComponent: 0, animated: true)
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
        Settings.textToSpeechVoice = pickerData[row]
    }
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
}
