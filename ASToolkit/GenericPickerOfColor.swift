//
//  GenericPickerOfColor.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 8/16/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

// TODO: TAP ON DISPLAY ADDS COLOR TO STORAGE?
// TODO: PERSIST LAST COLOR SET?
// TODO: DISPLAY-DOT/ADD MARGIN
// TODO: DISPLAY-DOT/ADD LABEL
// TODO: OPERATION/ADD
// TODO: REFACTOR INTO A FRAMEWORK

open class GenericPickerOfColor : UIView {

    public var preferenceSliderSetValueAnimationDuration                    : Double                = 0.4
    
    public enum Operation {
        case copy
        case paste
        case swap
        case store
    }
    
    public enum Component {
        
        case operations                     (operations:[Operation])
        
        case colorDisplayDot                (height:CGFloat)
        case colorDisplayFill               (height:CGFloat)
        case colorDisplayDiagonal           (height:CGFloat)
        case colorDisplaySplitVertical      (height:CGFloat, count:Int) // TODO
        case colorDisplaySplitHorizontal    (height:CGFloat, count:Int) // TODO
        case colorDisplayDotOnFill          (height:CGFloat) // TODO
        case colorDisplayValueAsHexadecimal // TODO
        
        case mapHueSaturation               (height:CGFloat,reverse:Bool) // TODO
        case mapHueBrightness               (height:CGFloat,reverse:Bool) // TODO
        case mapSaturationBrightness        (height:CGFloat,reverse:Bool) // TODO
        
        case sliderRed                      (height:CGFloat)
        case sliderGreen                    (height:CGFloat)
        case sliderBlue                     (height:CGFloat)
        
        case sliderCyan                     (height:CGFloat)
        case sliderMagenta                  (height:CGFloat)
        case sliderYellow                   (height:CGFloat)
        case sliderKey                      (height:CGFloat)
        
        case sliderHue                      (height:CGFloat)
        case sliderSaturation               (height:CGFloat)
        case sliderBrightness               (height:CGFloat)
        
        case sliderGrayscale                (height:CGFloat) // TODO

        case sliderAlpha                    (height:CGFloat)
        
        case sliderCustom                   (height:CGFloat, color:UIColor, label:NSAttributedString, value0:Float, value1:Float) // TODO
        
        case storageDots                    (radius:CGFloat, columns:Int, rows:Int, colors:[UIColor])
        case storageFly                     (radius:CGFloat, columns:Int, rows:Int, colors:[UIColor]) // TODO
    }

    let tagForTitle = 5146
    
    open func addTitle(to:UIView, margin:CGFloat, title:NSAttributedString) -> UILabelWithInsets {
        let result = UILabelWithInsets()
        result.attributedText = title
        to.addSubview(result)
        result.constrainCenterXToSuperview()
        result.sizeToFit()
        result.tag = tagForTitle
        result.topAnchor.constraint(equalTo: to.topAnchor, constant: margin)
        return result
    }
    
    open func removeTitle(from:UIView) {
        from.removeSubview(withTag:tagForTitle)
    }
    
    open class ColorArray {
        public var colors           : [UIColor]         = [] {
            didSet {
                if colors.count <= colorIndex {
                    colorIndex = 0
                }
                if colors.count <= colorLimit {
                    colorLimit = colors.count
                }
            }
        }
        public var colorIndex       : Int               = 0
        public var colorLimit       : Int               = 0 {
            didSet {
                if colorLimit <= colorIndex {
                    colorIndex = 0
                }
                growIfNecessary(to: colorLimit)
            }
        }
        
        private func growIfNecessary(to:Int) {
            while colors.count < to {
                colors.append(.clear)
            }
        }
        
        public func colorIndexAdvance(withLimit:Int) {
            self.colorIndex += 1
            self.colorIndex %= withLimit
            self.colorIndex %= colorLimit
        }
        
        public func colorSet(_ color:UIColor) {
            growIfNecessary(to: 1+colorIndex)
            self.colors[self.colorIndex] = color
        }
        
        public var color : UIColor {
            return colors[colorIndex]
        }
        
