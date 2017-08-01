//
//  VoiceSynthesisSettingsViewController.swift
//  Watson Conversation
//
//  Created by Marco Aurélio Bigélli Cardoso on 09/04/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import UIKit

class VoiceSynthesisSettingsViewController: QRReadyTableViewController {
    
    @IBOutlet weak var useTextToSpeechCell: UITableViewCell!
    @IBOutlet weak var useNativeSynthesisCell: UITableViewCell!
    @IBOutlet weak var useCustomSynthesisCell: UITableViewCell!
    
    @IBOutlet weak var voiceSynthesisUserTF: UITextField!
    @IBOutlet weak var voiceSynthesisPwdTF: UITextField!
    
    @IBOutlet weak var voiceSynthesisURLTF: UITextField!
    @IBOutlet weak var voiceSynthesisURLCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Settings.useTextToSpeech {
            useTextToSpeechCell.accessoryType = .checkmark
            useNativeSynthesisCell.accessoryType = .none
            useCustomSynthesisCell.accessoryType = .none
        } else if Settings.useNativeSynthesis {
            useTextToSpeechCell.accessoryType = .none
            useNativeSynthesisCell.accessoryType = .checkmark
            useCustomSynthesisCell.accessoryType = .none
        } else {
            useTextToSpeechCell.accessoryType = .none
            useNativeSynthesisCell.accessoryType = .none
            useCustomSynthesisCell.accessoryType = .checkmark
        }
        
        voiceSynthesisUserTF.text = Settings.voiceSynthesisUsername
        voiceSynthesisPwdTF.text = Settings.voiceSynthesisPassword
        voiceSynthesisURLTF.text = Settings.customVoiceSynthesisURL
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Settings.voiceSynthesisUsername = voiceSynthesisUserTF.text!
        Settings.voiceSynthesisPassword = voiceSynthesisPwdTF.text!
        Settings.customVoiceSynthesisURL = voiceSynthesisURLTF.text!
        
        Settings.saveToDisk()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            if indexPath.item == 0 {
                Settings.useTextToSpeech = true
                Settings.useNativeSynthesis = false
            } else if indexPath.item == 1 {
                Settings.useTextToSpeech = false
                Settings.useNativeSynthesis = true
            } else if indexPath.item == 2 {
                Settings.useTextToSpeech = false
                Settings.useNativeSynthesis = false
            }
            for i in 0...2 {
                tableView.cellForRow(at: IndexPath(item: i, section: 0))?.accessoryType = .none
            }
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            tableView.reloadData()
        }
        
        if indexPath.section == 5 {
            UIHelper.confirmAlert(title: "Delete Audio Cache", text: "Are you sure you want to delete all audio cache?", owner: self, okHandler: { _ in
                Settings.clearAudioCache()
            })
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
