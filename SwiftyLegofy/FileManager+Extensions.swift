//
//  FileManager+Extensions.swift
//  SwiftyLegofy
//
//  Created by Oleh Zayats on 12/14/17.
//  Copyright © 2017 Oleh Zayats. All rights reserved.
//

import Foundation

extension FileManager {
    class func cleanTemporaryDirectory() {
        let tempFolderPath = NSTemporaryDirectory()
        do {
            let filePaths = try self.default.contentsOfDirectory(atPath: tempFolderPath)
            for filePath in filePaths {
                try self.default.removeItem(atPath: tempFolderPath + filePath)
            }
        } catch let error {
            print("Error cleaning Temporary Directory: \(error)")
        }
    }
}