        public func color(at:Int) -> UIColor {
            growIfNecessary(to: 1+at)
            return colors[at]
        }
    }
    
    open class ComponentColorDisplay : UIView {
        
        public var color            : UIColor           = .clear {
            didSet {
                if colorArray.colorIndex < colorLimit {
                    updateColor()
                }
            }
        }
        
        public let colorArray : ColorArray
        public let colorLimit : Int
        
        public init(height: CGFloat, colorLimit:Int, colorArray:ColorArray) {
            
            self.colorLimit = colorLimit
            self.colorArray = colorArray
            
            super.init(frame: CGRect(side:height))
            
            if 1 < colorLimit {
                let tap = UITapGestureRecognizer(target: self, action: #selector(ComponentColorDisplay.tapped))
                self.addGestureRecognizer(tap)
            }
        }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        open func tapped() {
            colorArray.colorIndexAdvance(withLimit:colorLimit)
        }
        
        open func updateColor() {
            colorArray.colorSet(color)
            self.setNeedsDisplay()
        }
    }
    
    open class ComponentColorDisplayFill : ComponentColorDisplay {
        
        private weak var view:UIView!
        
        public init(height: CGFloat, colorArray:ColorArray) {
            super.init(height:height, colorLimit:1, colorArray:colorArray)
            let view = UIView()
            self.view = view
            self.addSubview(view)
            view.constrainSizeToSuperview()
            view.constrainCenterToSuperview()
         }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override open func updateColor() {
            super.updateColor()
            view.backgroundColor = color
        }
    }
    
    open class ComponentColorDisplayDot : ComponentColorDisplay {
        
        //        public weak var title       : UILabelWithInsets!
        public weak var viewDot     : UIViewCircle!
        
        public init(height: CGFloat, colorArray:ColorArray) {
            super.init(height:height, colorLimit:1, colorArray:colorArray)
            
            let viewDot = UIViewCircle(side:height)
            self.addSubviewCentered(viewDot)
            viewDot.constrainSizeToFrameSize()
            self.viewDot = viewDot
            
            // let title = myslider.addTitle("hello" | .red | .fontGillSans)
            //  title.superview = myslider.superview
            //  myslider.superview=title
            // title.backgroundColor = .black
            // title.insets.left/right = 4
            // title.margin.top/bottom=4
            
            // solution 2: increase top insets by title-height + margin + title-insets
        }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override open func updateColor() {
            super.updateColor()
            viewDot.backgroundColor = color
        }
    }
    
    open class ComponentColorDisplayDiagonal : ComponentColorDisplay {
        
        private weak var triangle : CAShapeLayer!
        private weak var view : UIView!
        
        public init(height: CGFloat, colorArray:ColorArray) {
            super.init(height:height, colorLimit:2, colorArray:colorArray)
            
            let view = UIView()
            self.view = view
            self.addSubview(view)
            view.constrainSizeToSuperview()
            view.constrainCenterToSuperview()

            let triangle = CAShapeLayer()
            self.triangle = triangle
            view.layer.addSublayer(triangle)
        }

        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override open func draw(_ rect: CGRect) {
            let path = CGMutablePath()
            path.move(to: view.bounds.tl)
            path.addLine(to: view.bounds.br)
            path.addLine(to: view.bounds.tr)
            path.addLine(to: view.bounds.tl)
            path.closeSubpath()
            self.triangle.path = path
//            self.backgroundColor        = colors[0]
//            self.triangle.fillColor     = colors[1].cgColor
            super.draw(rect)
        }
        override open func updateColor() {
            super.updateColor()
            view.backgroundColor      = colorArray.color(at:0)
            self.triangle.fillColor   = colorArray.color(at:1).cgColor
        }
    }
    
    open class ComponentStorage : UIView {
        
        open func add     (color:UIColor) {
        }
        
        open func remove  (color:UIColor) {
        }
        
    }
    
    open class ComponentStorageDots : ComponentStorage {
        
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
        
