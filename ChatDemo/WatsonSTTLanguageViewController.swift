//
//  WatsonSTTVoiceViewController.swift
//  Watson Conversation
//
//  Created by Marco Aurélio Bigélli Cardoso on 10/04/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import UIKit

class WatsonSTTLanguageViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var picker: UIPickerView!
    
    var pickerData = [
        "ar-AR_BroadbandModel",
        "en-UK_BroadbandModel",
        "en-UK_NarrowbandModel",
        "en-US_BroadbandModel",
        "en-US_NarrowbandModel",
        "es-ES_BroadbandModel",
        "es-ES_NarrowbandModel",
        "fr-FR_BroadbandModel",
        "ja-JP_BroadbandModel",
        "ja-JP_NarrowbandModel",
        "pt-BR_BroadbandModel",
        "pt-BR_NarrowbandModel",
        "zh-CN_BroadbandModel",
        "zh-CN_NarrowbandModel"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.dataSource = self
        picker.delegate = self
        
        if pickerData.contains(Settings.speechToTextLanguage) {
            picker.selectRow(pickerData.index(of: Settings.speechToTextLanguage)!, inComponent: 0, animated: true)
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
        Settings.speechToTextLanguage = pickerData[row]
    }
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
}
