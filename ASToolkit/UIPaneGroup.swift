//
//  UIPaneGroup.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 5/2/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

//-n elements, crud
//-title
//-insets
//-border style
//-states: enabled/disabled/highlighted

public class UIPaneGroup : UIView {
    
    public var elements     : [UIView] = []
    
    public var title        : UILabel?
    // filled bg rect, clear text
    // filled bg circle, 1 letter symbol text
    // located h center, v top
    // located v center, l/r center, rotated 90
    
//    public var states       : [State] = []
//    public var transitions  : [State:[State]] = [:]
    
    // create
    // add
    // tweak
    // remove
    
    enum LayoutRule {
        case column, row, matrix
    }
    
    private(set) var rule : LayoutRule = .column
    
    public func add(_ view:UIView) {
        // add as child
        // add constraints
    }
    
//    public class func create(column:[UIView], title:UIViewTitle? = nil, border:UIViewBorder? = nil) -> UIPaneGroup {
//        return UIPaneGroup(elements:[column], title:title, border:border, rule:.column)
//    }
//    
//    public class func create(matrix:[[UIView?]], title:UIViewTitle? = nil, border:UIViewBorder? = nil) -> UIPaneGroup {
//        return UIPaneGroup(elements:matrix, title:title, border:border, rule:.matrix)
//    }

}

class UIPaneGroupRow : UIPaneGroup {

//    public class func create(with row:[UIView], title:UIViewTitle? = nil, border:UIViewBorder? = nil) -> UIPaneGroupRow {
//        return UIPaneGroupRow(elements:[row], title:title, border:border, rule:.row)
//    }
    
}

class UIPaneGroupColumn : UIPaneGroup {
    
}

class UIPaneGroupMatrix : UIPaneGroup {
    
}