        override open func add     (color:UIColor) {
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
        
        override open func remove  (color:UIColor) {
            
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
        
        public weak var title           : UILabelWithInsets!
        public weak var leftView        : UIViewCircleWithUILabel!
        public weak var leftButton      : UIButtonWithCenteredCircle!
        public weak var slider          : UISlider!
        public weak var rightButton     : UIButtonWithCenteredCircle!
        public weak var rightView       : UIViewCircleWithUILabel!
        
        public var update               : (ComponentSlider,UIColor,Bool)->() = { _ in }
        public var action               : (Float)->() = { _ in }
        
        public var actionOnLeftButton   : (ComponentSlider)->() = { _ in }
        public var actionOnRightButton  : (ComponentSlider)->() = { _ in }
        
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
    
    public let colorArray                                       = ColorArray()
    public var componentSliders     : [ComponentSlider]         = []
    public var componentDisplays    : [ComponentColorDisplay]   = []
    public var componentStorage     : [ComponentStorageDots]    = []
    
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
    
    public func addComponentSliderRed        (side:CGFloat = 32, title:NSAttributedString? = nil, action:((Int)->Bool)? = nil) -> ComponentSlider {
        let slider = self.addComponentSlider(label  : "R" | UIColor.white | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                                             title  : title,
                                             color  : UIColor(rgb:[1,0,0]),
                                             side   : side)
        
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
        
        slider.actionOnLeftButton = { [weak self] slider in
            guard let `self` = self else { return }
            var RGBA = self.color.RGBA
            RGBA.red += 1.0/255.0
            RGBA.red = RGBA.red.clampedTo01
            self.set(color:UIColor(RGBA:RGBA), animated:false)
        }
        
        slider.actionOnRightButton = { [weak self] slider in
            guard let `self` = self else { return }
            var RGBA = self.color.RGBA
            RGBA.red += 1.0/255.0
            RGBA.red = RGBA.red.clampedTo01
            self.set(color:UIColor(RGBA:RGBA), animated:false)
        }
        
        return slider
    }
    
    public func addComponentSliderGreen      (side:CGFloat = 32, title:NSAttributedString? = nil, action:((Int)->Bool)? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label  : "G" | UIColor.white | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                                             title  : title,
                                             color  : UIColor(rgb:[0,0.9,0]),
                                             side   : side)
        
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
        
        slider.actionOnLeftButton = { [weak self] slider in
            guard let `self` = self else { return }
            var RGBA = self.color.RGBA
            RGBA.green -= 1.0/255.0
            RGBA.green = RGBA.green.clampedTo01
            self.set(color:UIColor(RGBA:RGBA), animated:false)
        }
        
        slider.actionOnRightButton = { [weak self] slider in
            guard let `self` = self else { return }
            var RGBA = self.color.RGBA
            RGBA.green += 1.0/255.0
            RGBA.green = RGBA.green.clampedTo01
            self.set(color:UIColor(RGBA:RGBA), animated:false)
        }
        
        return slider
    }
    
    public func addComponentSliderBlue       (side:CGFloat = 32, title:NSAttributedString? = nil, action:((Int)->Bool)? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label  : "B" | UIColor.white | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                                             title  : title,
                                             color  : UIColor(rgb:[0.4,0.6,1]),
                                             side   : side)
        
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
        
        slider.actionOnLeftButton = { [weak self] slider in
            guard let `self` = self else { return }
            var RGBA = self.color.RGBA
            RGBA.blue -= 1.0/255.0
            RGBA.blue = RGBA.blue.clampedTo01
            self.set(color:UIColor(RGBA:RGBA), animated:false)
        }
        
        slider.actionOnRightButton = { [weak self] slider in
            guard let `self` = self else { return }
            var RGBA = self.color.RGBA
            RGBA.blue += 1.0/255.0
            RGBA.blue = RGBA.blue.clampedTo01
            self.set(color:UIColor(RGBA:RGBA), animated:false)
        }
        
        return slider
    }
    
    public func addComponentSliderAlpha      (side:CGFloat = 32, title:NSAttributedString? = nil, action:((Int)->Bool)? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label  : "A" | UIColor.lightGray | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                                             title  : title,
                                             color  : UIColor(white:1.0),
                                             side   : side)
        
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
        
