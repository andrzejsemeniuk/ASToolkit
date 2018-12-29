//
//  ExtensionForGCD.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 12/29/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

public extension DispatchQueue {
    
    public static var ui: DispatchQueue {
        return DispatchQueue.main
    }
    
    public static var background: DispatchQueue {
        return DispatchQueue.global(qos: .background)
    }
    
	public static var utility: DispatchQueue {
		return DispatchQueue.global(qos: .utility)
	}

    public func asyncLater(_ sec:TimeInterval, block:@escaping ()->Void) {
        self.asyncAfter(deadline: .now() + sec, execute: block)
    }
    
}

public typealias Q = DispatchQueue
