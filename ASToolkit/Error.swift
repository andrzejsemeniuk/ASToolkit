//
//  Error.swift
//  AppSharkeeForMac
//
//  Created by andrzej semeniuk on 8/22/23.
//

import Foundation

public enum AnError : Swift.Error {
    case invalidParameter(String)
    case isInvalidState(String)
    case isNil(String)
    case etc(String)
    
    case valueIsNil
    case decoding, encoding
    case notImplemented
    case programmingError

}
