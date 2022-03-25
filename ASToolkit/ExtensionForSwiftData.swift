//
//  ExtensionForSwiftData.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 3/16/22.
//  Copyright © 2022 Andrzej Semeniuk. All rights reserved.
//

import Foundation

public extension Data {
    
    func append(fileURL: URL, withNewLine: Bool = true) throws {
        if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
            defer {
                fileHandle.closeFile()
            }
            fileHandle.seekToEndOfFile()
            fileHandle.write(self)
        }
        else {
            try write(to: fileURL, options: .atomic)
        }
    }
    
    static let empty : Data = .init()
    
    var asString : String? {
        .init(data: self, encoding: .utf8)
    }

}
