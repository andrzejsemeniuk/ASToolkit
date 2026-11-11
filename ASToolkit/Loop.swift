//
//  Loop.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 2/7/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

public func loop(_ count:Int, block:()->()) {
    var i:Int = 0
    let count = 0 < count ? count : 0
    while i < count {
        block()
        i += 1
    }
}

public func loopWithIndex(_ count:Int, block:(Int)->()) {
    var i:Int = 0
    let count = 0 < count ? count : 0
    while i < count {
        block(i)
        i += 1
    }
}

public func loop(upTo count:Int, block:()->(Bool)) {
    var i:Int = 0
    let count = 0 < count ? count : 0
    while i < count {
        if block() {
            i += 1
        }
        else {
            break
        }
    }
}

public func loopWithIndex(upTo count:Int, block:(Int)->(Bool)) {
    var i:Int = 0
    let count = 0 < count ? count : 0
    while i < count {
        if block(i) {
            i += 1
        }
        else {
            break
        }
    }
}
