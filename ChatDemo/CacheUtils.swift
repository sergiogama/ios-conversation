//
//  CacheUtils.swift
//  ChatDemo
//
//  Created by Marco Aurélio Bigélli Cardoso on 26/07/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

class CacheUtils {
    
    private static let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/"
    
    static func read(from path: String) -> Data? {
        let finalPath = documentsPath + path
        let input = FileHandle(forReadingAtPath: finalPath)
        if (input == nil) {
            return nil
        }
        let data = input?.readDataToEndOfFile()
        input?.closeFile()
        return data
    }
    
    static func write(to path: String, data: Data) {
        let finalPath = documentsPath + path
        FileManager.default.createFile(atPath: finalPath, contents: data, attributes: nil)
    }
}
