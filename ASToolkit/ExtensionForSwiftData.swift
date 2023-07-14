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
    
    func decoded<T: Decodable>() throws -> T {
        try JSONDecoder().decode(T.self, from: self)
    }
    
    func decoded<T: Decodable>(fallback: T) -> T {
        (try? self.decoded()) ?? fallback
    }
    
    static func encoded<T: Encodable>(_ from: T) throws -> Data {
        try JSONEncoder().encode(from)
    }

    static func create<T>(from value: T) -> Self {
        // https://www.hackingwithswift.com/forums/swift/how-do-i-get-a-uint32-into-a-data/8802
        var value = value
        return Data.init(bytes: &value, count: MemoryLayout<T>.size)
    }
    
    func load<T>() -> T {
        // https://stackoverflow.com/questions/55793040/convert-data-to-uint32-using-extension
        return self.withUnsafeBytes { bytes in
            bytes.load(as: T.self)
        }
    }
    
    func loaded<T>() -> T? {
        // https://stackoverflow.com/questions/55793040/convert-data-to-uint32-using-extension
        return self.withUnsafeBytes { bytes in
            bytes.load(as: T.self)
        }
    }
    

}
