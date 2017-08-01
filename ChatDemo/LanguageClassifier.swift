//
//  LanguageClassifier.swift
//  PinacoApp
//
//  Created by Marco Aurélio Bigélli Cardoso on 20/01/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

class LanguageClassifier: NSObject {
    
    weak var delegate: LanguageClassifierDelegate?
    private var currentRequest: URLSessionDataTask?
    private var lastContext: [String: Any?] = [:]
    
    public func classify(text: String) {
        delegate?.languageClassifier?(self, didStartClassifying: text)
        currentRequest = RestUtils.conversationRequest(text: text, context: lastContext,
            success: { answer, context in
                self.delegate?.languageClassifier?(self, didFinishClassifying: answer)
                self.lastContext = context
            }, failure: { reason in
                self.delegate?.languageClassifier?(self, errorDidOccur: reason)
            })
    }
    
    public func cancel() {
        currentRequest?.cancel()
    }
}



@objc protocol LanguageClassifierDelegate: class {
    @objc optional func languageClassifier(_ classifier: LanguageClassifier, didStartClassifying text: String)
    @objc optional func languageClassifier(_ classifier: LanguageClassifier, didFinishClassifying result: String)
    @objc optional func languageClassifier(_ classifier: LanguageClassifier, errorDidOccur error: String)
}
