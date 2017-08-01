//
//  ResponsiveTextFieldViewController.swift
//  Swift version of: VBResponsiveTextFieldViewController
//  Original code: https://github.com/ttippin84/VBResponsiveTextFieldViewController
//
//  Created by David Sandor on 9/27/14.
//  Copyright (c) 2014 David Sandor. All rights reserved.
//

import Foundation
import UIKit

class ResponsiveTextFieldViewController : UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var kPreferredTextFieldToKeyboardOffset: CGFloat = 60.0
    var keyboardFrame: CGRect = CGRect.null
    var keyboardIsShowing: Bool = false
    weak var activeTextField: UIView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ResponsiveTextFieldViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ResponsiveTextFieldViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        for subview in self.view.subviews {
            if (subview is UITextField) {
                (subview as! UITextField).delegate = self
            } else if (subview is UITextView) {
                (subview as! UITextView).delegate = self
                activeTextField = subview
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.keyboardIsShowing = true
        
        if let info = notification.userInfo {
            self.keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            self.arrangeViewOffsetFromKeyboard()
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.keyboardIsShowing = false
        
        self.returnViewToInitialFrame()
    }
    
    func arrangeViewOffsetFromKeyboard() {
        let theApp: UIApplication = UIApplication.shared
        let windowView: UIView? = theApp.delegate!.window!
        
        let textFieldLowerPoint: CGPoint = CGPoint(x: self.activeTextField!.frame.origin.x, y: self.activeTextField!.frame.origin.y + self.activeTextField!.frame.size.height)
        
        let convertedTextFieldLowerPoint: CGPoint = self.view.convert(textFieldLowerPoint, to: windowView)
        
        let targetTextFieldLowerPoint: CGPoint = CGPoint(x: self.activeTextField!.frame.origin.x, y: self.keyboardFrame.origin.y )
        
        let targetPointOffset: CGFloat = targetTextFieldLowerPoint.y - convertedTextFieldLowerPoint.y
        let adjustedViewFrameCenter: CGPoint = CGPoint(x: self.view.center.x, y: self.view.center.y + targetPointOffset)
        
        UIView.animate(withDuration: 0.2, animations:  {
            self.view.center = adjustedViewFrameCenter
        })
    }
    
    func returnViewToInitialFrame() {
        let initialViewRect: CGRect = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        if (!initialViewRect.equalTo(self.view.frame))
        {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.frame = initialViewRect
            });
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.activeTextField != nil)
        {
            self.activeTextField?.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextControl = nextTextFieldOrButton() {
            if nextControl is UITextField {
                activeTextField = nextControl as? UITextField
                activeTextField?.becomeFirstResponder()
            } else if nextControl is UIButton {
                view.endEditing(true)
                (nextControl as! UIButton).sendActions(for: .touchUpInside)
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField as UIView
        
        if(self.keyboardIsShowing)
        {
            self.arrangeViewOffsetFromKeyboard()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.activeTextField = textView as UIView
        
        if(self.keyboardIsShowing) {
            self.arrangeViewOffsetFromKeyboard()
        }
    }
    
    func nextTextFieldOrButton() -> UIView? {
        var found = false
        for subview in self.view.subviews {
            if found && (subview is UITextField || subview is UIButton) {
                return subview
            }
            if (subview is UITextField) {
                let textField = subview as! UITextField
                if textField == activeTextField! {
                    found = true
                }
            }
        }
        return nil
    }
}
