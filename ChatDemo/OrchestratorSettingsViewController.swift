//
//  OrchestratorSettingsViewController.swift
//  Watson Conversation
//
//  Created by Marco Aurélio Bigélli Cardoso on 09/04/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import UIKit

class OrchestratorSettingsViewController: QRReadyTableViewController {
    
    @IBOutlet weak var useConversationCell: UITableViewCell!
    @IBOutlet weak var useCustomOrchestratorCell: UITableViewCell!
    
    @IBOutlet weak var orchestratorUserTF: UITextField!
    @IBOutlet weak var orchestratorPwdTF: UITextField!
    
    @IBOutlet weak var workspaceIDTF: UITextField!
    @IBOutlet weak var orchestratorURLTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Settings.useConversation {
            useConversationCell.accessoryType = .checkmark
            useCustomOrchestratorCell.accessoryType = .none
        } else {
            useConversationCell.accessoryType = .none
            useCustomOrchestratorCell.accessoryType = .checkmark
        }

        orchestratorUserTF.text = Settings.orchestratorUsername
        orchestratorPwdTF.text = Settings.orchestratorPassword
        workspaceIDTF.text = Settings.conversationWorkspace
        orchestratorURLTF.text = Settings.customOrchestratorURL
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Settings.orchestratorUsername = orchestratorUserTF.text!
        Settings.orchestratorPassword = orchestratorPwdTF.text!
        Settings.conversationWorkspace = workspaceIDTF.text!
        Settings.customOrchestratorURL = orchestratorURLTF.text!
        
        Settings.saveToDisk()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.item == 0 { // Watson Conversation selected
                Settings.useConversation = true
            } else if indexPath.item == 1 { // Custom orchestrator selected
                Settings.useConversation = false
            }
            tableView.cellForRow(at: IndexPath(item: 1 - indexPath.item, section: 0))?.accessoryType = .none
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            tableView.reloadData()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func switchDidChange() {
        tableView.reloadData()
    }
    
}
