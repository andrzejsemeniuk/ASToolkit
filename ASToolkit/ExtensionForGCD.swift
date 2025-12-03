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
    
    @inlinable func asyncAfter(_ seconds: TimeInterval, block: @escaping ()->Void) {
        self.asyncAfter(deadline: .now() + seconds, execute: block)
    }
    
}

//@inlinable public func wait(_ block: @escaping Block) {
//    DispatchQueue.main.async {
//        block()
//    }
//}
//
//@inlinable public func now(_ block: @escaping Block) {
//    DispatchQueue.main.sync {
//        block()
//    }
//}
//
//@inlinable public func now(_ block: @escaping () throws -> Void) rethrows {
//    try DispatchQueue.main.sync {
//        try block()
//    }
//}

@inlinable nonisolated public func later(_ block: @escaping @MainActor () -> Void) {
//    DispatchQueue.main.async {
//        block()
//    }
    inUI(block)
}

public func later2(_ block: @escaping @MainActor () -> Void) {
//    DispatchQueue.main.async {
//        DispatchQueue.main.async {
//            block()
//        }
//    }
    inUI {
        inUI(block)
    }

}

@inlinable public func after(_ seconds: TimeInterval, _ block: @escaping @MainActor () -> Void) {
//    DispatchQueue.main.asyncAfter(seconds) {
//        block()
//    }
    
    Task {
        try? await Task.sleep(seconds: seconds)
        inUI {
            block()
        }
    }
}




// MARK: - UI Actor & Helper

@globalActor
public actor UIActor {
    public static let shared = UIActor()
}

@inlinable
public nonisolated func inUI(_ operation: @escaping @MainActor () -> Void) {
    Task { @MainActor in
        operation()
    }
}

@inlinable
public nonisolated func onUI(_ operation: @escaping @MainActor () -> Void) {
    Task { @MainActor in
        operation()
    }
}
