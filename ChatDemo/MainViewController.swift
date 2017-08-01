//
//  MainViewController.swift
//  PinacoApp
//
//  Created by Gustavo Vicentini on 12/5/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit


private var myContext = 0
//preload gifs

class MainViewController: UIViewController {
    @IBOutlet weak var watsonImage: UIImageView?
    @IBOutlet weak var speechButton: UIButton?

    fileprivate let wIdle = UIImage.gif(name: "watson_idle")
    fileprivate let wQuestion = UIImage.gif(name: "watson_question")
    fileprivate let wAnswer = UIImage.gif(name: "watson_answer")
    fileprivate let wThink = UIImage.gif(name: "watson_think")
        
    var watson: Watson?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.watsonImage?.image = wIdle
        self.speechButton?.setTitle("Tap to record", for: .normal)
        
        Settings.loadFromDisk()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        watson = Watson()
        watson?.delegate = self
    }
    
    @IBAction func speechButtonTapped(_ sender: AnyObject) {
        if watson?.state == .idle {
            watson?.answer("O que é inteligência")
//            watson?.startListening()
        } else {
            watson?.stop()
        }
    }
    
    private func setUp() {
        
    }
    
}

// MARK: - WatsonDelegate
extension MainViewController: WatsonDelegate {
    func didChangeState(to newState: WatsonState) {
        DispatchQueue.main.async {
            switch newState {
            case .idle:
                self.speechButton?.setTitle("Tap to record", for: .normal)
                self.watsonImage?.image = self.wIdle
            case .listening:
                self.speechButton?.setTitle("Listening...", for: .normal)
                self.watsonImage?.image = self.wQuestion
            case .classifying:
                self.speechButton?.setTitle("Classifying...", for: .normal)
                self.watsonImage?.image = self.wThink
            case .synthesizing:
                self.speechButton?.setTitle("Synthesizing...", for: .normal)
                self.watsonImage?.image = self.wThink
            case .speaking:
                self.speechButton?.setTitle("Speaking...", for: .normal)
                self.watsonImage?.image = self.wAnswer
            }
        }
    }
    
    func didFail(module: String, description: String) {
        UIHelper.simpleAlert(title: module + " error", text: description, owner: self)
    }
}
