//
//  UIViewCircle.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 2/9/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

open class UIViewCircle : UIView {
//    override public init(frame: CGRect) {
//        super.init(frame: frame)
//        initialize()
//    }
    
//    public convenience init(side:CGFloat) {
//        self.init(frame: CGRect(side:side))
//    }
    
//    public convenience init(radius:CGFloat) {
//        self.init(frame: CGRect(side:radius*2))
//    }
    
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    func initialize() {
        self.layer.cornerRadius = min(frame.size.width,frame.size.height)/2
    }
    
    static public func create(frame: CGRect) -> UIViewCircle {
        let r = UIViewCircle.init(frame: frame)
        r.initialize()
        return r
    }
    
    static public func create(side: CGFloat) -> UIViewCircle {
        let r = UIViewCircle.init(frame: CGRect(side:side))
        r.initialize()
        return r
    }
    
    static public func create(radius: CGFloat) -> UIViewCircle {
        let r = UIViewCircle.init(frame: CGRect(side:radius*2))
        r.initialize()
        return r
    }
}

open class UIViewCircleWithCenteredUIView<TYPE : UIView> : UIViewCircle {
    
    public let view:TYPE
    
    public init(side:CGFloat, view:TYPE = TYPE()) {
        self.view = view
        super.init(frame:CGRect(side:side))
        self.addSubview(view)
        view.constrainCenterToSuperview()
    }
    
    public convenience init(radius:CGFloat, view:TYPE = TYPE()) {
        self.init(side:radius*2, view:view)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class UIViewCircleWithUILabel : UIViewCircleWithCenteredUIView<UILabel> {

    public init(side:CGFloat) {
        super.init(side:side, view:UILabel())
    }
    
    public convenience init(radius:CGFloat) {
        self.init(side:radius*2)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

open class UIViewCircleWithUILabelWithInsets : UIViewCircleWithCenteredUIView<UILabelWithInsets> {

    public init(side:CGFloat) {
        super.init(side:side, view:UILabelWithInsets())
    }
    
    public convenience init(radius:CGFloat) {
        self.init(side:radius*2)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

