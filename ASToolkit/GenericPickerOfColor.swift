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
// TODO: ADD COMPONENT-STORAGE-DOTS CREATION VIA SPACING AND RADIUS // NO COLUMNS // S+R // CURRENTLY: C+R
// TODO: ADD COMPONENT-STORAGE-DOTS CREATION VIA COLUMNS AND SPACING // NO RADIUS // C+S

open class GenericPickerOfColor : UIView {

    public var preferenceSliderSetValueAnimationDuration                    : Double                = 0.4
    
    public enum Operation {
        case copy               // copy color into clipboard
        case paste              // paste color from clipboard
        case store              //
        case spread             // spread color to other indexes
    }
    
    public enum Component {
        
        case operations                     (operations:[Operation])
        
        case colorDisplayDot                (height:CGFloat)
        case colorDisplayFill               (height:CGFloat)
        case colorDisplaySplitDiagonal      (height:CGFloat)
        case colorDisplaySplitVertical      (height:CGFloat, count:Int)
        case colorDisplaySplitHorizontal    (height:CGFloat, count:Int)
        case colorDisplayBackground
        case colorDisplayValueAsHexadecimal
        
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
    
    open class ColorArrayManager {
        public var listenersOfIndex : [(Int)->()]       = []
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
        public var colorIndex       : Int               = 0 {
            didSet {
                listenersOfIndex.forEach { $0(colorIndex) }
            }
        }
        public var colorLimit       : Int               = 0 {
            didSet {
                if colorLimit <= colorIndex {
                    colorIndex = 0
                }
                growIfNecessary(to: colorLimit)
            }
        }
        
        private func growIfNecessary(to:Int) {
            while colors.count <= to {
                colors.append(.black)
            }
        }
        
        public func colorIndexAdvance(withLimit:Int) {
            self.colorIndex += 1
            self.colorIndex %= withLimit
            self.colorIndex %= colorLimit
        }
        
        public func colorSet(_ color:UIColor) {
            growIfNecessary(to: colorIndex)
            self.colors[self.colorIndex] = color
        }
        
        public var color : UIColor {
            growIfNecessary(to: colorIndex)
            return colors[colorIndex]
        }
        
        public func color(at:Int) -> UIColor {
            growIfNecessary(to: 1+at)
            return colors[at]
        }
    }
    
    open class ComponentColorDisplay : UIView {
        
        public let colorArrayManager : ColorArrayManager
        public let colorLimit : Int
        
        private var tap : UIGestureRecognizer?
        
        public init(height: CGFloat, colorLimit:Int, colorArrayManager:ColorArrayManager) {
            
            self.colorLimit = colorLimit
            self.colorArrayManager = colorArrayManager
            
            super.init(frame: CGRect(side:height))
            
            if 1 < colorLimit {
                addTap()
            }
        }
        
        internal func addTap() {
            if self.tap == nil {
                tap = UITapGestureRecognizer(target: self, action: #selector(ComponentColorDisplay.tapped))
                self.addGestureRecognizer(tap!)
            }
        }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        open func tapped() {
            colorArrayManager.colorIndexAdvance(withLimit:colorLimit)
        }
        
        open func updateFromColor() {
            self.setNeedsDisplay()
        }
    }
    
    open class ComponentColorDisplayFill : ComponentColorDisplay {
        
        private weak var view:UIView!
        
        public init(height: CGFloat, colorArrayManager:ColorArrayManager) {
            super.init(height:height, colorLimit:1, colorArrayManager:colorArrayManager)
            let view = UIView()
            self.view = view
            self.addSubview(view)
            view.constrainSizeToSuperview()
            view.constrainCenterToSuperview()
         }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override open func updateFromColor() {
            super.updateFromColor()
            view.backgroundColor = colorArrayManager.color(at: 0)
        }
    }
    
    open class ComponentColorDisplayDot : ComponentColorDisplay {
        
        //        public weak var title       : UILabelWithInsets!
        public weak var viewDot     : UIViewCircle!
        
        public init(height: CGFloat, colorArrayManager:ColorArrayManager) {
            super.init(height:height, colorLimit:1, colorArrayManager:colorArrayManager)
            
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
        
        override open func updateFromColor() {
            super.updateFromColor()
            viewDot.backgroundColor = colorArrayManager.color(at: 0)
        }
    }
    
    open class ComponentColorDisplaySplitDiagonal : ComponentColorDisplay {
        
        private weak var triangle : CAShapeLayer!
        private weak var view : UIView!
        
        public init(height: CGFloat, colorArrayManager:ColorArrayManager) {
            super.init(height:height, colorLimit:2, colorArrayManager:colorArrayManager)
            
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
        override open func updateFromColor() {
            super.updateFromColor()
            view.backgroundColor      = colorArrayManager.color(at:0)
            self.triangle.fillColor   = colorArrayManager.color(at:1).cgColor
        }
    }
    
    open class ComponentColorDisplaySplitVertical : ComponentColorDisplay {
        
        private weak var other  : UIView!
        private weak var view   : UIView!
        
