//
//  PickerOfColorWithSliders.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 8/16/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

// TODO: TAP ON DISPLAY ADDS COLOR TO STORAGE?
// TODO: PERSIST LAST COLOR SET?

public protocol ProtocolForPickerOfColorWithSlidersComponentStorage {
    
    func add(color:UIColor)
    
}

open class PickerOfColorWithSliders : UIView {

    public var preferenceSliderSetValueAnimationDuration                    : Double                = 0.4
    
    public enum Component {
        
        case colorDisplay           (height:CGFloat, kind:ComponentColorDisplay.Kind)
        
        case sliderRed              (height:CGFloat)
        case sliderGreen            (height:CGFloat)
        case sliderBlue             (height:CGFloat)
        
        case sliderCyan             (height:CGFloat)
        case sliderMagenta          (height:CGFloat)
        case sliderYellow           (height:CGFloat)
        case sliderKey              (height:CGFloat)
        
        case sliderHue              (height:CGFloat)
        case sliderSaturation       (height:CGFloat)
        case sliderBrightness       (height:CGFloat)
        
        case sliderGrayscale        (height:CGFloat)

        case sliderAlpha            (height:CGFloat)
        
        case sliderCustom           (height:CGFloat, color:UIColor, label:NSAttributedString, value0:Float, value1:Float)
        
        case storageDots            (radius:CGFloat, columns:Int, rows:Int, colors:[UIColor])
    }

    open class ComponentColorDisplay : UIView {
        
        public enum Kind {
            case background
            case dot
            case dots
        }

        public var kind             : Kind             = .background {
            didSet {
                self.updateKind()
            }
        }
        
        public var color            : UIColor           = .clear {
            didSet {
                self.updateColor()
            }
        }

        public typealias Handler    = (ComponentColorDisplay)->()
        
        public var handler          : Handler?
        
        private weak var viewDot    : UIViewCircle!
        private var viewDots        : [UIViewCircle]    = []
        private var viewDotsIndex   : Int               = 0
        
        public init(height: CGFloat, kind:Kind = .background) {
            super.init(frame: CGRect(side:height))
            
            // dot
            
            let viewDot = UIViewCircle(side:height)
            self.addSubviewCentered(viewDot)
            viewDot.constrainSizeToFrameSize()
            self.viewDot = viewDot
            
            // dots
            
            self.viewDots = [
                UIViewCircle(side:height),
                UIViewCircle(side:height/2)
            ]
            
            viewDots.forEach {
                self.addSubviewCentered($0)
                $0.constrainSizeToFrameSize()
                $0.backgroundColor = .white
            }
            
            // init
            
            subviews.forEach { $0.isHidden = true }
            
            self.kind = kind
            self.updateKind()
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(ComponentColorDisplay.tapped))
            self.addGestureRecognizer(tap)
         }
        
        func tapped() {
            self.handler?(self)
        }

        public func nextKind() {
            switch kind {
            case .background    : self.kind = .dot
            case .dot           : self.kind = .dots
            case .dots          :
                self.viewDotsIndex += 1
                self.viewDotsIndex %= self.viewDots.count
                if 0 == self.viewDotsIndex {
                    self.kind = .background
                }
            }
        }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func updateKind() {
            subviews.forEach { $0.isHidden = true }
            switch kind {
            case .dot       :
                viewDot.isHidden = false
            case .dots      :
                viewDots.forEach { $0.isHidden = false }
            case .background:
                break
            }
            self.backgroundColor = .clear
            self.updateColor()
        }
        