        slider.actionOnLeftButton = { [weak self] slider in
            guard let `self` = self else { return }
            var RGBA = self.color.RGBA
            RGBA.alpha -= 1.0/255.0
            RGBA.alpha = RGBA.alpha.clampedTo01
            self.set(color:UIColor(RGBA:RGBA), animated:false)
        }
        
        slider.actionOnRightButton = { [weak self] slider in
            guard let `self` = self else { return }
            var RGBA = self.color.RGBA
            RGBA.alpha += 1.0/255.0
            RGBA.alpha = RGBA.alpha.clampedTo01
            self.set(color:UIColor(RGBA:RGBA), animated:false)
        }
        
        return slider
    }
    
    public func addComponentSliderHue       (side:CGFloat = 32, title:NSAttributedString? = nil, action:((Int)->Bool)? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label  : "H" | UIColor.lightGray | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize - 2),
                                             title  : title,
//                                             title  : "H U E" | UIColor.white | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize - 1),
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
        
        slider.actionOnLeftButton = { [weak self] slider in
            guard let `self` = self else { return }
            var HSBA = self.color.HSBA
            HSBA.hue -= 1.0/360.0
            HSBA.hue = HSBA.hue.clampedTo01
            self.set(color:UIColor(HSBA:HSBA), animated:false)
        }
        
        slider.actionOnRightButton = { [weak self] slider in
            guard let `self` = self else { return }
            var HSBA = self.color.HSBA
            HSBA.hue += 1.0/360.0
            HSBA.hue = HSBA.hue.clampedTo01
            self.set(color:UIColor(HSBA:HSBA), animated:false)
        }

        return slider
    }
    
    public func addComponentSliderSaturation    (side:CGFloat = 32, title:NSAttributedString? = nil, action:((Int)->Bool)? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label  : "S" | UIColor.lightGray | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize - 2),
                                             title  : title,
//                                             title  : "S A T U R A T I O N" | UIColor.white | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize - 1),
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
        
        slider.actionOnLeftButton = { [weak self] slider in
            guard let `self` = self else { return }
            var HSBA = self.color.HSBA
            HSBA.saturation -= 1.0/255.0
            HSBA.saturation = HSBA.saturation.clampedTo01
            self.set(color:UIColor(HSBA:HSBA), animated:false)
        }
        
        slider.actionOnRightButton = { [weak self] slider in
            guard let `self` = self else { return }
            var HSBA = self.color.HSBA
            HSBA.saturation += 1.0/255.0
            HSBA.saturation = HSBA.saturation.clampedTo01
            self.set(color:UIColor(HSBA:HSBA), animated:false)
        }
        
        return slider
    }
    
    public func addComponentSliderBrightness    (side:CGFloat = 32, title:NSAttributedString? = nil, action:((Int)->Bool)? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label  : "B" | UIColor.lightGray | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize - 2),
                                             title  : title,