        public init(height: CGFloat, colorArrayManager:ColorArrayManager) {
            super.init(height:height, colorLimit:2, colorArrayManager:colorArrayManager)
            
            let view = UIView()
            self.view = view
            self.addSubview(view)
            view.constrainSizeToSuperview()
            view.constrainCenterToSuperview()
            
            let other = UIView()
            self.other = other
            view.addSubview(other)
            other.translatesAutoresizingMaskIntoConstraints=false
            other.leftAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
            other.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
            other.topAnchor.constraint(equalTo: view.topAnchor).isActive=true
            other.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive=true
        }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override open func updateFromColor() {
            super.updateFromColor()
            view.backgroundColor    = colorArrayManager.color(at:0)
            other.backgroundColor   = colorArrayManager.color(at:1)
        }
    }
    
    open class ComponentColorDisplaySplitHorizontal : ComponentColorDisplay {
        
        private weak var other  : UIView!
        private weak var view   : UIView!
        
        public init(height: CGFloat, colorArrayManager:ColorArrayManager) {
            super.init(height:height, colorLimit:2, colorArrayManager:colorArrayManager)
            
            let view = UIView()
            self.view = view
            self.addSubview(view)
            view.constrainSizeToSuperview()
            view.constrainCenterToSuperview()
            
            let other = UIView()
            self.other = other
            view.addSubview(other)
            other.translatesAutoresizingMaskIntoConstraints=false
            other.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
            other.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
            other.topAnchor.constraint(equalTo: view.centerYAnchor).isActive=true
            other.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive=true
        }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override open func updateFromColor() {
            super.updateFromColor()
            view.backgroundColor    = colorArrayManager.color(at:0)
            other.backgroundColor   = colorArrayManager.color(at:1)
        }
    }
    
    open class ComponentColorDisplayValueAsHexadecimal : ComponentColorDisplay {
        
        public var colorified = true
        
        public let text = {
            return UILabel()
        }()
        
        public init(height: CGFloat, colorArrayManager:ColorArrayManager) {
            super.init(height:height, colorLimit:2, colorArrayManager:colorArrayManager)
            
            self.addSubview(self.text)
            self.text.constrainCenterToSuperview()
            self.text.constrainSizeToSuperview()
            self.text.attributedText = "0x00000000" | .white
            self.text.backgroundColor = UIColor(white:0,alpha:0.1)
            self.text.textAlignment = .center
            self.text.sizeToFit()
            
            super.addTap()
        }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override open func tapped() {
            colorified.flip()
            self.updateFromColor()
        }
        
        override open func updateFromColor() {
            super.updateFromColor()
            let font    = text.font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
            let hex     = colorArrayManager.color.representationOfRGBAasHexadecimal
            if colorified {
                var representation = NSAttributedString.init()
                representation += "0x" | font | UIColor.black
                representation += hex[0] | [
                    NSBackgroundColorAttributeName      : UIColor.red
                    ] | font | UIColor.white
                representation += hex[1] | [
                    NSBackgroundColorAttributeName      : UIColor(hsb:[0.3,1,0.7])
                    ] | font | UIColor.white
                representation += hex[2] | [
                    NSBackgroundColorAttributeName      : UIColor(hsb:[0.61,1,1])
                    ] | font | UIColor.white
                representation += hex[3] | [
                    NSBackgroundColorAttributeName      : UIColor(white:0.6)
                    ] | font | UIColor.white
                self.text.attributedText = representation
            }
            else {
                self.text.attributedText = "0x\(hex.joined())" | UIColor.black | font
            }
        }
    }
    
    open class ComponentOperations : UIStackView {
        
        public let operations   : [Operation]
        
        public struct OperationData {
            public var button   : UIButtonWithCenteredCircle = UIButtonWithCenteredCircle()
            public var label    : UILabelWithInsets = UILabelWithInsets()
            public var function : ()->() = { _ in }
        }
        
        public var data         : [Operation:OperationData] = [:]

        public var durationOfTap            : Double        = 0.3
        public var durationOfLabelDisplay   : Double        = 1.0
        public var delayOfLabelDisplay      : Double        = 1.0
        public var showLabel                : Bool          = true

        required public init(coder aDecoder: NSCoder) {
            // TODO
            self.operations = []
            super.init(coder: aDecoder)
        }

        public init(height: CGFloat, side:CGFloat = 36, operations:[Operation]) {
            self.operations = operations

            // create data based on operations
            
            super.init(frame: CGRect(side:height))
            
            self.distribution   = .equalCentering
            self.axis           = .horizontal
            self.alignment      = .center
            
            // create data based on operations
            
            self.addArrangedSubview(UIView())
            for (index,operation) in operations.enumerated() {
                let data    = OperationData()
                
                switch operation {
                case .copy      :
//                    configure(button:data.button, title:"\u{2335}", side:side, insets: UIEdgeInsets(bottom:1))
                    // 29C9, 2295
                    configure(button:data.button, title:"\u{2295}", side:side, insets: UIEdgeInsets(bottom:-1))
                case .paste     : // 29bf, 29be, 29C8
                    configure(button:data.button, title:"\u{2298}", side:side, insets: UIEdgeInsets(bottom:-1))
//                    data.button.transform = data.button.transform.scaledBy(x: 1, y: -1)
                case .spread    :
                    configure(button:data.button, title:"S", side:side)
                case .store     :
                    configure(button:data.button, title:"\u{2981}", side:side)
                }
                

                data.button.addSubview(data.label)
                data.label.textAlignment = .center
                data.label.insets = UIEdgeInsets(top:1,left:4,bottom:1,right:4)
                data.label.translatesAutoresizingMaskIntoConstraints=false
                data.label.constrainCenterXToSuperview()
                data.label.bottomAnchor.constraint(equalTo: data.button.centerYAnchor, constant:-side/2).isActive=true
                data.label.alpha = 0
                data.label.isHidden = true

                self.data[operation] = data
                
                self.addArrangedSubview(data.button)
                
                data.button.tag = index
            }
            self.addArrangedSubview(UIView())
        }
        
