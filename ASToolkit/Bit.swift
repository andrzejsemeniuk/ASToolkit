//
//  Bit.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 9/19/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

// 32

public func bit32(on:Int) -> UInt32 {
    return 0x1 << on
}

public func bit32(off:Int) -> UInt32 {
    return ~(0x1 << off)
}

public func bit32(_ v:UInt32, on:Int) -> UInt32 {
    return v | bit32(on:on)
}

public func bit32(_ v:UInt32, off:Int) -> UInt32 {
    return v & bit32(off:off)
}

public func bit32(_ v:UInt32, on:[Int]) -> UInt32 {
    return on.reduce(v) {
        bit32($0,on:$1)
    }
}

public func bit32(_ v:UInt32, off:[Int]) -> UInt32 {
    return off.reduce(v) {
        bit32($0,off:$1)
    }
}

// 64

public func bit64(on:Int) -> UInt64 {
    return 0x1 << on
}

public func bit64(off:Int) -> UInt64 {
    return ~(0x1 << off)
}

public func bit64(_ v:UInt64, on:Int) -> UInt64 {
    return v | bit64(on:on)
}

public func bit64(_ v:UInt64, off:Int) -> UInt64 {
    return v & bit64(off:off)
}

public func bit64(_ v:UInt64, on:[Int]) -> UInt64 {
    return on.reduce(v) {
        bit64($0,on:$1)
    }
}

public func bit64(_ v:UInt64, off:[Int]) -> UInt64 {
    return off.reduce(v) {
        bit64($0,off:$1)
    }
}
