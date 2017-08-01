//
//  UIHelper.swift
//  Watson Conversation
//
//  Created by Marco Aurélio Bigélli Cardoso on 26/01/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import UIKit

class UIHelper {
    
    static func simpleAlert(title: String, text: String, owner: UIViewController, buttonText: String = "OK",
                            handler: @escaping (UIAlertAction) -> (Void) = {h in}) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: buttonText, style: .default, handler: handler)
        alert.addAction(defaultAction)
        owner.present(alert, animated: true, completion: nil)
    }
    
    static func confirmAlert(title: String, text: String, owner: UIViewController, okButtonText: String = "OK",
                             okHandler: @escaping (UIAlertAction) -> (Void) = {h in}, cancelButtonText: String = "Cancel",
                             cancelHandler: @escaping (UIAlertAction) -> (Void) = {h in}) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelButtonText, style: .default, handler: cancelHandler)
        alert.addAction(cancelAction)
        let okAction = UIAlertAction(title: okButtonText, style: .destructive, handler: okHandler)
        alert.addAction(okAction)
        owner.present(alert, animated: true, completion: nil)
    }

}
