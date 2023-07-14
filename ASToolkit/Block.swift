//
//  Block.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 5/17/17
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

public typealias Block                      = ()->Void
public typealias AsyncBlock                 = () async ->Void
public typealias BlockWithBlock             = (Block)->Void

public typealias Block_B_V                  = ((Bool)->Void)
public typealias BlockBoolToVoid            = Block_B_V
public typealias BlockAcceptingBool         = Block_B_V

public func sleep(interval:TimeInterval = 0.1, loop:()->Bool, success:()->Bool) -> Bool {
	while loop() {
		if success() {
			return true
		}
		Thread.sleep(forTimeInterval: interval)
	}
	return false
}

@discardableResult
public func ignore(report:Bool = true, file:String = #file, line:Int = #line, _ block: () throws -> Void) -> Bool {
	do {
		try block()
		return true
	}
	catch let error {
		if report {
			print("ignore(), error: [\(error)] in \(file):\(line)")
		}
		return false
	}
}

public func perform(after: TimeInterval, _ f: @escaping ()->Void) {
    let _ = Timer.scheduledTimer(withTimeInterval: after, repeats: false, block: { t in
        f()
        t.invalidate()
    })
    
}
