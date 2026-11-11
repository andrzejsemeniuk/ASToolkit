//
//  ExtensionForSwiftArraySlice.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 3/19/20.
//  Copyright © 2020 Andrzej Semeniuk. All rights reserved.
//

import Foundation

public extension ArraySlice {
    
        
    func count(where q: (Element)->Bool) -> Int {
        self.reduce(0, { $0 + (q($1) ? 1 : 0) } )
    }
    
    func all(where q: (Element)->Bool) -> Bool {
        for e in self {
            if !q(e) {
                return false
            }
        }
        return true
    }
    
    func some(where q: (Element)->Bool, count: Int = 1) -> Bool {
        var c = count
        for e in self {
            if q(e) {
                c -= 1
                if c < 1 {
                    return true
                }
            }
        }
        return false
    }
    
    func any(where q: (Element)->Bool) -> Bool {
        return some(where: q, count: 1)
    }

    func most(where q: (Element)->Bool) -> Bool {
        var count = 0
        let half = self.count/2
        for e in self {
            if q(e) {
                count += 1
                if count > half {
                    return true
                }
            }
        }
        return false
    }
    
    func none(where q: (Element)->Bool) -> Bool {
        for e in self {
            if q(e) {
                return false
            }
        }
        return true
    }


}