        private func configure(button:UIButtonWithCenteredCircle, title:String, side:CGFloat = 36, insets:UIEdgeInsets = UIEdgeInsets()) {
            let colorFill       = UIColor(white:0.3)
            let colorStroke     = UIColor(white:1,alpha:0.5)
            
            button.frame = CGRect(side:side)
            
            button.circle(for: .normal).fillColor       = colorFill.cgColor
            button.circle(for: .normal).strokeColor     = colorStroke.cgColor
            button.circle(for: .selected).fillColor     = UIColor.red.cgColor
            button.circle(for: .selected).strokeColor   = colorStroke.cgColor
            button.circle(for: .disabled).fillColor     = colorFill.cgColor
            button.circle(for: .disabled).strokeColor   = colorStroke.cgColor
            
            for state in [UIControlState.normal, UIControlState.selected, UIControlState.disabled] {
                button.circle(for: state).radius = side/2.0
                button.circle(for: state).lineWidth = 0.5
            }
            
            button.setAttributedTitle(title | UIColor.white, for: .normal)
            button.setAttributedTitle(title | UIColor.white, for: .selected)
            button.setAttributedTitle(title | UIColor.white, for: .disabled)
            
            button.addTarget(self, action: #selector(ComponentOperations.tapped(_:)), for: .touchUpInside)
            
            button.titleEdgeInsets = insets
        }
        
        open func tapped(_ control:UIButton) {
            if let operation = operations[safe:control.tag] {
                if let selected = data[operation]?.button.isSelected, !selected {
                    
                    if showLabel, let data = data[operation] {
                        data.label.alpha = 1
                        data.label.isHidden = false
                        UIView.animate(withDuration: durationOfLabelDisplay, delay: delayOfLabelDisplay, options: [], animations: {
                            data.label.alpha = 0
                        }) { flag in
                            data.label.isHidden = true
                        }
                    }

                    data[operation]?.button.isSelected=true
                    data[operation]?.function()
                    DispatchQueue.main.asyncAfter(deadline: .now() + durationOfTap) { [weak self] in
                        self?.data[operation]?.button.isSelected=false
                    }
                }
            }
        }
        
        public func title(for:Operation) -> NSAttributedString? {
            return data[`for`]?.label.attributedText
        }
        
        public func button(for:Operation) -> UIButtonWithCenteredCircle? {
            return data[`for`]?.button
        }
        
        public func label(for:Operation) -> UILabelWithInsets? {
            return data[`for`]?.label
        }
        
        public func function(for:Operation) -> (()->())? {
            return data[`for`]?.function
        }
        
        public func set(for:Operation, function:@escaping ()->()) {
            if var data = data[`for`] {
                data.function = function
                self.data[`for`] = data
            }
        }
        

        
    }
    
    open class ComponentStorage : UIView {
        
        open func add     (color:UIColor, unique:Bool) -> Bool {
            return false
        }
        
        open func fill    (colors:[UIColor]) {
        }
        
        open func remove  (color:UIColor) {
        }
        
        open var colors : [UIColor] {
            return []
        }
        
    }
    
    open class ComponentStorageDots : ComponentStorage {
        
        private var buttons : [[UIButtonWithCenteredCircle]] = []
        
        public var rows     = 4
        
        public var columns  = 4
        
        private var heightConstraint : NSLayoutConstraint?
        
        public typealias HandlerForTap = ((UIColor)->Void)
        
        public var handlerForTap : HandlerForTap?
        
        override open var colors : [UIColor] {
            return buttons.flatMap { $0 }.map {
                UIColor.init(cgColor:$0.circle(for: .normal).fillColor ?? UIColor.white.cgColor)
            }
        }
        
        func tapped(_ control:UIControl!) {
            if let button = control as? UIButtonWithCenteredCircle, let color = button.circle(for: .normal).fillColor {
                handlerForTap?(UIColor(cgColor:color))
            }
        }
        