//                                             title  : "B R I G H T N E S S" | UIColor.white | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize - 1),
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
        
        slider.actionOnLeftButton = { [weak self] slider in
            guard let `self` = self else { return }
            var HSBA = self.color.HSBA
            HSBA.brightness -= 1.0/255.0
            HSBA.brightness = HSBA.brightness.clampedTo01
            self.set(color:UIColor(HSBA:HSBA), animated:false)
        }
        
        slider.actionOnRightButton = { [weak self] slider in
            guard let `self` = self else { return }
            var HSBA = self.color.HSBA
            HSBA.brightness += 1.0/255.0
            HSBA.brightness = HSBA.brightness.clampedTo01
            self.set(color:UIColor(HSBA:HSBA), animated:false)
        }
        
        return slider
    }
    
    public func addComponentSliderCyan          (side:CGFloat = 32, title:NSAttributedString? = nil, action:((Int)->Bool)? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label  : "C" | UIColor.black | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                                             title  : title,
                                             color  : UIColor.cyan,
                                             side   : side)
        
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
            self.set(color:UIColor(CMYK:CMYK).withAlphaComponent(self.color.RGBAalpha), animated:false)
        }
        
        slider.actionOnLeftButton = { [weak self] slider in
            guard let `self` = self else { return }
            var CMYK = self.color.CMYK
            CMYK.cyan -= 1.0/255.0
            CMYK.cyan = CMYK.cyan.clampedTo01
            self.set(color:UIColor(CMYK:CMYK).withAlphaComponent(self.color.RGBAalpha), animated:false)
        }
        
        slider.actionOnRightButton = { [weak self] slider in
            guard let `self` = self else { return }
            var CMYK = self.color.CMYK
            CMYK.cyan += 1.0/255.0
            CMYK.cyan = CMYK.cyan.clampedTo01
            self.set(color:UIColor(CMYK:CMYK).withAlphaComponent(self.color.RGBAalpha), animated:false)
        }
        
        return slider
    }
    
    public func addComponentSliderMagenta           (side:CGFloat = 32, title:NSAttributedString? = nil, action:((Int)->Bool)? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label  : "M" | UIColor.black | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                                             title  : title,
                                             color  : UIColor.magenta,
                                             side   : side)
        
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
            self.set(color:UIColor(CMYK:CMYK).withAlphaComponent(self.color.RGBAalpha), animated:false)
        }
        
        slider.actionOnLeftButton = { [weak self] slider in
            guard let `self` = self else { return }
            var CMYK = self.color.CMYK
            CMYK.magenta -= 1.0/255.0
            CMYK.magenta = CMYK.magenta.clampedTo01
            self.set(color:UIColor(CMYK:CMYK).withAlphaComponent(self.color.RGBAalpha), animated:false)
        }
        
        slider.actionOnRightButton = { [weak self] slider in
            guard let `self` = self else { return }
            var CMYK = self.color.CMYK
            CMYK.magenta += 1.0/255.0
            CMYK.magenta = CMYK.magenta.clampedTo01
            self.set(color:UIColor(CMYK:CMYK).withAlphaComponent(self.color.RGBAalpha), animated:false)
        }
        
        return slider
    }
    
    public func addComponentSliderYellow        (side:CGFloat = 32, title:NSAttributedString? = nil, action:((Int)->Bool)? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label  : "Y" | UIColor.black | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                                             title  : title,
                                             color  : UIColor.yellow,
                                             side   : side)
        
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
            self.set(color:UIColor(CMYK:CMYK).withAlphaComponent(self.color.RGBAalpha), animated:false)
        }
        
        slider.actionOnLeftButton = { [weak self] slider in
            guard let `self` = self else { return }
            var CMYK = self.color.CMYK
            CMYK.yellow -= 1.0/255.0
            CMYK.yellow = CMYK.yellow.clampedTo01
            self.set(color:UIColor(CMYK:CMYK).withAlphaComponent(self.color.RGBAalpha), animated:false)
        }
        
        slider.actionOnRightButton = { [weak self] slider in
            guard let `self` = self else { return }
            var CMYK = self.color.CMYK
            CMYK.yellow += 1.0/255.0
            CMYK.yellow = CMYK.yellow.clampedTo01
            self.set(color:UIColor(CMYK:CMYK).withAlphaComponent(self.color.RGBAalpha), animated:false)
        }
        
        return slider
    }
    
    public func addComponentSliderKey           (side   : CGFloat = 32,
                                                 title  : NSAttributedString? = nil,
                                                 action : ((Int)->Bool)? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label  : "K" | UIColor.white | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                                             title  : title,
                                             color  : UIColor.black,
                                             side   :side)
        
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
            self.set(color:UIColor(CMYK:CMYK).withAlphaComponent(self.color.RGBAalpha), animated:false)
        }
        
        slider.actionOnLeftButton = { [weak self] slider in
            guard let `self` = self else { return }
            var CMYK = self.color.CMYK
            CMYK.key -= 1.0/255.0
            CMYK.key = CMYK.key.clampedTo01
            self.set(color:UIColor(CMYK:CMYK).withAlphaComponent(self.color.RGBAalpha), animated:false)
        }
        
        slider.actionOnRightButton = { [weak self] slider in
            guard let `self` = self else { return }
            var CMYK = self.color.CMYK
            CMYK.key += 1.0/255.0
            CMYK.key = CMYK.key.clampedTo01
            self.set(color:UIColor(CMYK:CMYK).withAlphaComponent(self.color.RGBAalpha), animated:false)
        }
        
        return slider
    }
    

    open func addComponentSlider           (label       : NSAttributedString,
                                            title       : NSAttributedString? = nil,
                                            color       : UIColor,
                                            side        : CGFloat = 32) -> ComponentSlider {
        
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
        
        var titleLabel : UILabelWithInsets?
        
        if let title = title {
            titleLabel = UILabelWithInsets()
            titleLabel?.textAlignment = .center
            titleLabel?.attributedText = title
            titleLabel?.insets = UIEdgeInsets(top:1,left:4,bottom:1,right:4)
//            titleLabel?.layer.borderColor = UIColor(white:1,alpha:0.5).cgColor
//            titleLabel?.layer.borderWidth = 1
//            titleLabel?.sizeToFit()
            
//            titleLabel?.layer.backgroundColor = GRAY.cgColor
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
        
        result.slider.addTarget(self, action: #selector(GenericPickerOfColor.handleSliderEvent(_:)), for: .allEvents)
        
        result.leftButton.addTarget(self, action: #selector(GenericPickerOfColor.handleSliderLeftButtonEvent(_:)), for: .touchDown)
        
        result.rightButton.addTarget(self, action: #selector(GenericPickerOfColor.handleSliderRightButtonEvent(_:)), for: .touchDown)
        
        return result
    }
    
    func handleSliderEvent(_ control:UIControl) {
        if let uislider = control as? UISlider {
            if let slider = self.componentSliders.find({ $0.slider == uislider }) {
                slider.action(uislider.value)
            }
        }
    }
    
    func handleSliderLeftButtonEvent(_ control:UIControl) {
        if let button = control as? UIButton {
            if let slider = self.componentSliders.find({ $0.leftButton == button }) {
                slider.actionOnLeftButton(slider)
            }
        }
    }
    
    func handleSliderRightButtonEvent(_ control:UIControl) {
        if let button = control as? UIButton {
            if let slider = self.componentSliders.find({ $0.rightButton == button }) {
                slider.actionOnRightButton(slider)
            }
        }
    }
    
    open func addComponentColorDisplayFill    (height side:CGFloat = 32) -> ComponentColorDisplayFill {
        
        let display = ComponentColorDisplayFill(height:side, colorArray:colorArray)
        
        self.addSubview(display)
        
        display.translatesAutoresizingMaskIntoConstraints=false
        display.heightAnchor.constraint(equalToConstant: side).isActive=true
        display.widthAnchor.constraint(equalTo: self.widthAnchor).isActive=true
        display.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive=true
        
        display.color = self.color
        
        return display
    }
    
    open func addComponentColorDisplayDot     (height side:CGFloat = 32) -> ComponentColorDisplayDot {
        
        let display = ComponentColorDisplayDot(height:side, colorArray:self.colorArray)
        
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
    
    open func addComponentColorDisplayDiagonal  (height side:CGFloat = 32) -> ComponentColorDisplayDiagonal {
        
        let display = ComponentColorDisplayDiagonal(height:side, colorArray:self.colorArray)
        
        self.addSubview(display)
        
        display.translatesAutoresizingMaskIntoConstraints=false
        display.heightAnchor.constraint(equalToConstant: side).isActive=true
        display.widthAnchor.constraint(equalTo: self.widthAnchor).isActive=true
        display.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive=true
        
        display.color = self.color
        
        return display
    }
    
    open func addComponentStorageDots(radius:CGFloat, columns:Int, rows:Int, colors:[UIColor]) -> ComponentStorageDots {
        
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

    
    
    
    
    open func clear(withColorArray:[UIColor]? = nil) {
        self.removeAllSubviews()
        self.removeAllConstraints()
        self.componentSliders = []
        self.componentStorage = []
        self.componentDisplays = []
        if let array = withColorArray {
            self.colorArray.colors = array
        }
    }
    
    open func build(margin:CGFloat = 8) {
        
        if let first = self.subviews.first, let last = self.subviews.last {
            
            // tie subviews together
            self.subviews.adjacent { a,b in
                b.topAnchor.constraint(equalTo: a.bottomAnchor, constant:margin).isActive=true
            }
            
            // tie left/right anchors of subviews to picker
            for subview in self.subviews {
                subview.leftAnchor.constraint(equalTo: self.leftAnchor).isActive=true
                subview.rightAnchor.constraint(equalTo: self.rightAnchor).isActive=true
            }
            
            // tie picker top anchor to top subview
            // tie picker bottom anchor to bottom subview
            self.translatesAutoresizingMaskIntoConstraints=false
            first.topAnchor.constraint(equalTo: self.topAnchor).isActive=true
            self.bottomAnchor.constraint(equalTo: last.bottomAnchor).isActive=true
        }

        self.componentSliders   = self.subviews.filter { $0 is ComponentSlider }.map { $0 as! ComponentSlider }
        self.componentDisplays  = self.subviews.filter { $0 is ComponentColorDisplay }.map { $0 as! ComponentColorDisplay }
        self.componentStorage   = self.subviews.filter { $0 is ComponentStorageDots }.map { $0 as! ComponentStorageDots }
        
        // set color array limit
        self.colorArray.colorLimit = self.componentDisplays.map{ $0.colorLimit }.reduce(0){ max($0,$1) }
        
        self.componentDisplays.forEach { $0.updateColor() }
    }
        
    /// This handler is called whenever the color changes
    public var handler  : ((UIColor)->())?
    
    
    static public func create           (withComponents components:[Component]) -> GenericPickerOfColor {
        let result = GenericPickerOfColor()
        
        for component in components {
            switch component {
                
            case .colorDisplayDot        (let height) :
                _ = result.addComponentColorDisplayDot    (height:height)
                
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


func test() {
    
    let WINDOW = UIWindow(frame: UIScreen.main.bounds)
    
    if false {
        let picker = GenericControllerOfPickerOfColor()
        picker.rowHeight = 80
        let colors:[[UIColor]] = [
            [.red,.orange,.yellow],
            [.blue,.green,.aqua],
            [.white],
            [.red,.orange,.yellow],
            [.blue,.green,.aqua],
            [.white,.lightGray,.gray,.darkGray,.black],
            [.red,.orange,.yellow],
            [.blue,.green,.aqua],
            [.white,.lightGray,.gray,.darkGray,.black],
            [.red,.orange,.yellow],
            [.blue,.green,.aqua],
            [.white,.lightGray,.gray,.darkGray,.black],
            [.red,.orange,.yellow],
            [.blue,.green,.aqua],
            [.white,.lightGray,.gray,.darkGray,.black],
            [.red,.orange,.yellow],
            [.blue,.green,.aqua],
            [.white,.lightGray,.gray,.darkGray,.black],
            [.red,.orange,.yellow],
            [.blue,.green,.aqua],
            [.gray],
            ]
        picker.flavor = .matrixOfSolidCircles(selected: .white, colors: colors, diameter: 60, space: 16)
        WINDOW.rootViewController = picker
        WINDOW.makeKeyAndVisible()
    }
    else if false {
        
        let picker = GenericPickerOfColor.create(withComponents: [
            .colorDisplayDot           (height:64),
            //                .sliderRed              (height:16),
            //                .sliderGreen            (height:16),
            //                .sliderBlue             (height:16),
            .sliderAlpha            (height:32),
            .sliderHue              (height:16),
            .sliderSaturation       (height:16),
            .sliderBrightness       (height:16),
            //                .sliderCyan             (height:32),
            //                .sliderMagenta          (height:32),
            //                .sliderYellow           (height:32),
            //                .sliderKey              (height:32),
            .storageDots            (radius:16, columns:6, rows:3, colors:[.white,.gray,.black,.orange,.red,.blue,.green,.yellow])
            ])
        let vc = UIViewController()
        picker.frame = UIScreen.main.bounds
        vc.view = picker
        picker.backgroundColor = UIColor(white:0.95)
        picker.handler = { color in
            print("new color\(color)")
        }
        picker.set(color:UIColor(rgb:[0.64,0.13,0.78]), animated:true)
        WINDOW.rootViewController = vc
        WINDOW.makeKeyAndVisible()
    }

}
