//
//  UIViewPane.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 5/2/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

public class UIPane : UIView {
    
    public enum State {
        case undefined
        case initialized
        case visible
        case idle
        case begun
        case ended
        case transitioning
        case selected
        case enabled
        case highlighted
        case open
        case opening
        case closed
        case closing
        case showing
        case hiding
    }
    
    public enum Side {
        case top, left, bottom, right
    }
    

    // transition from/to
    // proportion of screen
    // orientation landscape/portrait
    // bound to side

    private(set) var title:UILabelWithInsets!
    
    public func set(title:NSAttributedString, side:Side, margin:CGFloat = 8, background:UIColor = .clear, border:UIPaneBorder.Parameters? = nil) {
        
        if self.title==nil {
            self.title = UILabelWithInsets()
            addSubview(self.title) // TODO: ADD LAYER IN APPROPRIATE Z-INDEX
        }
        
        self.title.isHidden = false
        self.title.backgroundColor = background
        self.title.attributedText = title
        if let border = border {
            self.title.insets = UIEdgeInsets(all: border.insets)
            self.title.layer.borderColor = border.color.cgColor
            self.title.layer.borderWidth = border.thickness
        }
        self.title.sizeToFit()
        self.title.removeAllConstraints()
        self.title.translatesAutoresizingMaskIntoConstraints=false
        switch side {
        case .left:
            self.title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: margin).isActive = true
            self.title.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        case .right:
            self.title.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -margin).isActive = true
            self.title.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        case .top:
            self.title.topAnchor.constraint(equalTo: self.topAnchor, constant: margin).isActive = true
            self.title.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        case .bottom:
            self.title.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margin).isActive = true
            self.title.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        }
    }

    fileprivate func initialize() {
    }
    
    public init() {
        super.init(frame:CGRect.zero)
        initialize()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class UIPaneSide : UIPane {
    
    public enum Transition {
        case slide
    }
    
    public enum TransitionState {
        case opening, open, closing, closed
    }
    
    private(set) var transitionState                    = TransitionState.closed
    private(set) var side               : Side          = .top
    private(set) var length             : CGFloat       = 0
    
    static public func create(on:UIView, side:Side, length:CGFloat) -> UIPaneSide {
        let result = UIPaneSide()
        result.length = length
        result.side = side
        result.isHidden = true
        on.addSubview(result)
        return result
    }
    
    fileprivate var constraintForLength     : NSLayoutConstraint?
    fileprivate var constraintForOpening    : NSLayoutConstraint?
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        configureConstraints()
    }
    
    fileprivate func configureConstraints() {
        guard let superview = self.superview else {
            return
        }
        if false {
            switch side {
            case .top:
                fallthrough
            case .bottom:
                fallthrough
            case .left:
                fallthrough
            case .right:
                self.frame = CGRect(x:superview.frame.maxX,
                                    y:superview.frame.minY,
                                    width:length,
                                    height:superview.frame.height)
            }
            return
        }
        self.removeAllConstraints()
        self.translatesAutoresizingMaskIntoConstraints=false
        let c = NSLayoutConstraintsBuilder()
        switch side {
        case .top:
            c < self.leftAnchor.constraint(equalTo: superview.leftAnchor)
            c < self.rightAnchor.constraint(equalTo: superview.rightAnchor)
            constraintForOpening = self.bottomAnchor.constraint(equalTo: superview.topAnchor)
            constraintForLength = self.heightAnchor.constraint(equalToConstant: length)
        case .bottom:
            c < self.leftAnchor.constraint(equalTo: superview.leftAnchor)
            c < self.rightAnchor.constraint(equalTo: superview.rightAnchor)
            constraintForOpening = self.topAnchor.constraint(equalTo: superview.bottomAnchor)
            constraintForLength = self.heightAnchor.constraint(equalToConstant: length)
        case .left:
            c < self.topAnchor.constraint(equalTo: superview.topAnchor)
            c < self.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            constraintForOpening = self.rightAnchor.constraint(equalTo: superview.leftAnchor)
            constraintForLength = self.widthAnchor.constraint(equalToConstant: length)
        case .right:
            c < self.topAnchor.constraint(equalTo: superview.topAnchor)
            c < self.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            constraintForOpening = self.leftAnchor.constraint(equalTo: superview.rightAnchor)
            constraintForLength = self.widthAnchor.constraint(equalToConstant: length)
        }
        c < constraintForOpening!
        c < constraintForLength!
        c.activate()
        superview.layoutIfNeeded()
    }
    
    public func open(withTransition:Transition = .slide, duration:Double = 0, completion:BlockAcceptingBool? = nil) -> Bool {
        guard let superview = self.superview else {
            return false
        }
        if self.transitionState == .closed {
            self.transitionState = .opening
            self.isHidden = false
            self.layoutIfNeeded()
            print("rect before=\(self.frame)")
            switch self.side {
            case .left, .bottom:
                self.constraintForOpening?.constant = self.length
            case .top, .right:
                self.constraintForOpening?.constant = -self.length
            }
            print("rect before=\(self.frame)")
            UIView.animate(withDuration: duration, animations:superview.layoutIfNeeded, completion: { flag in
                self.transitionState = .open
                completion?(flag)
                print("rect after=\(self.frame)")
            })
            return true
        }
        return false
    }
    
    public func close(withTransition:Transition = .slide, duration:Double = 0, completion:BlockAcceptingBool? = nil) -> Bool {
        guard let superview = self.superview else {
            return false
        }
        if self.transitionState == .open {
            self.transitionState = .closing
            self.layoutIfNeeded()
            self.constraintForOpening?.constant = 0
            UIView.animate(withDuration: duration, animations: superview.layoutIfNeeded, completion: { flag in
                self.transitionState = .closed
                self.isHidden = true
                completion?(flag)
            })
            return true
        }
        return false
    }
    
    public func size(withLength:CGFloat) {
        self.length = 0 < withLength ? withLength : CGFloat(0)
        self.configureConstraints()
    }
}

public class UIPaneSideColor : UIPaneSide {
    // three sliders, 1 value window
}

public class UIPaneSideContrast : UIPaneSide {
    // 1 slider, 1 value window
    // slider=(min,max,notches?,mark,title,value,next?,prev?,border?,insets)
    // operations=create,show,hide,update,read,disable
    // states=init,composed,enabled,visible,editing,idle
}