        public func set     (radius:CGFloat, colors:[UIColor], handlerForTap:HandlerForTap? = nil) {
            
            self.handlerForTap = handlerForTap
            
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
        
        override open func add     (color:UIColor, unique:Bool) -> Bool {
            let buttons = self.buttons.flatMap { $0 }
            if unique, let components0 = color.cgColor.components {
                for button in buttons {
                    guard
                        let color1 = button.circle(for: .normal).fillColor,
                        color.cgColor.alpha == color1.alpha,
                        let components1 = color1.components,
                        components0 == components1 else {
                            continue
                    }
                    return false
                }
            }
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
            return true
        }
        
        override open func fill    (colors:[UIColor]) {
            let buttons = self.buttons.flatMap { $0 }
            for i in stride(from:0, to:min(buttons.count,colors.count), by:1) {
                buttons[i].circle(for: .normal).fillColor = colors[i].cgColor
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
    
    open class ComponentStorageHistory : ComponentStorageDots {
    }
    
    open class ComponentStorageDrag : ComponentStorageDots {
    }
    
    open class ComponentSlider : UIView {
        
        public weak var title           : UILabelWithInsets!
        public weak var leftView        : UIViewCircleWithUILabel!
        public weak var leftButton      : UIButtonWithCenteredCircle!
        public weak var slider          : UISlider!
        public weak var rightButton     : UIButtonWithCenteredCircle!
        public weak var rightView       : UIViewCircleWithUILabel!
        
        public var update               : (_ slider:ComponentSlider, _ color:UIColor, _ animate:Bool)->() = { _ in }
        public var action               : (_ value:Float, _ dragging:Bool)->() = { _ in }
        
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
    
    public let colorArrayManager                                       = ColorArrayManager()
    public var componentSliders     : [ComponentSlider]         = []
    public var componentDisplays    : [ComponentColorDisplay]   = []
    public var componentStorage     : [ComponentStorage]        = []
    
    public private(set) var color   : UIColor                   = .white
    
    // MARK: - Initializers
    
    override public init            (frame:CGRect) {
        super.init(frame:frame)
        self.colorArrayManager.listenersOfIndex.append { [weak self] index in
            self?.set(color: self!.colorArrayManager.color, dragging:false, animated: true)
        }
    }
    
    required public init            (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Components
    
    public func addComponentSliderRed        (side:CGFloat = 32, title:NSAttributedString? = nil, action:((Int)->Bool)? = nil) -> ComponentSlider {
        let slider = self.addComponentSlider(label  : "R" | UIColor.white | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                                             title  : title,
                                             color  : .red,
                                             side   : side)
        
        slider.update = { [weak self] slider,color,animate in
            guard let `self` = self else { return }
            let RGBA = color.RGBA
            slider.set(value                            : Float(RGBA.red)*slider.slider.maximumValue,
                       withAnimationDuration            : animate ? self.preferenceSliderSetValueAnimationDuration : nil,
                       withRightViewBackgroundColor     : UIColor(rgba:[1,0,0,RGBA.red]))
        }
        
        slider.action = { [weak slider, weak self] value,dragging in
            guard let `self` = self else { return }
            guard let `slider` = slider else { return }
            var RGBA = self.color.RGBA
            RGBA.red = CGFloat(value) / CGFloat(slider.slider.maximumValue)
            self.set(color:UIColor(RGBA:RGBA), dragging:dragging, animated:false)
        }
        
        slider.actionOnLeftButton = { [weak self] slider in
            guard let `self` = self else { return }
            var RGBA = self.color.RGBA
            RGBA.red += 1.0/255.0
            RGBA.red = RGBA.red.clampedTo01
            self.set(color:UIColor(RGBA:RGBA), dragging:false, animated:false)
        }
        
        slider.actionOnRightButton = { [weak self] slider in
            guard let `self` = self else { return }
            var RGBA = self.color.RGBA
            RGBA.red += 1.0/255.0
            RGBA.red = RGBA.red.clampedTo01
            self.set(color:UIColor(RGBA:RGBA), dragging:false, animated:false)
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
        
        slider.action = { [weak slider, weak self] value,dragging in
            guard let `self` = self else { return }
            guard let `slider` = slider else { return }
            var RGBA = self.color.RGBA
            RGBA.green = CGFloat(value) / CGFloat(slider.slider.maximumValue)
            self.set(color:UIColor(RGBA:RGBA), dragging:dragging, animated:false)
        }
        
        slider.actionOnLeftButton = { [weak self] slider in
            guard let `self` = self else { return }
            var RGBA = self.color.RGBA
            RGBA.green -= 1.0/255.0
            RGBA.green = RGBA.green.clampedTo01
            self.set(color:UIColor(RGBA:RGBA), dragging:false, animated:false)
        }
        
        slider.actionOnRightButton = { [weak self] slider in
            guard let `self` = self else { return }
            var RGBA = self.color.RGBA
            RGBA.green += 1.0/255.0
            RGBA.green = RGBA.green.clampedTo01
            self.set(color:UIColor(RGBA:RGBA), dragging:false, animated:false)
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
        
        slider.action = { [weak slider, weak self] value,dragging in
            guard let `self` = self else { return }
            guard let `slider` = slider else { return }
            var RGBA = self.color.RGBA
            RGBA.blue = CGFloat(value) / CGFloat(slider.slider.maximumValue)
            self.set(color:UIColor(RGBA:RGBA), dragging:dragging, animated:false)
        }
        
        slider.actionOnLeftButton = { [weak self] slider in
            guard let `self` = self else { return }
            var RGBA = self.color.RGBA
            RGBA.blue -= 1.0/255.0
            RGBA.blue = RGBA.blue.clampedTo01
            self.set(color:UIColor(RGBA:RGBA), dragging:false, animated:false)
        }
        
        slider.actionOnRightButton = { [weak self] slider in
            guard let `self` = self else { return }
            var RGBA = self.color.RGBA
            RGBA.blue += 1.0/255.0
            RGBA.blue = RGBA.blue.clampedTo01
            self.set(color:UIColor(RGBA:RGBA), dragging:false, animated:false)
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
        
        slider.action = { [weak slider, weak self] value,dragging in
            guard let `self` = self else { return }
            guard let `slider` = slider else { return }
            var RGBA = self.color.RGBA
            RGBA.alpha = CGFloat(value) / CGFloat(slider.slider.maximumValue)
            self.set(color:UIColor(RGBA:RGBA), dragging:dragging, animated:false)
        }
        
        slider.actionOnLeftButton = { [weak self] slider in
            guard let `self` = self else { return }
            var RGBA = self.color.RGBA
            RGBA.alpha -= 1.0/255.0
            RGBA.alpha = RGBA.alpha.clampedTo01
            self.set(color:UIColor(RGBA:RGBA), dragging:false, animated:false)
        }
        
        slider.actionOnRightButton = { [weak self] slider in
            guard let `self` = self else { return }
            var RGBA = self.color.RGBA
            RGBA.alpha += 1.0/255.0
            RGBA.alpha = RGBA.alpha.clampedTo01
            self.set(color:UIColor(RGBA:RGBA), dragging:false, animated:false)
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
        
        slider.action = { [weak slider, weak self] value,dragging in

            guard let `self` = self else { return }
            guard let `slider` = slider else { return }
            var HSBA = self.color.HSBA
            HSBA.hue = CGFloat(value) / CGFloat(slider.slider.maximumValue)
            self.set(color:UIColor(HSBA:HSBA), dragging:dragging, animated:false)
        }
        
        slider.actionOnLeftButton = { [weak self] slider in
            guard let `self` = self else { return }
            var HSBA = self.color.HSBA
            HSBA.hue -= 1.0/360.0
            HSBA.hue = HSBA.hue.clampedTo01
            self.set(color:UIColor(HSBA:HSBA), dragging:false, animated:false)
        }
        
        slider.actionOnRightButton = { [weak self] slider in
            guard let `self` = self else { return }
            var HSBA = self.color.HSBA
            HSBA.hue += 1.0/360.0
            HSBA.hue = HSBA.hue.clampedTo01
            self.set(color:UIColor(HSBA:HSBA), dragging:false, animated:false)
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
        
        slider.action = { [weak self] value,dragging in
            guard let `self` = self else { return }
            var HSBA = self.color.HSBA
            HSBA.saturation = CGFloat(value)
            self.set(color:UIColor(HSBA:HSBA), dragging:dragging, animated:false)
        }
        
        slider.actionOnLeftButton = { [weak self] slider in
            guard let `self` = self else { return }
            var HSBA = self.color.HSBA
            HSBA.saturation -= 1.0/255.0
            HSBA.saturation = HSBA.saturation.clampedTo01
            self.set(color:UIColor(HSBA:HSBA), dragging:false, animated:false)
        }
        
        slider.actionOnRightButton = { [weak self] slider in
            guard let `self` = self else { return }
            var HSBA = self.color.HSBA
            HSBA.saturation += 1.0/255.0
            HSBA.saturation = HSBA.saturation.clampedTo01
            self.set(color:UIColor(HSBA:HSBA), dragging:false, animated:false)
        }
        
        return slider
    }
    
    public func addComponentSliderBrightness    (side   : CGFloat = 32,
                                                 title  : NSAttributedString? = nil,
                                                 action : ((ComponentSlider)->())? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label  : "B" | UIColor.lightGray | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize - 2),
                                             title  : title,
                                             color  : UIColor(white:0,alpha:0.02),
                                             side   : side)
        
        slider.slider.maximumValue = 1
        slider.slider.isContinuous = true
        
        slider.update = { [weak self] slider,color,animate in
            guard let `self` = self else { return }
            let HSBA = color.HSBA
            slider.set(value                            : Float(HSBA.brightness)*slider.slider.maximumValue,
                       withAnimationDuration            : animate ? self.preferenceSliderSetValueAnimationDuration : nil,
                       withRightViewBackgroundColor     : UIColor(hsba:[HSBA.hue,0,HSBA.brightness,1]))
        }
        
        slider.action = { [weak self, weak slider] value,dragging in
            guard let `self` = self, let slider = slider else { return }
            var HSBA = self.color.HSBA
            HSBA.brightness = CGFloat(value)
            self.set(color:UIColor(HSBA:HSBA), dragging:dragging, animated:false)
            action?(slider)
        }
        
        slider.actionOnLeftButton = { [weak self] slider in
            guard let `self` = self else { return }
            var HSBA = self.color.HSBA
            HSBA.brightness -= 1.0/255.0
            HSBA.brightness = HSBA.brightness.clampedTo01
            self.set(color:UIColor(HSBA:HSBA), dragging:false, animated:false)
            action?(slider)
        }
        
        slider.actionOnRightButton = { [weak self] slider in
            guard let `self` = self else { return }
            var HSBA = self.color.HSBA
            HSBA.brightness += 1.0/255.0
            HSBA.brightness = HSBA.brightness.clampedTo01
            self.set(color:UIColor(HSBA:HSBA), dragging:false, animated:false)
            action?(slider)
        }
        
        return slider
    }
    
    public func addComponentSliderCyan          (side   : CGFloat = 32,
                                                 title  : NSAttributedString? = nil,
                                                 action : ((ComponentSlider)->())? = nil) -> ComponentSlider {
        
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
        
        slider.action = { [weak self] value,dragging in
            guard let `self` = self else { return }
            var CMYK = self.color.CMYK
            CMYK.cyan = CGFloat(value).clampedTo01
            self.set(color:UIColor(CMYK:CMYK).withAlphaComponent(self.color.RGBAalpha), dragging:dragging, animated:false)
            action?(slider)
        }
        
        slider.actionOnLeftButton = { [weak self] slider in
            guard let `self` = self else { return }
            var CMYK = self.color.CMYK
            CMYK.cyan -= 1.0/255.0
            CMYK.cyan = CMYK.cyan.clampedTo01
            self.set(color:UIColor(CMYK:CMYK).withAlphaComponent(self.color.RGBAalpha), dragging:false, animated:false)
            action?(slider)
        }
        
        slider.actionOnRightButton = { [weak self] slider in
            guard let `self` = self else { return }
            var CMYK = self.color.CMYK
            CMYK.cyan += 1.0/255.0
            CMYK.cyan = CMYK.cyan.clampedTo01
            self.set(color:UIColor(CMYK:CMYK).withAlphaComponent(self.color.RGBAalpha), dragging:false, animated:false)
            action?(slider)
        }
        
        return slider
    }
    
    public func addComponentSliderMagenta           (side   : CGFloat = 32,
                                                     title  : NSAttributedString? = nil,
                                                     action : ((ComponentSlider)->())? = nil) -> ComponentSlider {
        
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
        
        slider.action = { [weak self] value,dragging in
            guard let `self` = self else { return }
            var CMYK = self.color.CMYK
            CMYK.magenta = CGFloat(value).clampedTo01
            self.set(color:UIColor(CMYK:CMYK).withAlphaComponent(self.color.RGBAalpha), dragging:dragging, animated:false)
            action?(slider)
        }
        
        slider.actionOnLeftButton = { [weak self] slider in
            guard let `self` = self else { return }
            var CMYK = self.color.CMYK
            CMYK.magenta -= 1.0/255.0
            CMYK.magenta = CMYK.magenta.clampedTo01
            self.set(color:UIColor(CMYK:CMYK).withAlphaComponent(self.color.RGBAalpha), dragging:false, animated:false)
            action?(slider)
        }
        
        slider.actionOnRightButton = { [weak self] slider in
            guard let `self` = self else { return }
            var CMYK = self.color.CMYK
            CMYK.magenta += 1.0/255.0
            CMYK.magenta = CMYK.magenta.clampedTo01
            self.set(color:UIColor(CMYK:CMYK).withAlphaComponent(self.color.RGBAalpha), dragging:false, animated:false)
            action?(slider)
        }
        
        return slider
    }
    
    public func addComponentSliderYellow        (side   : CGFloat = 32,
                                                 title  : NSAttributedString? = nil,
                                                 action : ((ComponentSlider)->())? = nil) -> ComponentSlider {
        
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
        
        slider.action = { [weak self] value,dragging in
            guard let `self` = self else { return }
            var CMYK = self.color.CMYK
            CMYK.yellow = CGFloat(value).clampedTo01
            self.set(color:UIColor(CMYK:CMYK).withAlphaComponent(self.color.RGBAalpha), dragging:dragging, animated:false)
            action?(slider)
        }
        
        slider.actionOnLeftButton = { [weak self] slider in
            guard let `self` = self else { return }
            var CMYK = self.color.CMYK
            CMYK.yellow -= 1.0/255.0
            CMYK.yellow = CMYK.yellow.clampedTo01
            self.set(color:UIColor(CMYK:CMYK).withAlphaComponent(self.color.RGBAalpha), dragging:false, animated:false)
            action?(slider)
        }
        
        slider.actionOnRightButton = { [weak self] slider in
            guard let `self` = self else { return }
            var CMYK = self.color.CMYK
            CMYK.yellow += 1.0/255.0
            CMYK.yellow = CMYK.yellow.clampedTo01
            self.set(color:UIColor(CMYK:CMYK).withAlphaComponent(self.color.RGBAalpha), dragging:false, animated:false)
            action?(slider)
        }
        
        return slider
    }
    
    public func addComponentSliderKey           (side   : CGFloat = 32,
                                                 title  : NSAttributedString? = nil,
                                                 action : ((ComponentSlider)->())? = nil) -> ComponentSlider {
        
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
        
        slider.action = { [weak self] value,dragging in
            guard let `self` = self else { return }
            var CMYK = self.color.CMYK
            CMYK.key = CGFloat(value).clampedTo01
            self.set(color:UIColor(CMYK:CMYK).withAlphaComponent(self.color.RGBAalpha), dragging:dragging, animated:false)
            action?(slider)
        }
        
        slider.actionOnLeftButton = { [weak self] slider in
            guard let `self` = self else { return }
            var CMYK = self.color.CMYK
            CMYK.key -= 1.0/255.0
            CMYK.key = CMYK.key.clampedTo01
            self.set(color:UIColor(CMYK:CMYK).withAlphaComponent(self.color.RGBAalpha), dragging:false, animated:false)
            action?(slider)
        }
        
        slider.actionOnRightButton = { [weak self] slider in
            guard let `self` = self else { return }
            var CMYK = self.color.CMYK
            CMYK.key += 1.0/255.0
            CMYK.key = CMYK.key.clampedTo01
            self.set(color:UIColor(CMYK:CMYK).withAlphaComponent(self.color.RGBAalpha), dragging:false, animated:false)
            action?(slider)
        }
        
        return slider
    }
    
    public func addComponentSliderCustom        (label                  : NSAttributedString,
                                                 side                   : CGFloat = 32,
                                                 title                  : NSAttributedString? = nil,
                                                 color                  : UIColor) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label  : label | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                                             title  : title,
                                             color  : color,
                                             side   : side)
        
        slider.slider.maximumValue = 1
        slider.slider.isContinuous = true
        
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
        slider.isContinuous = true
        
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
        
        result.slider.addTarget(self, action: #selector(GenericPickerOfColor.handleSliderEventDragEnd(_:)), for: [.touchUpInside, .touchUpOutside])
        
        result.slider.addTarget(self, action: #selector(GenericPickerOfColor.handleSliderEventValueChanged(_:)), for: UIControlEvents.touchDragInside)
        
        result.leftButton.addTarget(self, action: #selector(GenericPickerOfColor.handleSliderLeftButtonEvent(_:)), for: .touchDown)
        
        result.rightButton.addTarget(self, action: #selector(GenericPickerOfColor.handleSliderRightButtonEvent(_:)), for: .touchDown)
        
        return result
    }
    
    func handleSliderEventDragEnd(_ control:UIControl) {
        if let uislider = control as? UISlider {
            if let slider = self.componentSliders.find({ $0.slider == uislider }) {
                slider.action(uislider.value,false)
            }
        }
    }
    
    func handleSliderEventValueChanged(_ control:UIControl) {
        if let uislider = control as? UISlider {
            if let slider = self.componentSliders.find({ $0.slider == uislider }) {
                slider.action(uislider.value,true)
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
        
        let display = ComponentColorDisplayFill(height:side, colorArrayManager:colorArrayManager)
        
        self.addSubview(display)
        
        display.translatesAutoresizingMaskIntoConstraints=false
        display.heightAnchor.constraint(equalToConstant: side).isActive=true
        display.widthAnchor.constraint(equalTo: self.widthAnchor).isActive=true
        display.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive=true
        
        display.updateFromColor()
        
        return display
    }
    
    open func addComponentColorDisplayDot     (height side:CGFloat = 32) -> ComponentColorDisplayDot {
        
        let display = ComponentColorDisplayDot(height:side, colorArrayManager:self.colorArrayManager)
        
        self.addSubview(display)
        
        display.translatesAutoresizingMaskIntoConstraints=false
        display.heightAnchor.constraint(equalToConstant: side).isActive=true
        display.widthAnchor.constraint(equalTo: self.widthAnchor).isActive=true
        display.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive=true
        
        display.updateFromColor()
        
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
    
    open func addComponentColorDisplaySplitDiagonal  (height side:CGFloat = 32) -> ComponentColorDisplaySplitDiagonal {
        
        let display = ComponentColorDisplaySplitDiagonal(height:side, colorArrayManager:self.colorArrayManager)
        
        self.addSubview(display)
        
        display.translatesAutoresizingMaskIntoConstraints=false
        display.heightAnchor.constraint(equalToConstant: side).isActive=true
        display.widthAnchor.constraint(equalTo: self.widthAnchor).isActive=true
        display.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive=true
        
        display.updateFromColor()
        
        return display
    }
    
    open func addComponentColorDisplaySplitVertical (height side:CGFloat = 32) -> ComponentColorDisplaySplitVertical {
        
        let display = ComponentColorDisplaySplitVertical(height:side, colorArrayManager:self.colorArrayManager)
        
        self.addSubview(display)
        
        display.translatesAutoresizingMaskIntoConstraints=false
        display.heightAnchor.constraint(equalToConstant: side).isActive=true
        display.widthAnchor.constraint(equalTo: self.widthAnchor).isActive=true
        display.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive=true
        
        display.updateFromColor()
        
        return display
    }
    
    open func addComponentColorDisplaySplitHorizontal (height side:CGFloat = 32) -> ComponentColorDisplaySplitHorizontal {
        
        let display = ComponentColorDisplaySplitHorizontal(height:side, colorArrayManager:self.colorArrayManager)
        
        self.addSubview(display)
        
        display.translatesAutoresizingMaskIntoConstraints=false
        display.heightAnchor.constraint(equalToConstant: side).isActive=true
        display.widthAnchor.constraint(equalTo: self.widthAnchor).isActive=true
        display.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive=true
        
        display.updateFromColor()
        
        return display
    }
    
    open func addComponentColorDisplayValueAsHexadecimal (height side:CGFloat = 32) -> ComponentColorDisplayValueAsHexadecimal {
        
        let display = ComponentColorDisplayValueAsHexadecimal(height:side, colorArrayManager:self.colorArrayManager)
        
        self.addSubview(display)
        
        display.translatesAutoresizingMaskIntoConstraints=false
        display.heightAnchor.constraint(equalToConstant: side).isActive=true
        display.widthAnchor.constraint(equalTo: self.widthAnchor).isActive=true
        display.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive=true
        
        display.updateFromColor()
        
        return display
    }
    
    open func addComponentOperations            (height:CGFloat = 32, side:CGFloat = 36, operations:[Operation]) -> ComponentOperations {
        
        let display = ComponentOperations(height:height, side:side, operations:operations)
        
        self.addSubview(display)
        
        display.translatesAutoresizingMaskIntoConstraints=false
        display.heightAnchor.constraint(equalToConstant: side).isActive=true
        display.widthAnchor.constraint(equalTo: self.widthAnchor).isActive=true
        display.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive=true
        
        return display
    }
    
    open func addComponentStorageDots       (radius:CGFloat, columns:Int, rows:Int, colors:[UIColor]) -> ComponentStorageDots {
        
        let storage = ComponentStorageDots()
        
        self.addSubview(storage)
        
        storage.rows     = rows
        storage.columns  = columns
        storage.set(radius: radius, colors: colors) { [weak self] color in
            self?.set(color:color, dragging:false, animated:true)
        }
        
        storage.translatesAutoresizingMaskIntoConstraints=false
        storage.widthAnchor.constraint(equalTo: self.widthAnchor).isActive=true
        storage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive=true
        
        return storage
    }

    open func addComponentStorageHistory    (radius:CGFloat, columns:Int, rows:Int, colors:[UIColor]) -> ComponentStorageHistory {
        
        let storage = ComponentStorageHistory()
        
        self.addSubview(storage)
        
        storage.rows     = rows
        storage.columns  = columns
        storage.set(radius: radius, colors: colors) { [weak self] color in
            self?.set(color:color, dragging:false, animated:true)
        }
        
        storage.translatesAutoresizingMaskIntoConstraints=false
        storage.widthAnchor.constraint(equalTo: self.widthAnchor).isActive=true
        storage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive=true
        
        return storage
    }
    
    open func addComponentStorageDrag       (radius:CGFloat, columns:Int, rows:Int, colors:[UIColor]) -> ComponentStorageDrag {
        
        let storage = ComponentStorageDrag()
        
        self.addSubview(storage)
        
        storage.rows     = rows
        storage.columns  = columns
        storage.set(radius: radius, colors: colors) { [weak self] color in
            self?.set(color:color, dragging:false, animated:true)
        }
        
        storage.translatesAutoresizingMaskIntoConstraints=false
        storage.widthAnchor.constraint(equalTo: self.widthAnchor).isActive=true
        storage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive=true
        
        return storage
    }
    
    
    
    
    open func set(color:UIColor, dragging:Bool, animated:Bool) {
        self.color = color
        self.colorArrayManager.colorSet(color)
        componentSliders.forEach { $0.update(color:color, animated:animated) }
        componentDisplays.forEach { $0.updateFromColor() }
        handlerForColor?(color,dragging,animated)
    }
    
    open func clear(withLastColorArray array:[UIColor] = [.white], lastColorIndex index:Int = 0) {
        self.removeAllSubviews()
        self.removeAllConstraints()
        self.componentSliders = []
        self.componentStorage = []
        self.componentDisplays = []
        self.colorArrayManager.colors = array
        self.colorArrayManager.colorIndex = index
        print("color-array-colors:\(colorArrayManager.colors.map{ $0.arrayOfRGBA })")
        print("color-array-index :\(colorArrayManager.colorIndex)")
        print("color-array-limit :\(colorArrayManager.colorLimit)")
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
        self.componentStorage   = self.subviews.filter { $0 is ComponentStorage }.map { $0 as! ComponentStorage }
        
        // update color array limit to highest limit supported
        self.colorArrayManager.colorLimit = self.componentDisplays.map{ $0.colorLimit }.reduce(0){ max($0,$1) }
        print("updated color-array-index :\(colorArrayManager.colorIndex)")
        print("updated color-array-limit :\(colorArrayManager.colorLimit)")

        self.componentDisplays.forEach { $0.updateFromColor() }
    }
        
    /// This handler is called whenever the color changes
    public var handlerForColor  : ((_ color:UIColor,_ dragging:Bool,_ animated:Bool)->())?
    
    
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
        picker.handlerForColor = { color in
            print("new color\(color)")
        }
        picker.set(color:UIColor(rgb:[0.64,0.13,0.78]), dragging:false, animated:true)
        WINDOW.rootViewController = vc
        WINDOW.makeKeyAndVisible()
    }

}
