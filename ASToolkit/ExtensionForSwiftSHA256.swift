//
//  ExtensionForSwiftSHA256.swift
//  AppSharkeeForMac
//
//  Created by andrzej semeniuk on 6/2/23.
//

import Foundation
import CryptoKit

public extension String {

    var sha256hash: String {
            // https://www.hackingwithswift.com/example-code/cryptokit/how-to-calculate-the-sha-hash-of-a-string-or-data-instance
        SHA256.hash(data: self.asData).compactMap { String(format: "%02x", $0) }.joined() //.description
    }
    
}
