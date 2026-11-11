//
//  Error.swift
//  AppSharkeeForMac
//
//  Created by andrzej semeniuk on 8/22/23.
//

import Foundation

public enum AnError : Swift.Error {
    case invalidParameter(any StringProtocol)
    case isInvalidState(any StringProtocol)
    case isNil(any StringProtocol)
    case etc(any StringProtocol)
    case missing(any StringProtocol)
    
    case valueIsNil
    case decoding, encoding
    case notImplemented
    case programmingError
    case noValidValuesFound
    case emptyParameter

}