        private func updateColor() {
            switch kind {
            case .dot           : viewDot.backgroundColor = color
            case .background    : self.backgroundColor = color
            case .dots          : self.viewDots[self.viewDotsIndex].backgroundColor = color
            }
        }
        
    }
    
    open class ComponentStorageDots : UIView, ProtocolForPickerOfColorWithSlidersComponentStorage {
        
        private var buttons : [[UIButtonWithCenteredCircle]] = []
        
        public var rows     = 4
        
        public var columns  = 4
        
        private var heightConstraint : NSLayoutConstraint?
        
        public typealias Handler = ((UIColor)->Void)
        
        public var handler : Handler?
        
        func tapped(_ control:UIControl!) {
            if let button = control as? UIButtonWithCenteredCircle, let color = button.circle(for: .normal).fillColor {
                handler?(UIColor(cgColor:color))
            }
        }
        
        public func set     (radius:CGFloat, colors:[UIColor], handler:Handler? = nil) {
            
            self.handler = handler
            
            let side = radius*2
            
            buttons.forEach {
                $0.forEach {
                    $0.removeTarget(self, action: #selector(ComponentStorageDots.tapped(_:)), for: .touchUpInside)
                    $0.removeFromSuperview()
                }
            }
            
            buttons = []
            
            let capacity = rows * columns
            
            var column  = 0
            var row     = 0
            var index   = 0
            
            var colors  = colors
            
            while colors.count > capacity {
                _ = colors.trim(to: capacity)
            }
            while colors.count < capacity {
                colors.append(.white)
            }
            
            for color in colors {

                if buttons.count <= row {
                    buttons.append([])
                }
                
                let button = UIButtonWithCenteredCircle(frame: CGRect(side:side))
                button.circle(for: .normal).radius = radius
                button.circle(for: .normal).fillColor = color.cgColor
                button.addTarget(self, action: #selector(ComponentStorageDots.tapped(_:)), for: .touchUpInside)

                buttons[row].append(button)
                
                self.addSubview(button)
                
                column += 1
                index += 1
                
                if column == columns {
                    column = 0
                    row += 1
                }
            }
            
            let dx = (UIScreen.main.bounds.width - self.alignmentRectInsets.left - self.alignmentRectInsets.right) / CGFloat(1 + columns)
            let height = CGFloat(1 + rows) * dx + alignmentRectInsets.top + alignmentRectInsets.bottom
            self.translatesAutoresizingMaskIntoConstraints=false
            if let constraint = heightConstraint {
                self.removeConstraint(constraint)
            }
            self.heightConstraint = self.heightAnchor.constraint(equalToConstant: height)
            self.heightConstraint?.isActive=true
            
            self.backgroundColor = UIColor(white:0,alpha:0.1)
            
            setNeedsLayout()
        }
        
        public func add     (color:UIColor) {
            let buttons = self.buttons.flatMap { $0 }
            var previous:CGColor?
            for button in buttons {
                let circle = button.circle(for: .normal)
                let next = circle.fillColor ?? UIColor.white.cgColor
                if let previous = previous {
                    circle.fillColor = previous
                }
                previous = next
            }
            if !buttons.isEmpty {
                buttons[0].circle(for: .normal).fillColor = color.cgColor
            }
        }
        
        public func remove  (color:UIColor) {
            
        }
        
        override open func layoutSubviews() {
            
            let dx = (self.frame.width - self.alignmentRectInsets.left - self.alignmentRectInsets.right) / CGFloat(1 + columns)
            let dy = dx
            
            let x0 = CGFloat(self.alignmentRectInsets.left + dx)
            var y  = CGFloat(self.alignmentRectInsets.top + dy)
            
            for row in buttons {
                
                var x = x0
                
                for button in row {
                    button.center = CGPoint(x,y)
                    
                    x += dx
                }
                
                y += dy
            }
            
        }
    }
    
    open class ComponentSlider : UIView {
        
        public weak var title       : UILabelWithInsets!
        public weak var leftView    : UIViewCircleWithUILabel!
        public weak var leftButton  : UIButtonWithCenteredCircle!
        public weak var slider      : UISlider!
        public weak var rightButton : UIButtonWithCenteredCircle!
        public weak var rightView   : UIViewCircleWithUILabel!
        
        public var update           : (ComponentSlider,UIColor,Bool)->() = { _ in }
        public var action           : (Float)->() = { _ in }
        
        public func update          (color:UIColor, animated:Bool) {
            self.update(self,color,animated)
        }
        
        public func build(side:CGFloat, margin:CGFloat = 16) {
            
            self.subviews.forEach { $0.removeFromSuperview() }
            
            self.addSubviews([
                slider,
                leftButton,
                rightButton,
                leftView,
                rightView
                ])
            
            var views : Dictionary<String,UIView> = [
                "self"          : self,
                "leftView"      : leftView,
                "leftButton"    : leftButton,
                "slider"        : slider,
                "rightButton"   : rightButton,
                "rightView"     : rightView
            ]
            
            if let title = title {
                self.insertSubview(title, at:0)
                views["title"] = title
            }
            
            let builder = NSLayoutConstraintsBuilder(views:views)
            
            builder < "H:|-[leftView(\(side))]-[leftButton(\(side))]-[slider(>=8)]-[rightButton(\(side))]-[rightView(\(side))]-|"

            builder < "V:|-(>=\(margin))-[leftView(\(side))]-(\(margin))-|"
            builder < "V:|-(>=\(margin))-[leftButton(\(side))]-(\(margin))-|"
            builder < "V:|-(>=\(margin))-[rightButton(\(side))]-(\(margin))-|"
            builder < "V:|-(>=\(margin))-[rightView(\(side))]-(\(margin))-|"
            builder < "V:|-(>=\(margin))-[slider(\(side))]-(\(margin))-|"

            if let title = title {
                //                builder < "H:|-[title]-|" // THERE IS NO WAY TO X-CENTER A VIEW USING VFL
                title.constrainCenterXToSuperview()
                builder < "V:|[title]-[slider]"
                builder < "V:[self(>=\(side+margin+margin))]"
            }
            else {
                builder < "V:[self(\(side+margin+margin))]"
            }
            
            
            builder.activate()
            
            

        }
        
        public func set(value:Float, withAnimationDuration duration:Double? = nil, withRightViewBackgroundColor color:UIColor? = nil) {
            if let duration = duration {
                slider.setValue(value, withAnimationDuration:duration)
            }
            else {
                slider.setValue(value, animated: false)
            }
            if let color = color {
                rightView.backgroundColor = color
                rightView.setNeedsDisplay()
            }
        }
    }
    
    // MARK: - Data
    
    public var componentSliders     : [ComponentSlider]         = []
    public var componentDisplays    : [ComponentColorDisplay]   = []
    public var componentStorage     : [ProtocolForPickerOfColorWithSlidersComponentStorage]   = []
    
    public private(set) var color   : UIColor                   = .clear
    
    public func set(color:UIColor, animated:Bool) {
        self.color = color
        componentSliders.forEach { $0.update(color:color, animated:animated) }
        componentDisplays.forEach { $0.color = color }
        handler?(color)
    }
    
    // MARK: - Initializers
    
    override public init            (frame:CGRect) {
        super.init(frame:frame)
    }
    
    required public init            (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Components
    
    public func addComponentSliderRed        (side:CGFloat = 32, action:((Int)->Bool)? = nil) -> ComponentSlider {
        let slider = self.addComponentSlider(label: "R" | UIColor.white | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize), color: UIColor(rgb:[1,0,0]), side:side)
        
        slider.update = { [weak self] slider,color,animate in
            guard let `self` = self else { return }
            let RGBA = color.RGBA
            slider.set(value                            : Float(RGBA.red)*slider.slider.maximumValue,
                       withAnimationDuration            : animate ? self.preferenceSliderSetValueAnimationDuration : nil,
                       withRightViewBackgroundColor     : UIColor(rgba:[1,0,0,RGBA.red]))
        }
        
        slider.action = { [weak slider, weak self] value in
            guard let `self` = self else { return }
            guard let `slider` = slider else { return }
            var RGBA = self.color.RGBA
            RGBA.red = CGFloat(value) / CGFloat(slider.slider.maximumValue)
            self.set(color:UIColor(RGBA:RGBA), animated:false)
        }
        
        slider.slider.addTarget(self, action: #selector(PickerOfColorWithSliders.handleSliderEvent(_:)), for: .allEvents)
        
        return slider
    }
    
    public func addComponentSliderGreen      (side:CGFloat = 32, action:((Int)->Bool)? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label: "G" | UIColor.white | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize), color: UIColor(rgb:[0,0.9,0]), side:side)
        
        slider.update = { [weak self] slider,color,animate in
            guard let `self` = self else { return }
            let RGBA = color.RGBA
            slider.set(value                            : Float(RGBA.green)*slider.slider.maximumValue,
                       withAnimationDuration            : animate ? self.preferenceSliderSetValueAnimationDuration : nil,
                       withRightViewBackgroundColor     : UIColor(rgba:[0,0.9,0,RGBA.green]))
        }
        
        slider.action = { [weak slider, weak self] value in
            guard let `self` = self else { return }
            guard let `slider` = slider else { return }
            var RGBA = self.color.RGBA
            RGBA.green = CGFloat(value) / CGFloat(slider.slider.maximumValue)
            self.set(color:UIColor(RGBA:RGBA), animated:false)
        }
        
        slider.slider.addTarget(self, action: #selector(PickerOfColorWithSliders.handleSliderEvent(_:)), for: .allEvents)
        
        return slider
    }
    
    public func addComponentSliderBlue       (side:CGFloat = 32, action:((Int)->Bool)? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label: "B" | UIColor.white | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize), color: UIColor(rgb:[0.4,0.6,1]), side:side)
        
        slider.update = { [weak self] slider,color,animate in
            guard let `self` = self else { return }
            let RGBA = color.RGBA
            slider.set(value                            : Float(RGBA.blue)*slider.slider.maximumValue,
                       withAnimationDuration            : animate ? self.preferenceSliderSetValueAnimationDuration : nil,
                       withRightViewBackgroundColor     : UIColor(rgba:[0.4,0.6,1,RGBA.blue]))
        }
        
        slider.action = { [weak slider, weak self] value in
            guard let `self` = self else { return }
            guard let `slider` = slider else { return }
            var RGBA = self.color.RGBA
            RGBA.blue = CGFloat(value) / CGFloat(slider.slider.maximumValue)
            self.set(color:UIColor(RGBA:RGBA), animated:false)
        }
        
        slider.slider.addTarget(self, action: #selector(PickerOfColorWithSliders.handleSliderEvent(_:)), for: .allEvents)
        
        return slider
    }
    
    public func addComponentSliderAlpha      (side:CGFloat = 32, action:((Int)->Bool)? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label: "A" | UIColor.lightGray | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize), color: UIColor(white:1.0), side:side)
        
        slider.update = { [weak self] slider,color,animate in
            guard let `self` = self else { return }
            let RGBA = color.RGBA
            slider.set(value                            : Float(RGBA.alpha)*slider.slider.maximumValue,
                       withAnimationDuration            : animate ? self.preferenceSliderSetValueAnimationDuration : nil,
                       withRightViewBackgroundColor     : UIColor(white:1.0,alpha:RGBA.alpha))
        }
        
        slider.action = { [weak slider, weak self] value in
            guard let `self` = self else { return }
            guard let `slider` = slider else { return }
            var RGBA = self.color.RGBA
            RGBA.alpha = CGFloat(value) / CGFloat(slider.slider.maximumValue)
            self.set(color:UIColor(RGBA:RGBA), animated:false)
        }
        
        slider.slider.addTarget(self, action: #selector(PickerOfColorWithSliders.handleSliderEvent(_:)), for: .allEvents)
        
        return slider
    }
    
    public func addComponentSliderHue       (side:CGFloat = 32, action:((Int)->Bool)? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label  : "H" | UIColor.lightGray | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                                             title  : "H U E" | UIColor.white | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize - 1),
                                             color  : UIColor(white:0,alpha:0.02),
                                             side   : side)
        
        slider.slider.minimumValue = 0
        slider.slider.maximumValue = 359.999
        
        slider.update = { [weak self] slider,color,animate in
            guard let `self` = self else { return }
            let HSBA = color.HSBA
            slider.set(value                            : Float(HSBA.hue)*slider.slider.maximumValue,
                       withAnimationDuration            : animate ? self.preferenceSliderSetValueAnimationDuration : nil,
                       withRightViewBackgroundColor     : UIColor(hsba:[HSBA.hue,1,1,1]))
        }
        
        slider.action = { [weak slider, weak self] value in
            guard let `self` = self else { return }
            guard let `slider` = slider else { return }
            var HSBA = self.color.HSBA
            HSBA.hue = CGFloat(value) / CGFloat(slider.slider.maximumValue)
            self.set(color:UIColor(HSBA:HSBA), animated:false)
        }
        
        slider.slider.addTarget(self, action: #selector(PickerOfColorWithSliders.handleSliderEvent(_:)), for: .allEvents)
        
        return slider
    }
    
    public func addComponentSliderSaturation    (side:CGFloat = 32, action:((Int)->Bool)? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label  : "S" | UIColor.lightGray | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                                             title  : "S A T U R A T I O N" | UIColor.white | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize - 1),
                                             color  : UIColor(white:0,alpha:0.02),
                                             side   : side)
        
        slider.slider.maximumValue = 1
        slider.slider.isContinuous = true
        
        slider.update = { [weak self] slider,color,animate in
            guard let `self` = self else { return }
            let HSBA = color.HSBA
            slider.set(value                            : Float(HSBA.saturation)*slider.slider.maximumValue,
                       withAnimationDuration            : animate ? self.preferenceSliderSetValueAnimationDuration : nil,
                       withRightViewBackgroundColor     : UIColor(hsba:[HSBA.hue,HSBA.saturation,1,1]))
        }
        
        slider.action = { [weak self] value in
            guard let `self` = self else { return }
            var HSBA = self.color.HSBA
            HSBA.saturation = CGFloat(value)
            self.set(color:UIColor(HSBA:HSBA), animated:false)
        }
        
        slider.slider.addTarget(self, action: #selector(PickerOfColorWithSliders.handleSliderEvent(_:)), for: .allEvents)
        
        return slider
    }
    
    public func addComponentSliderBrightness    (side:CGFloat = 32, action:((Int)->Bool)? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label  : "B" | UIColor.lightGray | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                                             title  : "B R I G H T N E S S" | UIColor.white | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize - 1),
                                             color  : UIColor(white:0,alpha:0.02),
                                             side   : side)
        
        slider.slider.maximumValue = 1
        slider.slider.isContinuous = true
        
        slider.update = { [weak self] slider,color,animate in
            guard let `self` = self else { return }
            let HSBA = color.HSBA
            slider.set(value                            : Float(HSBA.brightness)*slider.slider.maximumValue,
                       withAnimationDuration            : animate ? self.preferenceSliderSetValueAnimationDuration : nil,
                       withRightViewBackgroundColor     : UIColor(hsba:[HSBA.hue,1,HSBA.brightness,1]))
        }
        
        slider.action = { [weak self] value in
            guard let `self` = self else { return }
            var HSBA = self.color.HSBA
            HSBA.brightness = CGFloat(value)
            self.set(color:UIColor(HSBA:HSBA), animated:false)
        }
        
        slider.slider.addTarget(self, action: #selector(PickerOfColorWithSliders.handleSliderEvent(_:)), for: .allEvents)
        
        return slider
    }
    
    public func addComponentSliderCyan          (side:CGFloat = 32, action:((Int)->Bool)? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label: "C" | UIColor.black | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize), color: UIColor.cyan, side:side)
        
        slider.slider.maximumValue = 1
        slider.slider.isContinuous = true
        
        slider.update = { [weak self] slider,color,animate in
            guard let `self` = self else { return }
            let CMYK = color.CMYK
            slider.set(value                            : Float(CMYK.cyan)*slider.slider.maximumValue,
                       withAnimationDuration            : animate ? self.preferenceSliderSetValueAnimationDuration : nil,
                       withRightViewBackgroundColor     : UIColor.cyan.withAlphaComponent(CMYK.cyan))
        }
        
        slider.action = { [weak self] value in
            guard let `self` = self else { return }
            var CMYK = self.color.CMYK
            CMYK.cyan = CGFloat(value).clampedTo01
            self.set(color:UIColor(CMYK:CMYK).withAlphaComponent(self.color.alpha), animated:false)
        }
        
        slider.slider.addTarget(self, action: #selector(PickerOfColorWithSliders.handleSliderEvent(_:)), for: .allEvents)
        
        return slider
    }
    
    public func addComponentSliderMagenta           (side:CGFloat = 32, action:((Int)->Bool)? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label: "M" | UIColor.black | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize), color: UIColor.magenta, side:side)
        
        slider.slider.maximumValue = 1
        slider.slider.isContinuous = true
        
        slider.update = { [weak self] slider,color,animate in
            guard let `self` = self else { return }
            let CMYK = color.CMYK
            slider.set(value                            : Float(CMYK.magenta)*slider.slider.maximumValue,
                       withAnimationDuration            : animate ? self.preferenceSliderSetValueAnimationDuration : nil,
                       withRightViewBackgroundColor     : UIColor.magenta.withAlphaComponent(CMYK.magenta))
        }
        
        slider.action = { [weak self] value in
            guard let `self` = self else { return }
            var CMYK = self.color.CMYK
            CMYK.magenta = CGFloat(value).clampedTo01
            self.set(color:UIColor(CMYK:CMYK).withAlphaComponent(self.color.alpha), animated:false)
        }
        
        slider.slider.addTarget(self, action: #selector(PickerOfColorWithSliders.handleSliderEvent(_:)), for: .allEvents)
        
        return slider
    }
    
    public func addComponentSliderYellow        (side:CGFloat = 32, action:((Int)->Bool)? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label: "Y" | UIColor.black | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize), color: UIColor.yellow, side:side)
        
        slider.slider.maximumValue = 1
        slider.slider.isContinuous = true
        
        slider.update = { [weak self] slider,color,animate in
            guard let `self` = self else { return }
            let CMYK = color.CMYK
            slider.set(value                            : Float(CMYK.yellow)*slider.slider.maximumValue,
                       withAnimationDuration            : animate ? self.preferenceSliderSetValueAnimationDuration : nil,
                       withRightViewBackgroundColor     : UIColor.yellow.withAlphaComponent(CMYK.yellow))
        }
        
        slider.action = { [weak self] value in
            guard let `self` = self else { return }
            var CMYK = self.color.CMYK
            CMYK.yellow = CGFloat(value).clampedTo01
            self.set(color:UIColor(CMYK:CMYK).withAlphaComponent(self.color.alpha), animated:false)
        }
        
        slider.slider.addTarget(self, action: #selector(PickerOfColorWithSliders.handleSliderEvent(_:)), for: .allEvents)
        
        return slider
    }
    
    public func addComponentSliderKey           (side:CGFloat = 32, action:((Int)->Bool)? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label: "K" | UIColor.white | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize), color: UIColor.black, side:side)
        
        slider.slider.maximumValue = 1
        slider.slider.isContinuous = true

        slider.update = { [weak self] slider,color,animate in
            guard let `self` = self else { return }
            let CMYK = color.CMYK
            slider.set(value                            : Float(CMYK.key)*slider.slider.maximumValue,
                       withAnimationDuration            : animate ? self.preferenceSliderSetValueAnimationDuration : nil,
                       withRightViewBackgroundColor     : UIColor.black.withAlphaComponent(CMYK.key))
        }
        
        slider.action = { [weak self] value in
            guard let `self` = self else { return }
            var CMYK = self.color.CMYK
            CMYK.key = CGFloat(value).clampedTo01
            self.set(color:UIColor(CMYK:CMYK).withAlphaComponent(self.color.alpha), animated:false)
        }
        
        slider.slider.addTarget(self, action: #selector(PickerOfColorWithSliders.handleSliderEvent(_:)), for: .allEvents)
        
        return slider
    }
    

    open func addComponentSlider           (label:NSAttributedString, title:NSAttributedString? = nil, color:UIColor, side:CGFloat = 32) -> ComponentSlider {
        
        let GRAY            = UIColor(white:0.9)
        
        let leftView        = UIViewCircleWithUILabel               (side:side)
        let leftButton      = UIButtonWithCenteredCircle            ()
        let slider          = UISlider                              ()
        let rightButton     = UIButtonWithCenteredCircle            ()
        let rightView       = UIViewCircleWithUILabel               (side:side)
        
        slider.minimumValue = 0
        slider.maximumValue = 255
        slider.tintColor    = color
        slider.isContinuous = false
        
        leftView.backgroundColor            = color
        leftView.view.attributedText        = label
        leftView.view.textAlignment         = .center
        
        rightView.backgroundColor           = color

        leftButton.setAttributedTitle("-" | UIColor.white, for: .normal)
        leftButton.circle(for: .normal).radius = side/2
        leftButton.circle(for: .normal).fillColor = GRAY.cgColor

        rightButton.setAttributedTitle("+" | UIColor.white, for: .normal)
        rightButton.circle(for: .normal).radius = side/2
        rightButton.circle(for: .normal).fillColor = GRAY.cgColor
        
        var titleLabel      : UILabelWithInsets?
        
        if let title = title {
            titleLabel      = UILabelWithInsets()
            titleLabel?.textAlignment = .center
            titleLabel?.attributedText = title
            titleLabel?.insets = UIEdgeInsets(top:1,left:4,bottom:1,right:4)
//            titleLabel?.layer.borderColor = UIColor(white:1,alpha:0.5).cgColor
//            titleLabel?.layer.borderWidth = 1
//            titleLabel?.sizeToFit()
            
            titleLabel?.layer.backgroundColor = GRAY.cgColor
        }
        
//        var someObject:AnyObject = "whatever" as AnyObject
//        let interval = someObject.timeIntervalSinceNow
        
        
        let result = ComponentSlider()
        
        if let titleLabel = titleLabel {
            result.title    = titleLabel
        }
        result.leftView     = leftView
        result.leftButton   = leftButton
        result.slider       = slider
        result.rightButton  = rightButton
        result.rightView    = rightView
        
        self.addSubview(result)
        
        result.build(side:side)
        
        return result
    }
    
    func handleSliderEvent(_ control:UIControl) {
        if let uislider = control as? UISlider {
            if let slider = self.componentSliders.find({ $0.slider == uislider }) {
                slider.action(uislider.value)
            }
        }
    }
    
    open func addComponentColorDisplay       (height side:CGFloat = 32, kind:ComponentColorDisplay.Kind) -> ComponentColorDisplay {
        
        let display = ComponentColorDisplay(height:side, kind:kind)
        
        self.addSubview(display)
        
        display.translatesAutoresizingMaskIntoConstraints=false
        display.heightAnchor.constraint(equalToConstant: side).isActive=true
        display.widthAnchor.constraint(equalTo: self.widthAnchor).isActive=true
        display.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive=true
        
        display.color = self.color
        
        if false {
            let views = [UILabel(),UILabel(),UILabel()]
//            let pile = UIViewPileCentered(frame: CGRect(side:32), pile:views.map { $0 as UIView })
            views[0].attributedText = "\u{20dd}" | UIColor.black | UIFont.systemFont(ofSize: 32)
            views[1].attributedText = "\u{20dd}" | UIColor.gray | UIFont.systemFont(ofSize: 24)
            views[2].attributedText = "\u{20dd}" | UIColor.white | UIFont.systemFont(ofSize: 16)
            display.pile(views: views, constrainCenters: true)
        }
        
        return display
    }
    
    
    func addComponentStorageDots(radius:CGFloat, columns:Int, rows:Int, colors:[UIColor]) -> ComponentStorageDots {
        
        let storage = ComponentStorageDots()
        
        self.addSubview(storage)
        
        storage.rows     = rows
        storage.columns  = columns
        storage.set(radius: radius, colors: colors) { [weak self] color in
            self?.set(color:color, animated:true)
        }
        
        storage.translatesAutoresizingMaskIntoConstraints=false
        storage.widthAnchor.constraint(equalTo: self.widthAnchor).isActive=true
        storage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive=true
        
        return storage
    }

    
    
    
    private func build() {
        
        if let first = self.subviews.first {
            let box = UILayoutGuide()
            self.addLayoutGuide(box)
            
            box.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive=true
            box.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive=true
            
            box.topAnchor.constraint(equalTo: first.topAnchor).isActive=true
            box.bottomAnchor.constraint(equalTo: self.subviews.last!.bottomAnchor).isActive=true
            
            self.subviews.adjacent { a,b in
                a.bottomAnchor.constraint(equalTo: b.topAnchor).isActive=true
            }
            
            for subview in self.subviews {
                if subview is ComponentSlider {
                    subview.leftAnchor.constraint(equalTo: self.leftAnchor).isActive=true
                    subview.rightAnchor.constraint(equalTo: self.rightAnchor).isActive=true
                }
            }
        }

        self.componentSliders   = self.subviews.filter { $0 is ComponentSlider }.map { $0 as! ComponentSlider }
        self.componentDisplays  = self.subviews.filter { $0 is ComponentColorDisplay }.map { $0 as! ComponentColorDisplay }
        self.componentStorage   = self.subviews.filter { $0 is ProtocolForPickerOfColorWithSlidersComponentStorage }.map { $0 as! ProtocolForPickerOfColorWithSlidersComponentStorage }

        self.componentDisplays.forEach {
            $0.handler = { [weak self] display in
                guard let `self` = self else { return }
                self.componentStorage.first?.add(color:self.color)
            }
        }
    }
    
    
    /// This handler is called whenever the color changes
    public var handler  : ((UIColor)->())?
    
    
    static public func create           (withComponents components:[Component]) -> PickerOfColorWithSliders {
        let result = PickerOfColorWithSliders()
        
        for component in components {
            switch component {
                
            case .colorDisplay          (let height, let kind) :
                _ = result.addComponentColorDisplay      (height:height,kind:kind)
                
            case .sliderRed             (let height)     : _ = result.addComponentSliderRed         (side:height)
            case .sliderGreen           (let height)     : _ = result.addComponentSliderGreen       (side:height)
            case .sliderBlue            (let height)     : _ = result.addComponentSliderBlue        (side:height)
            case .sliderAlpha           (let height)     : _ = result.addComponentSliderAlpha       (side:height)
            case .sliderHue             (let height)     : _ = result.addComponentSliderHue         (side:height)
            case .sliderSaturation      (let height)     : _ = result.addComponentSliderSaturation  (side:height)
            case .sliderBrightness      (let height)     : _ = result.addComponentSliderBrightness  (side:height)
            case .sliderCyan            (let height)     : _ = result.addComponentSliderCyan        (side:height)
            case .sliderMagenta         (let height)     : _ = result.addComponentSliderMagenta     (side:height)
            case .sliderYellow          (let height)     : _ = result.addComponentSliderYellow      (side:height)
            case .sliderKey             (let height)     : _ = result.addComponentSliderKey         (side:height)
                
            case .storageDots           (let radius, let columns, let rows, let colors) :
                _ = result.addComponentStorageDots(radius:radius, columns:columns, rows:rows, colors:colors)
                
            default: _ = result.addComponentSliderRed(side:16)
                
            }
        }

        result.build()
//        result.addArrangedSubview(StorageOfColor(withOperations:[.add,.remove,.close,.select), columns:5, spacing:4))
        
        return result
    }
}
