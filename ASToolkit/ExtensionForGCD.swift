//
//  ExtensionForGCD.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 12/29/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

public extension DispatchQueue {
    
    static var ui: DispatchQueue {
        return DispatchQueue.main
    }
    
    static var background: DispatchQueue {
        return DispatchQueue.global(qos: .background)
    }
    
	static var utility: DispatchQueue {
		return DispatchQueue.global(qos: .utility)
	}

    func asyncLater(_ sec:TimeInterval, block:@escaping ()->Void) {
        self.asyncAfter(deadline: .now() + sec, execute: block)
    }
    
}

public typealias Q = DispatchQueue

public extension DispatchQueue {
    
    func asyncAfter(_ seconds: TimeInterval, block: @escaping ()->Void) {
        self.asyncAfter(deadline: .now() + seconds, execute: block)
    }
    
}

public func wait(_ block: @escaping Block) {
    DispatchQueue.main.async {
        block()
    }
}

public func now(_ block: @escaping Block) {
    DispatchQueue.main.sync {
        block()
    }
}

public func later(_ block: @escaping Block) {
    DispatchQueue.main.async {
        block()
    }
}

public func after(_ seconds: TimeInterval, _ block: @escaping Block) {
    DispatchQueue.main.asyncAfter(seconds) {
        block()
    }
}

