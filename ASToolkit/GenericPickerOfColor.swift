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

    public enum Tag : Int {
        case title          = 5146
    }
    
    public struct Configuration {
        
        public var margin                       = CGFloat(0)
        
        public struct Display {
            public var height                   = CGFloat(36)
            
            public struct Value {
                public var margin               = CGFloat(1)
                public var font                 = UIFont.defaultFontForLabel
                
                public struct Colors {
                    public var none             = UIColor.gray
                    public var alpha            = UIColor.white
                    public var red              = UIColor.red
                    public var green            = UIColor(hsb:[0.40,1,0.70])
                    public var blue             = UIColor(hsb:[0.62,1,0.95])
                }
                
                public var background     = Colors()
                public var foreground     = Colors(
                    none    : .white,
                    alpha   : .gray,
                    red     : .white,
                    green   : .white,
                    blue    : .white)
            }
            
            public var value                    = Value()
        }
        
        public var display                      = Display()

        public struct Storage {
            public struct Dot {
                public var radius               = CGFloat(32)
            }
            
            public var dot                      = Dot()
        }
        
        public var storage                      = Storage()
        
        public struct Title {
            public var show                     = true
            public var uppercase                = true
            public var tweened                  = true
            public var color                    = UIColor.black
            public var background               = UIColor.yellow
            public var font                     = UIFont.init(name:"GillSans", size:UIFont.smallSystemFontSize) ?? UIFont.defaultFontForLabel
            public var insets                   = UIEdgeInsets(top:1,left:4,bottom:1,right:4)
            public var marginAbove              = CGFloat(8)
            public var marginBelow              = CGFloat(2)
            
            public func apply                   (to:UILabelWithInsets, withTitle title:String) {
                to.tag              = Tag.title.rawValue
                to.textAlignment    = .center
                var text            = title
                if uppercase {
                    text = text.uppercased()
                }
                if tweened {
                    text = text.tweened(with: " ")
                }
                to.attributedText   = text | color | font
                to.backgroundColor  = background
                to.insets           = insets
            }
        }
        
        public var title                        = Title()
        
        public struct Slider {
            public var margin                   = CGFloat(0)
            public var side                     = CGFloat(32)
        }
        
        public var slider                       = Slider()
        
        public struct Operations {
            public var side                     = CGFloat(41)
            
            public struct ButtonState {
                public var background           = UIColor.black
                public var foreground           = UIColor.white
                public var font                 = (UIFont.defaultFontForLabel + 0)
            }
            
            public var buttonStates             : [UIControlState:ButtonState] = [
                UIControlState.normal           : ButtonState(),
                UIControlState.selected         : ButtonState(),
                UIControlState.disabled         : ButtonState()
            ]

            public init() {
                buttonStates[.selected]?.background = .red
                buttonStates[.disabled]?.background = .gray
            }
        }
        
        public var operations                   = Operations()
        
        public struct Stripes {
            public var show                     = true
            
            public struct Entry {
                public var background           = UIColor.clear
            }
            
            public var odd                      = Entry(background: UIColor(white:0,alpha:0.01))
            public var even                     = Entry(background: UIColor(white:1,alpha:0.01))
        }
        
        public var stripes                      = Stripes()
    }
    
    public var configuration                    = Configuration()
    
    internal class UIViewTray : UIView {
        let titleLabels     : [UILabelWithInsets]
        let view            : UIView
        
        internal static func contentView(of:AnyObject) -> UIView? {
            if let tray = of as? UIViewTray {
                return tray.view
            }
            return nil
        }
        
        internal init(contentView view  : UIView,
                      margins insets    : UIEdgeInsets = UIEdgeInsets(),
                      titleMarginAbove  : CGFloat,
                      titleMarginBelow  : CGFloat,
                      titleLabel        : UILabelWithInsets) {
            self.view = view
            self.titleLabels = [titleLabel]
            
            super.init(frame:.zero)

            self.build(margins: insets,
                       titleMarginAbove: titleMarginAbove,
                       titleMarginBelow: titleMarginBelow,
                       titleLabels: [(titleLabel,view)])
        }
        
        internal init(contentView view  : UIView,
                      margins insets    : UIEdgeInsets = UIEdgeInsets(),
                      titleMarginAbove  : CGFloat,
                      titleMarginBelow  : CGFloat,
                      titleLabels       : [(label:UILabelWithInsets,guide:UIView)]) {
            self.view = view
            self.titleLabels = titleLabels.map { $0.label }
            
            super.init(frame:.zero)
            
            self.build(margins: insets,
                       titleMarginAbove: titleMarginAbove,
                       titleMarginBelow: titleMarginBelow,
                       titleLabels: titleLabels)
        }

        internal init(contentView view  : UIView,
                      margins insets    : UIEdgeInsets = UIEdgeInsets()) {
            self.view = view
            self.titleLabels = []
            
            super.init(frame:.zero)
            
            self.addSubview(view)
            
            self.translatesAutoresizingMaskIntoConstraints=false
            
            view.translatesAutoresizingMaskIntoConstraints=false
            view.constrainToSuperview(withInsets:insets)
        }
        
        private func build(margins insets     : UIEdgeInsets = UIEdgeInsets(),
                           titleMarginAbove   : CGFloat,
                           titleMarginBelow   : CGFloat,
                           titleLabels        : [(label:UILabelWithInsets,guide:UIView)]) {
            
            self.addSubview(view)
            self.translatesAutoresizingMaskIntoConstraints=false
            view.translatesAutoresizingMaskIntoConstraints=false
            
            for titleLabel in titleLabels {
                self.addSubview(titleLabel.label)
                self.sendSubview(toBack: titleLabel.label)
            }
            
            for titleLabel in titleLabels {
                titleLabel.label.translatesAutoresizingMaskIntoConstraints=false
                titleLabel.label.centerXAnchor.constraint(equalTo: titleLabel.guide.centerXAnchor).isActive=true
                titleLabel.label.constrainTopToSuperviewTop(withMargin:titleMarginAbove)
                titleLabel.label.bottomAnchor.constraint(equalTo: titleLabel.guide.topAnchor, constant: -titleMarginBelow).isActive=true
            }
            
            if let first = titleLabels.first {
//                view.topAnchor.constraint(equalTo: first.label.bottomAnchor, constant: insets.top).isActive=true
            }
            else {
//                view.constrainTopToSuperviewTop(withMargin: insets.top)
            }
            view.constrainLeftToSuperviewLeft(withMargin: insets.left)
            view.constrainRightToSuperviewRight(withMargin: insets.right)
            view.constrainBottomToSuperviewBottom(withMargin: insets.bottom)
        }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    internal func addTray(withContentView content:UIView, title:String) -> UIViewTray {
        let result : UIViewTray
        
        let margin = configuration.margin/2
        
        if configuration.title.show {
            let titleLabel = UILabelWithInsets()
            configuration.title.apply(to:titleLabel, withTitle:title)
            result = UIViewTray(contentView      : content,
                                margins          : UIEdgeInsets(bottom:-margin),
                                titleMarginAbove : configuration.title.marginAbove + margin,
                                titleMarginBelow : configuration.title.marginBelow,
                                titleLabel       : titleLabel)
        }
        else {
            result = UIViewTray(contentView : content,
                                margins     : UIEdgeInsets(top:margin, bottom:-margin))
        }
        
        self.addSubview(result)
        
        result.isOpaque = false
        
        result.translatesAutoresizingMaskIntoConstraints=false
        result.widthAnchor.constraint(equalTo: self.widthAnchor).isActive=true
        result.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive=true
        
        return result
    }
    
    internal func addTray(withContentView content:UIView, titles:[(title:String,guide:UIView)]) -> UIViewTray {
        let result : UIViewTray
        
        let margin = configuration.margin/2

        if configuration.title.show {
            var titleLabels : [(UILabelWithInsets,UIView)] = []
            for title in titles {
                let titleLabel = UILabelWithInsets()
                configuration.title.apply(to:titleLabel, withTitle:title.title)
                titleLabels.append((titleLabel,title.guide))
            }
            result = UIViewTray(contentView      : content,
                                margins          : UIEdgeInsets(bottom:-margin),
                                titleMarginAbove : configuration.title.marginAbove + margin,
                                titleMarginBelow : configuration.title.marginBelow,
                                titleLabels      : titleLabels)
            
        }
        else {
            result = UIViewTray(contentView : content,
                                margins     : UIEdgeInsets(top:margin, bottom:-margin))
        }
        
        self.addSubview(result)
        
        result.isOpaque = false
        
        result.translatesAutoresizingMaskIntoConstraints=false
        result.widthAnchor.constraint(equalTo: self.widthAnchor).isActive=true
        result.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive=true
        
        return result
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
        
        public var color : UIColor {
            get {
                growIfNecessary(to: colorIndex)
                return colors[colorIndex]
            }
            set(newValue) {
                growIfNecessary(to: colorIndex)
                self.colors[self.colorIndex] = newValue
            }
        }
        
        public func color(at:Int) -> UIColor {
            growIfNecessary(to: 1+at)
            return colors[at]
        }
    }
    
    open class ComponentDisplay : UIView {
        
        public let colorArrayManager : ColorArrayManager
        public let colorLimit : Int
        
        private var tap : UIGestureRecognizer?
        
        public init(height: CGFloat = 0, colorLimit:Int, colorArrayManager:ColorArrayManager) {
            
            self.colorLimit = colorLimit
            self.colorArrayManager = colorArrayManager
            
            super.init(frame: CGRect(side:height))
            
            self.translatesAutoresizingMaskIntoConstraints=false
            self.heightAnchor.constraint(equalToConstant: height).isActive=true
            
            if 1 < colorLimit {
                addTap()
            }
        }
        
        internal func addTap() {
            if self.tap == nil {
                tap = UITapGestureRecognizer(target: self, action: #selector(ComponentDisplay.tapped))
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
    
    open class ComponentDisplayFill : ComponentDisplay {
        
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
    
    open class ComponentDisplayDot : ComponentDisplay {
        
        public weak var viewFill    : UIView!
        public weak var viewDot     : UIViewCircle!
        
        public init(height: CGFloat, colorArrayManager:ColorArrayManager) {
            super.init(height:height, colorLimit:2, colorArrayManager:colorArrayManager)
            
            let viewFill = UIView()
            self.addSubview(viewFill)
            self.viewFill = viewFill
            viewFill.constrainSizeToSuperview()
            viewFill.constrainCenterToSuperview()
            
            let viewDot = UIViewCircle(side:height*0.666)
            self.addSubviewCentered(viewDot)
            viewDot.constrainSizeToFrameSize()
            self.viewDot = viewDot
        }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override open func updateFromColor() {
            super.updateFromColor()
            viewDot.backgroundColor = colorArrayManager.color(at: 0)
            viewFill.backgroundColor = colorArrayManager.color(at:1)
        }
    }
    
    open class ComponentDisplaySplitDiagonal : ComponentDisplay {
        
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
    
    open class ComponentDisplaySplitVertical : ComponentDisplay {
        
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
    
    open class ComponentDisplaySplitHorizontal : ComponentDisplay {
        
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
    
    open class ComponentDisplayValue : ComponentDisplay {
        
        public var colorified       = true
        
        public var configuration    : Configuration.Display.Value
        
        public typealias Handler    = (UIColor)->()
        
        public var handler          : Handler = { _ in }
        
        public init(height:CGFloat, configuration:Configuration.Display.Value, colorLimit:Int, colorArrayManager:ColorArrayManager, handler:@escaping Handler) {
            
            self.configuration  = configuration
            
            self.handler        = handler
            
            super.init(height: height, colorLimit:colorLimit, colorArrayManager:colorArrayManager)
        }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    open class ComponentDisplayValueRGBAAsHexadecimal : ComponentDisplayValue {
        
        public let text = {
            return UILabel()
        }()
        
        public init(configuration:Configuration.Display.Value, colorArrayManager:ColorArrayManager, handler:@escaping Handler) {
            
            self.text.attributedText    = "0x00000000" | .white
            self.text.backgroundColor   = UIColor(white:0,alpha:0.1)
            self.text.textAlignment     = .center
            self.text.sizeToFit()
            
            super.init(height           : self.text.frame.height + configuration.margin*2,
                       configuration    : configuration,
                       colorLimit       : 1,
                       colorArrayManager: colorArrayManager,
                       handler          : handler)

            self.addSubview(self.text)

            self.text.constrainCenterToSuperview()
            
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
            let font    = configuration.font
            let hex     = colorArrayManager.color.representationOfRGBAasHexadecimal
            if colorified {
                var representation = NSAttributedString.init()
                representation += "0x" | font
                representation += hex[0] | [
                    NSBackgroundColorAttributeName      : configuration.background.red
                    ] | font | configuration.foreground.red
                representation += hex[1] | [
                    NSBackgroundColorAttributeName      : configuration.background.green // UIColor(hsb:[0.3,1,0.7])
                    ] | font | configuration.foreground.green
                representation += hex[2] | [
                    NSBackgroundColorAttributeName      : configuration.background.blue // UIColor(hsb:[0.61,1,1])
                    ] | font | configuration.foreground.blue
                representation += hex[3] | [
                    NSBackgroundColorAttributeName      : configuration.background.alpha // UIColor(white:0.6)
                    ] | font | configuration.foreground.alpha
                self.text.attributedText = representation
            }
            else {
                self.text.backgroundColor = configuration.background.none
                self.text.attributedText = "0x\(hex.joined())" | configuration.foreground.none | font
            }
        }
    }
    
    open class ComponentDisplayValueRGB : ComponentDisplayValue, UITextFieldDelegate {
        
        public let fieldR = {
            return UITextField()
        }()
        public let fieldG = {
            return UITextField()
        }()
        public let fieldB = {
            return UITextField()
        }()

        public let stack = {
            return UIStackView()
        }()
        
        public init(configuration:Configuration.Display.Value, colorArrayManager:ColorArrayManager, handler:@escaping Handler) {
            
            stack.axis          = .horizontal
            stack.distribution  = .equalCentering
            stack.alignment     = .center
            
            stack.addArrangedSubview(UIView())
            for field in [fieldR,fieldG,fieldB] {
                field.text              = "0.000"
                field.textColor         = .white
                field.backgroundColor   = .gray
                field.textAlignment     = .center
                field.sizeToFit()
                stack.addArrangedSubview(field)
            }
            stack.addArrangedSubview(UIView())

            super.init(height           : fieldG.frame.height + configuration.margin*2,
                       configuration    : configuration,
                       colorLimit       : 1,
                       colorArrayManager: colorArrayManager,
                       handler          : handler)

            self.addSubview(stack)
            
            for field in [fieldR,fieldG,fieldB] {
                field.delegate = self
            }
            
            stack.constrainCenterToSuperview()
            stack.constrainWidthToSuperview()

            super.addTap()
        }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override open func tapped() {
            colorified.flip()
            self.updateFromColor()
        }
        
        open func textFieldDidBeginEditing(_ textField: UITextField) {
            textField.becomeFirstResponder()
        }
        
        open func textFieldDidEndEditing(_ textField: UITextField) {
            switch textField {
            case fieldR:
                if let text = textField.text, let value = CGFloat(text.trimmed()) {
                    handler(colorArrayManager.color.withRed(value.clampedTo01))
                }
            case fieldG:
                if let text = textField.text, let value = CGFloat(text.trimmed()) {
                    handler(colorArrayManager.color.withGreen(value.clampedTo01))
                }
            case fieldB:
                if let text = textField.text, let value = CGFloat(text.trimmed()) {
                    handler(colorArrayManager.color.withBlue(value.clampedTo01))
                }
            default: break
            }
        }
        
        override open func updateFromColor() {
            
            super.updateFromColor()
            
            let RGBA = colorArrayManager.color.RGBA
            
            fieldR.font = configuration.font
            fieldG.font = configuration.font
            fieldB.font = configuration.font

            if colorified {
                fieldR.backgroundColor  = configuration.background.red
                fieldG.backgroundColor  = configuration.background.green
                fieldB.backgroundColor  = configuration.background.blue
                fieldR.textColor        = configuration.foreground.red
                fieldG.textColor        = configuration.foreground.green
                fieldB.textColor        = configuration.foreground.blue
            }
            else {
                fieldR.backgroundColor  = configuration.background.none
                fieldG.backgroundColor  = configuration.background.none
                fieldB.backgroundColor  = configuration.background.none
                fieldR.textColor        = configuration.foreground.none
                fieldG.textColor        = configuration.foreground.none
                fieldB.textColor        = configuration.foreground.none
            }
            
            fieldR.text = String.init(format: "%1.3f", RGBA.red)
            fieldG.text = String.init(format: "%1.3f", RGBA.green)
            fieldB.text = String.init(format: "%1.3f", RGBA.blue)
        }
    }
    
    open class ComponentOperations : UIStackView {
        
        public let operations               : [Operation]
        
        public struct OperationData {
            public var button               : UIButtonWithCenteredCircle = UIButtonWithCenteredCircle()
            public var function             : ()->() = { _ in }
        }
        
        public var data                     : [Operation:OperationData] = [:]

        public var durationOfTap            : Double        = 0.3

        required public init(coder aDecoder: NSCoder) {
            // TODO
            self.operations = []
            super.init(coder: aDecoder)
        }

        public init(operations:[Operation]) {
            self.operations = operations

            // create data based on operations
            
            super.init(frame: .zero)
            
            self.distribution   = .equalCentering
            self.axis           = .horizontal
            self.alignment      = .center
        }
        
        public func build(withConfiguration configuration:Configuration.Operations) {
            // create data based on operations
            
            self.addArrangedSubview(UIView())
            for (index,operation) in operations.enumerated() {
                let data = OperationData()
                
                switch operation {
                case .copy      :
                    // 29C9, 2295, 2335, 2228
                    configure(button:data.button, title:"\u{2228}", configuration:configuration, insets: UIEdgeInsets(bottom:-1))
//                    configure(button:data.button, title:"\u{2295}", configuration:configuration, insets: UIEdgeInsets(bottom:-1))
                case .paste     : // 29bf, 29be, 29C8, 2227, 2298
                    configure(button:data.button, title:"\u{2227}", configuration:configuration, insets: UIEdgeInsets(bottom:-1))
//                    configure(button:data.button, title:"\u{229B}", configuration:configuration, insets: UIEdgeInsets(bottom:-1))
                case .spread    :
                    configure(button:data.button, title:"S", configuration:configuration)
                case .store     : // 2981, 2609, 2680, 2299, 22A1
//                    configure(button:data.button, title:"\u{2981}", configuration:configuration)
                    configure(button:data.button, title:"\u{22A1}", configuration:configuration)
                }
                
                self.addArrangedSubview(data.button)
                
                self.data[operation] = data
                
                data.button.tag = index
            }
            self.addArrangedSubview(UIView())
            
            self.heightAnchor.constraint(equalToConstant: configuration.side).isActive=true
        }
        
        private func configure(button:UIButtonWithCenteredCircle, title:String, configuration:Configuration.Operations, insets:UIEdgeInsets = UIEdgeInsets()) {
            let colorFill       = UIColor(white:0.3)
            let colorStroke     = UIColor(white:1,alpha:0.5)
            
            button.frame        = CGRect(side:configuration.side)
            
            button.circle(for: .normal).fillColor       = configuration.buttonStates[.normal]?.background.cgColor
            button.circle(for: .normal).strokeColor     = UIColor.clear.cgColor // configuration.buttonStates[.normal]?.foreground.cgColor
            button.circle(for: .selected).fillColor     = configuration.buttonStates[.selected]?.background.cgColor
            button.circle(for: .selected).strokeColor   = UIColor.clear.cgColor // configuration.buttonStates[.selected]?.foreground.cgColor
            button.circle(for: .disabled).fillColor     = configuration.buttonStates[.disabled]?.background.cgColor
            button.circle(for: .disabled).strokeColor   = UIColor.clear.cgColor // configuration.buttonStates[.disabled]?.foreground.cgColor
            
            for state in [UIControlState.normal, UIControlState.selected, UIControlState.disabled] {
                button.circle(for: state).radius        = configuration.side/2.0
                button.circle(for: state).lineWidth     = 0.5
            }
            
            button.setAttributedTitle(title | configuration.buttonStates[.normal]!.foreground | configuration.buttonStates[.normal]!.font, for: .normal)
            button.setAttributedTitle(title | configuration.buttonStates[.selected]!.foreground | configuration.buttonStates[.selected]!.font, for: .selected)
            button.setAttributedTitle(title | configuration.buttonStates[.disabled]!.foreground | configuration.buttonStates[.disabled]!.font, for: .disabled)
            
            button.titleEdgeInsets = insets
            
            button.addTarget(self, action: #selector(ComponentOperations.tapped(_:)), for: .touchUpInside)
        }
        
        open func tapped(_ control:UIButton) {
            if let operation = operations[safe:control.tag] {
                if let selected = data[operation]?.button.isSelected, !selected {
                    
                    data[operation]?.button.isSelected=true

                    data[operation]?.function()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + durationOfTap) { [weak self] in
                        self?.data[operation]?.button.isSelected=false
                    }
                }
            }
        }
        
        public func button(for:Operation) -> UIButtonWithCenteredCircle? {
            return data[`for`]?.button
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
        
        public var buttons : [UIButtonWithCenteredCircle?] {
            return operations.map { data[$0]?.button }
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
        
        private var radius      : CGFloat = 16
        
        private var dx          : CGFloat {
            return (UIScreen.main.bounds.width - self.alignmentRectInsets.left - self.alignmentRectInsets.right) / CGFloat(1 + columns)
        }
        
        private var height      : CGFloat {
            return CGFloat(1 + rows) * dx - dx/2
        }
        
        func tapped(_ control:UIControl!) {
            if let button = control as? UIButtonWithCenteredCircle, let color = button.circle(for: .normal).fillColor {
                handlerForTap?(UIColor(cgColor:color))
            }
        }
        
        public func set     (radius:CGFloat, colors:[UIColor], handlerForTap:HandlerForTap? = nil) {
            
            self.handlerForTap = handlerForTap
            self.radius = radius
            
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
            
            let dx = self.dx
            let dy = dx
            
            let x0 = CGFloat(self.alignmentRectInsets.left + dx)
            var y  = CGFloat(self.alignmentRectInsets.top + dy * 0.75)
            
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
        
        public weak var leftView        : UIViewCircleWithUILabel!
        public weak var leftButton      : UIButtonWithCenteredCircle!
        public weak var slider          : UISlider!
        public weak var rightButton     : UIButtonWithCenteredCircle!
        public weak var rightView       : UIViewCircleWithUILabel!
        
        public var update               : (_ slider:ComponentSlider, _ color:UIColor, _ animate:Bool)->() = { _ in }
        public var action               : (_ value:Float, _ dragging:Bool)->() = { _ in }
        
        public var actionOnLeftButton   : (ComponentSlider)->() = { _ in }
        public var actionOnRightButton  : (ComponentSlider)->() = { _ in }
        
        public func update              (color:UIColor, animated:Bool) {
            self.update(self,color,animated)
        }
        
        public func build               (side:CGFloat, margin:CGFloat = 0) {
            
            self.subviews.forEach { $0.removeFromSuperview() }
            
            self.addSubviews([
                slider,
                leftButton,
                rightButton,
                leftView,
                rightView
                ])
            
            let views : Dictionary<String,UIView> = [
                "self"          : self,
                "leftView"      : leftView,
                "leftButton"    : leftButton,
                "slider"        : slider,
                "rightButton"   : rightButton,
                "rightView"     : rightView
            ]
            
            let builder = NSLayoutConstraintsBuilder(views:views)
            
            builder < "H:|-[leftView(\(side))]-[leftButton(\(side))]-[slider(>=8)]-[rightButton(\(side))]-[rightView(\(side))]-|"

            builder < "V:|-(>=\(margin))-[leftView(\(side))]-(\(margin))-|"
            builder < "V:|-(>=\(margin))-[leftButton(\(side))]-(\(margin))-|"
            builder < "V:|-(>=\(margin))-[rightButton(\(side))]-(\(margin))-|"
            builder < "V:|-(>=\(margin))-[rightView(\(side))]-(\(margin))-|"
            builder < "V:|-(>=\(margin))-[slider(\(side))]-(\(margin))-|"

//            builder < "V:[self(\(side+marginAbove+marginBelow))]" // not needed
            
            builder.activate()
        }
        
        public func set                 (value:Float, withAnimationDuration duration:Double? = nil, withRightViewBackgroundColor color:UIColor? = nil) {
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
    
    public let colorArrayManager                                = ColorArrayManager()
    public var componentSliders     : [ComponentSlider]         = []
    public var componentDisplays    : [ComponentDisplay]        = []
    public var componentStorage     : [ComponentStorage]        = []
    public var components           : [UIView]                  {
        return subviews.filter { $0 is UIViewTray }.map { ($0 as! UIViewTray).view }
    }
    
    public private(set) var color   : UIColor                   = .white
    
    /// This handler is called whenever the color changes
    public var handlerForColor      : ((_ color:UIColor,_ dragging:Bool,_ animated:Bool)->())?
    
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
    
    public func addTitle(to:UIView, marginAbove:CGFloat = 0, title:NSAttributedString?) -> UILabelWithInsets? {
        
        guard let title = title else { return nil }
        
        let label = UILabelWithInsets()
        label.tag = Tag.title.rawValue
        label.textAlignment = .center
        label.attributedText = title
        label.insets = configuration.title.insets
        
        //            label?.layer.borderColor = UIColor(white:1,alpha:0.5).cgColor
        //            label?.layer.borderWidth = 1
        //            label?.sizeToFit()
        
        //            label?.layer.backgroundColor = GRAY.cgColor
        
        to.addSubview(label)
        to.sendSubview(toBack: label)
        
        label.constrainCenterXToSuperview()
        label.constrainTopToSuperviewTop(withMargin:marginAbove)
        
        return label
    }
    
    public func addComponentSliderRed           (side   : CGFloat = 32,
                                                 title  : String,
                                                 action : ((ComponentSlider)->())? = nil) -> ComponentSlider {
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
            action?(slider)
        }
        
        slider.actionOnLeftButton = { [weak self] slider in
            guard let `self` = self else { return }
            var RGBA = self.color.RGBA
            RGBA.red += 1.0/255.0
            RGBA.red = RGBA.red.clampedTo01
            self.set(color:UIColor(RGBA:RGBA), dragging:false, animated:false)
            action?(slider)
        }
        
        slider.actionOnRightButton = { [weak self] slider in
            guard let `self` = self else { return }
            var RGBA = self.color.RGBA
            RGBA.red += 1.0/255.0
            RGBA.red = RGBA.red.clampedTo01
            self.set(color:UIColor(RGBA:RGBA), dragging:false, animated:false)
            action?(slider)
        }
        
        return slider
    }
    
    public func addComponentSliderGreen         (side   : CGFloat = 32,
                                                 title  : String,
                                                 action : ((ComponentSlider)->())? = nil) -> ComponentSlider {

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
            action?(slider)
        }
        
        slider.actionOnLeftButton = { [weak self] slider in
            guard let `self` = self else { return }
            var RGBA = self.color.RGBA
            RGBA.green -= 1.0/255.0
            RGBA.green = RGBA.green.clampedTo01
            self.set(color:UIColor(RGBA:RGBA), dragging:false, animated:false)
            action?(slider)
        }
        
        slider.actionOnRightButton = { [weak self] slider in
            guard let `self` = self else { return }
            var RGBA = self.color.RGBA
            RGBA.green += 1.0/255.0
            RGBA.green = RGBA.green.clampedTo01
            self.set(color:UIColor(RGBA:RGBA), dragging:false, animated:false)
            action?(slider)
        }
        
        return slider
    }
    
    public func addComponentSliderBlue          (side   : CGFloat = 32,
                                                 title  : String,
                                                 action : ((ComponentSlider)->())? = nil) -> ComponentSlider {

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
            action?(slider)
        }
        
        slider.actionOnLeftButton = { [weak self] slider in
            guard let `self` = self else { return }
            var RGBA = self.color.RGBA
            RGBA.blue -= 1.0/255.0
            RGBA.blue = RGBA.blue.clampedTo01
            self.set(color:UIColor(RGBA:RGBA), dragging:false, animated:false)
            action?(slider)
        }
        
        slider.actionOnRightButton = { [weak self] slider in
            guard let `self` = self else { return }
            var RGBA = self.color.RGBA
            RGBA.blue += 1.0/255.0
            RGBA.blue = RGBA.blue.clampedTo01
            self.set(color:UIColor(RGBA:RGBA), dragging:false, animated:false)
            action?(slider)
        }
        
        return slider
    }
    
    public func addComponentSliderAlpha         (side   : CGFloat = 32,
                                                 title  : String,
                                                 action : ((ComponentSlider)->())? = nil) -> ComponentSlider {

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
            action?(slider)
        }
        
        slider.actionOnLeftButton = { [weak self] slider in
            guard let `self` = self else { return }
            var RGBA = self.color.RGBA
            RGBA.alpha -= 1.0/255.0
            RGBA.alpha = RGBA.alpha.clampedTo01
            self.set(color:UIColor(RGBA:RGBA), dragging:false, animated:false)
            action?(slider)
        }
        
        slider.actionOnRightButton = { [weak self] slider in
            guard let `self` = self else { return }
            var RGBA = self.color.RGBA
            RGBA.alpha += 1.0/255.0
            RGBA.alpha = RGBA.alpha.clampedTo01
            self.set(color:UIColor(RGBA:RGBA), dragging:false, animated:false)
            action?(slider)
        }
        
        return slider
    }
    
    public func addComponentSliderHue           (side   : CGFloat = 32,
                                                 title  : String,
                                                 action : ((ComponentSlider)->())? = nil) -> ComponentSlider {

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
            action?(slider)
        }
        
        slider.actionOnLeftButton = { [weak self] slider in
            guard let `self` = self else { return }
            var HSBA = self.color.HSBA
            HSBA.hue -= 1.0/360.0
            HSBA.hue = HSBA.hue.clampedTo01
            self.set(color:UIColor(HSBA:HSBA), dragging:false, animated:false)
            action?(slider)
        }
        
        slider.actionOnRightButton = { [weak self] slider in
            guard let `self` = self else { return }
            var HSBA = self.color.HSBA
            HSBA.hue += 1.0/360.0
            HSBA.hue = HSBA.hue.clampedTo01
            self.set(color:UIColor(HSBA:HSBA), dragging:false, animated:false)
            action?(slider)
        }

        return slider
    }
    
    public func addComponentSliderSaturation    (side   : CGFloat = 32,
                                                 title  : String,
                                                 action : ((ComponentSlider)->())? = nil) -> ComponentSlider {

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
            action?(slider)
        }
        
        slider.actionOnLeftButton = { [weak self] slider in
            guard let `self` = self else { return }
            var HSBA = self.color.HSBA
            HSBA.saturation -= 1.0/255.0
            HSBA.saturation = HSBA.saturation.clampedTo01
            self.set(color:UIColor(HSBA:HSBA), dragging:false, animated:false)
            action?(slider)
        }
        
        slider.actionOnRightButton = { [weak self] slider in
            guard let `self` = self else { return }
            var HSBA = self.color.HSBA
            HSBA.saturation += 1.0/255.0
            HSBA.saturation = HSBA.saturation.clampedTo01
            self.set(color:UIColor(HSBA:HSBA), dragging:false, animated:false)
            action?(slider)
        }
        
        return slider
    }
    
    public func addComponentSliderBrightness    (side   : CGFloat = 32,
                                                 title  : String,
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
                                                 title  : String,
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
                                                     title  : String,
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
                                                 title  : String,
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
                                                 title  : String,
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
                                                 title                  : String,
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
                                            title       : String,
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
        
        let result = ComponentSlider()
        
        result.leftView     = leftView
        result.leftButton   = leftButton
        result.slider       = slider
        result.rightButton  = rightButton
        result.rightView    = rightView
        
        let tray = addTray(withContentView: result, title: title)
        
        result.build(side:side, margin:configuration.slider.margin)
        
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
    
    open func addComponentDisplayFill    (title:String, height side:CGFloat = 32) -> ComponentDisplayFill {
        
        let display = ComponentDisplayFill(height:side, colorArrayManager:colorArrayManager)
        
        let tray = addTray(withContentView: display, title: title)
        
        display.updateFromColor()
        
        return display
    }
    
    open func addComponentDisplayDot     (title:String, height side:CGFloat = 32) -> ComponentDisplayDot {
        
        let display = ComponentDisplayDot(height:side, colorArrayManager:self.colorArrayManager)
        
        let tray = addTray(withContentView: display, title: title)

        display.updateFromColor()
        
        return display
    }
    
    open func addComponentDisplaySplitDiagonal  (title:String, height side:CGFloat = 32) -> ComponentDisplaySplitDiagonal {
        
        let display = ComponentDisplaySplitDiagonal(height:side, colorArrayManager:self.colorArrayManager)
        
        let tray = addTray(withContentView: display, title: title)

        display.updateFromColor()
        
        return display
    }
    
    open func addComponentDisplaySplitVertical (title:String, height side:CGFloat = 32) -> ComponentDisplaySplitVertical {
        
        let display = ComponentDisplaySplitVertical(height:side, colorArrayManager:self.colorArrayManager)
        
        let tray = addTray(withContentView: display, title: title)

        display.updateFromColor()
        
        return display
    }
    
    open func addComponentDisplaySplitHorizontal (title:String, height side:CGFloat = 32) -> ComponentDisplaySplitHorizontal {
        
        let display = ComponentDisplaySplitHorizontal(height:side, colorArrayManager:self.colorArrayManager)
        
        let tray = addTray(withContentView: display, title: title)

        display.updateFromColor()
        
        return display
    }
    
    open func addComponentDisplayValueRGBAAsHexadecimal (title:String, height side:CGFloat = 32) -> ComponentDisplayValueRGBAAsHexadecimal {
        
        let display = ComponentDisplayValueRGBAAsHexadecimal(configuration:configuration.display.value, colorArrayManager:self.colorArrayManager) { [weak self] color in
            self?.set(color: color, dragging: false, animated: true)
        }
        
        let tray = addTray(withContentView: display, title: title)
        
        display.updateFromColor()
        
        return display
    }
    
    open func addComponentDisplayValueRGB (title:String, height side:CGFloat = 32) -> ComponentDisplayValueRGB {
        
        let display = ComponentDisplayValueRGB(configuration:configuration.display.value, colorArrayManager:self.colorArrayManager) { [weak self] color in
            self?.set(color: color, dragging: false, animated: true)
        }

        let tray = addTray(withContentView  : display,
                           titles           : ["red","green","blue"].zipped(with:[display.fieldR,display.fieldG,display.fieldB].map { $0 as UIView }))

        display.updateFromColor()
        
        return display
    }
    
    open func addComponentOperations            (title:String, operations:[(operation:Operation,title:String)]) -> ComponentOperations {
        
        let display = ComponentOperations(operations:operations.map { $0.operation })
        
        display.build(withConfiguration: configuration.operations)
        
        let tray = addTray(withContentView  : display,
                           titles           : operations.map { $0.title }.zipped(with:display.buttons.map { $0! as UIView }))

        
        return display
    }
    
    open func addComponentStorageDots       (title:String, radius:CGFloat, columns:Int, rows:Int, colors:[UIColor]) -> ComponentStorageDots {
        
        let storage = ComponentStorageDots()
        
        let tray = addTray(withContentView: storage, title: title)

        storage.rows     = rows
        storage.columns  = columns
        storage.set(radius: radius, colors: colors) { [weak self] color in
            self?.set(color:color, dragging:false, animated:true)
        }
        storage.backgroundColor = .clear

        return storage
    }

    open func addComponentStorageHistory    (title:String, radius:CGFloat, columns:Int, rows:Int, colors:[UIColor]) -> ComponentStorageHistory {
        
        let storage = ComponentStorageHistory()
        
        let tray = addTray(withContentView: storage, title: title)

        storage.rows     = rows
        storage.columns  = columns
        storage.set(radius: radius, colors: colors) { [weak self] color in
            self?.set(color:color, dragging:false, animated:true)
        }
        storage.backgroundColor = .clear
        
        return storage
    }
    
    open func addComponentStorageDrag       (title:String, radius:CGFloat, columns:Int, rows:Int, colors:[UIColor]) -> ComponentStorageDrag {
        
        let storage = ComponentStorageDrag()
        
        let tray = addTray(withContentView: storage, title: title)

        storage.rows     = rows
        storage.columns  = columns
        storage.set(radius: radius, colors: colors) { [weak self] color in
            self?.set(color:color, dragging:false, animated:true)
        }
        storage.backgroundColor = .clear

        return storage
    }
    
    
    
    
    open func set       (color:UIColor, dragging:Bool, animated:Bool) {
        self.color = color
        self.colorArrayManager.color = color
        componentSliders.forEach { $0.update(color:color, animated:animated) }
        componentDisplays.forEach { $0.updateFromColor() }
        handlerForColor?(color,dragging,animated)
    }
    
    open func clear     (withLastColorArray array:[UIColor] = [.white], lastColorIndex index:Int = 0) {
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
    
    open func build     () {
        
        if let first = self.subviews.first, let last = self.subviews.last {
            
            self.translatesAutoresizingMaskIntoConstraints=false
            
            // stripes
            if configuration.stripes.show {
                for i in 0..<subviews.count {
                    subviews[i].isOpaque = true
                    subviews[i].backgroundColor = i.isOdd ? configuration.stripes.odd.background : configuration.stripes.even.background
                }
            }

            // tie subviews together
            self.subviews.adjacent { a,b in
                b.topAnchor.constraint(equalTo: a.bottomAnchor).isActive=true
            }
            
            // tie left/right anchors of subviews to picker
            for subview in self.subviews {
                subview.leftAnchor.constraint(equalTo: self.leftAnchor).isActive=true
                subview.rightAnchor.constraint(equalTo: self.rightAnchor).isActive=true
            }
            
            // tie picker top anchor to top subview
            // tie picker bottom anchor to bottom subview
            first.topAnchor.constraint(equalTo: self.topAnchor).isActive=true
            self.bottomAnchor.constraint(equalTo: last.bottomAnchor).isActive=true
        }

        self.componentSliders   = self.subviews.filter { UIViewTray.contentView(of: $0) is ComponentSlider }.map { UIViewTray.contentView(of: $0) as! ComponentSlider }
        self.componentDisplays  = self.subviews.filter { UIViewTray.contentView(of: $0) is ComponentDisplay }.map { UIViewTray.contentView(of: $0) as! ComponentDisplay }
        self.componentStorage   = self.subviews.filter { UIViewTray.contentView(of: $0) is ComponentStorage }.map { UIViewTray.contentView(of: $0) as! ComponentStorage }
        
        // update color array limit to highest limit supported
        self.colorArrayManager.colorLimit = self.componentDisplays.map{ $0.colorLimit }.reduce(0){ max($0,$1) }
        print("updated color-array-index :\(colorArrayManager.colorIndex)")
        print("updated color-array-limit :\(colorArrayManager.colorLimit)")

        self.componentDisplays.forEach { $0.updateFromColor() }
    }
        
    
    static public func create           (withComponents components:[Component]) -> GenericPickerOfColor {
        let result = GenericPickerOfColor()
        
        for component in components {
//            switch component {
//
//            case .colorDisplayDot        (let height) :
//                _ = result.addComponentDisplayDot    (height:height)
//
//            case .sliderRed             (let height)     : _ = result.addComponentSliderRed         (side:height)
//            case .sliderGreen           (let height)     : _ = result.addComponentSliderGreen       (side:height)
//            case .sliderBlue            (let height)     : _ = result.addComponentSliderBlue        (side:height)
//            case .sliderAlpha           (let height)     : _ = result.addComponentSliderAlpha       (side:height)
//            case .sliderHue             (let height)     : _ = result.addComponentSliderHue         (side:height)
//            case .sliderSaturation      (let height)     : _ = result.addComponentSliderSaturation  (side:height)
//            case .sliderBrightness      (let height)     : _ = result.addComponentSliderBrightness  (side:height)
//            case .sliderCyan            (let height)     : _ = result.addComponentSliderCyan        (side:height)
//            case .sliderMagenta         (let height)     : _ = result.addComponentSliderMagenta     (side:height)
//            case .sliderYellow          (let height)     : _ = result.addComponentSliderYellow      (side:height)
//            case .sliderKey             (let height)     : _ = result.addComponentSliderKey         (side:height)
//
//            case .storageDots           (let radius, let columns, let rows, let colors) :
//                _ = result.addComponentStorageDots(radius:radius, columns:columns, rows:rows, colors:colors)
//
//            default: _ = result.addComponentSliderRed(side:16)
//
//            }
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
