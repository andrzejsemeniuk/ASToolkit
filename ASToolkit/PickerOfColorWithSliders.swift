//
//  PickerOfColorWithSliders.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 8/16/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

open class PickerOfColorWithSliders : UIView {

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
        
        case storageDots            (radius:CGFloat, rows:Int, colors:[UIColor])
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
            if false {
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
    
    open class ComponentStorageDots : UIView {
        
        private var buttons : [[UIButtonWithCenteredCircle]] = []
        
        public var rows     = 4
        
        public var columns  = 4
        
        // constraint on count of columns? on button radius? on margin?
        
        public func set     (colors:[UIColor]) {
            
        }
        
        public func add     (color:UIColor) {
            
        }
        
        public func remove  (color:UIColor) {
            
        }
    }
    
    open class ComponentSlider : UIView {
        
        public weak var leftView    : UIViewCircleWithUILabel!
        public weak var leftButton  : UIButtonWithCenteredCircle!
        public weak var slider      : UISlider!
        public weak var rightButton : UIButtonWithCenteredCircle!
        public weak var rightView   : UIViewCircleWithUILabel!
        
        public var update           : (UIColor)->() = { _ in }
        public var action           : (Float)->() = { _ in }
        
        public func build(side:CGFloat, margin:CGFloat = 16) {
            
            self.addSubviews([
                slider,
                leftButton,
                rightButton,
                leftView,
                rightView
                ])
            
            let builder = NSLayoutConstraintsBuilder(views:[
                "self"          : self,
                "leftView"      : leftView,
                "leftButton"    : leftButton,
                "slider"        : slider,
                "rightButton"   : rightButton,
                "rightView"     : rightView
                ])
            
            builder < "H:|-[leftView(\(side))]-[leftButton(\(side))]-[slider(>=8)]-[rightButton(\(side))]-[rightView(\(side))]-|"
            builder < "V:|-(\(margin))-[leftView(\(side))]-(\(margin))-|"
            builder < "V:|-(\(margin))-[leftButton(\(side))]-(\(margin))-|"
            builder < "V:|-(\(margin))-[rightButton(\(side))]-(\(margin))-|"
            builder < "V:|-(\(margin))-[rightView(\(side))]-(\(margin))-|"
            builder < "V:|-(\(margin))-[slider(\(side))]-(\(margin))-|"
            builder < "V:[self(\(side+margin+margin))]"
            builder.activate()

        }
    }
    
    // MARK: - Data
    
    public var componentSliders     : [ComponentSlider]         = []
    public var componentDisplays    : [ComponentColorDisplay]   = []
    
    public var color            : UIColor               = .clear {
        didSet {
            componentSliders.forEach { $0.update(color) }
            componentDisplays.forEach { $0.color = color }
            handler?(color)
        }
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
        
        slider.update = { [weak slider] color in
            guard let `slider` = slider else { return }
            let RGBA = color.RGBA
            slider.slider.setValue(Float(RGBA.red)*slider.slider.maximumValue, animated:true)
            slider.rightView.backgroundColor = UIColor(rgba:[1,0,0,RGBA.red])
            slider.rightView.setNeedsDisplay()
        }
        
        slider.action = { [weak slider, weak self] value in
            guard let `self` = self else { return }
            guard let `slider` = slider else { return }
            var RGBA = self.color.RGBA
            RGBA.red = CGFloat(value) / CGFloat(slider.slider.maximumValue)
            self.color = UIColor(RGBA:RGBA)
        }
        
        slider.slider.addTarget(self, action: #selector(PickerOfColorWithSliders.handleSliderEvent(_:)), for: .allEvents)
        
        return slider
    }
    
    public func addComponentSliderGreen      (side:CGFloat = 32, action:((Int)->Bool)? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label: "G" | UIColor.white | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize), color: UIColor(rgb:[0,0.9,0]), side:side)
        
        slider.update = { [weak slider] color in
            guard let `slider` = slider else { return }
            let RGBA = color.RGBA
            slider.slider.setValue(Float(RGBA.green)*slider.slider.maximumValue, animated:true)
            slider.rightView.backgroundColor = UIColor(rgba:[0,0.9,0,RGBA.green])
            slider.rightView.setNeedsDisplay()
        }
        
        slider.action = { [weak slider, weak self] value in
            guard let `self` = self else { return }
            guard let `slider` = slider else { return }
            var RGBA = self.color.RGBA
            RGBA.green = CGFloat(value) / CGFloat(slider.slider.maximumValue)
            self.color = UIColor(RGBA:RGBA)
        }
        
        slider.slider.addTarget(self, action: #selector(PickerOfColorWithSliders.handleSliderEvent(_:)), for: .allEvents)
        
        return slider
    }
    
    public func addComponentSliderBlue       (side:CGFloat = 32, action:((Int)->Bool)? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label: "B" | UIColor.white | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize), color: UIColor(rgb:[0.4,0.6,1]), side:side)
        
        slider.update = { [weak slider] color in
            guard let `slider` = slider else { return }
            let RGBA = color.RGBA
            slider.slider.setValue(Float(RGBA.blue)*slider.slider.maximumValue, animated:true)
            slider.rightView.backgroundColor = UIColor(rgba:[0.4,0.6,1,RGBA.blue])
            slider.rightView.setNeedsDisplay()
        }
        
        slider.action = { [weak slider, weak self] value in
            guard let `self` = self else { return }
            guard let `slider` = slider else { return }
            var RGBA = self.color.RGBA
            RGBA.blue = CGFloat(value) / CGFloat(slider.slider.maximumValue)
            self.color = UIColor(RGBA:RGBA)
        }
        
        slider.slider.addTarget(self, action: #selector(PickerOfColorWithSliders.handleSliderEvent(_:)), for: .allEvents)
        
        return slider
    }
    
    public func addComponentSliderAlpha      (side:CGFloat = 32, action:((Int)->Bool)? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label: "A" | UIColor.lightGray | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize), color: UIColor(white:1.0), side:side)
        
        slider.update = { [weak slider] color in
            guard let `slider` = slider else { return }
            let RGBA = color.RGBA
            slider.slider.setValue(Float(RGBA.alpha)*slider.slider.maximumValue, animated:true)
            slider.rightView.backgroundColor = UIColor(white:1.0,alpha:RGBA.alpha)
            slider.rightView.setNeedsDisplay()
        }
        
        slider.action = { [weak slider, weak self] value in
            guard let `self` = self else { return }
            guard let `slider` = slider else { return }
            var RGBA = self.color.RGBA
            RGBA.alpha = CGFloat(value) / CGFloat(slider.slider.maximumValue)
            self.color = UIColor(RGBA:RGBA)
        }
        
        slider.slider.addTarget(self, action: #selector(PickerOfColorWithSliders.handleSliderEvent(_:)), for: .allEvents)
        
        return slider
    }
    
    public func addComponentSliderHue       (side:CGFloat = 32, action:((Int)->Bool)? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label: "H" | UIColor.lightGray | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize), color: UIColor(white:0,alpha:0.02), side:side)
        
        slider.slider.minimumValue = 0
        slider.slider.maximumValue = 359.999
        
        slider.update = { [weak slider] color in
            guard let `slider` = slider else { return }
            let HSBA = color.HSBA
            slider.slider.setValue(Float(HSBA.hue)*slider.slider.maximumValue, animated:true)
            slider.rightView.backgroundColor = UIColor(hsba:[HSBA.hue,1,1,1])
            slider.rightView.setNeedsDisplay()

        }
        
        slider.action = { [weak slider, weak self] value in
            guard let `self` = self else { return }
            guard let `slider` = slider else { return }
            var HSBA = self.color.HSBA
            HSBA.hue = CGFloat(value) / CGFloat(slider.slider.maximumValue)
            self.color = UIColor(HSBA:HSBA)
        }
        
        slider.slider.addTarget(self, action: #selector(PickerOfColorWithSliders.handleSliderEvent(_:)), for: .allEvents)
        
        return slider
    }
    
    public func addComponentSliderSaturation    (side:CGFloat = 32, action:((Int)->Bool)? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label: "S" | UIColor.lightGray | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize), color: UIColor(white:0,alpha:0.02), side:side)
        
        slider.slider.maximumValue = 1
        slider.slider.isContinuous = true
        
        slider.update = { [weak slider] color in
            guard let `slider` = slider else { return }
            let HSBA = color.HSBA
            slider.slider.setValue(Float(HSBA.saturation), animated:true)
            slider.rightView.backgroundColor = UIColor(hsba:[HSBA.hue,HSBA.saturation,1,1])
            slider.rightView.setNeedsDisplay()
        }
        
        slider.action = { [weak self] value in
            guard let `self` = self else { return }
            var HSBA = self.color.HSBA
            HSBA.saturation = CGFloat(value)
            self.color = UIColor(HSBA:HSBA)
        }
        
        slider.slider.addTarget(self, action: #selector(PickerOfColorWithSliders.handleSliderEvent(_:)), for: .allEvents)
        
        return slider
    }
    
    public func addComponentSliderBrightness    (side:CGFloat = 32, action:((Int)->Bool)? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label: "B" | UIColor.lightGray | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize), color: UIColor(white:0,alpha:0.02), side:side)
        
        slider.slider.maximumValue = 1
        slider.slider.isContinuous = true
        
        slider.update = { [weak slider] color in
            guard let `slider` = slider else { return }
            let HSBA = color.HSBA
            slider.slider.setValue(Float(HSBA.brightness), animated:true)
            slider.rightView.backgroundColor = UIColor(hsba:[HSBA.hue,1,HSBA.brightness,1])
            slider.rightView.setNeedsDisplay()
        }
        
        slider.action = { [weak self] value in
            guard let `self` = self else { return }
            var HSBA = self.color.HSBA
            HSBA.brightness = CGFloat(value)
            self.color = UIColor(HSBA:HSBA)
        }
        
        slider.slider.addTarget(self, action: #selector(PickerOfColorWithSliders.handleSliderEvent(_:)), for: .allEvents)
        
        return slider
    }
    
    public func addComponentSliderCyan          (side:CGFloat = 32, action:((Int)->Bool)? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label: "C" | UIColor.black | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize), color: UIColor.cyan, side:side)
        
        slider.slider.maximumValue = 1
        slider.slider.isContinuous = true
        
        slider.update = { [weak slider] color in
            guard let `slider` = slider else { return }
            let CMYK = color.CMYK
            slider.slider.setValue(Float(CMYK.cyan), animated:true)
            slider.rightView.backgroundColor = UIColor.cyan.withAlphaComponent(CMYK.cyan)
            slider.rightView.setNeedsDisplay()
        }
        
        slider.action = { [weak self] value in
            guard let `self` = self else { return }
            var CMYK = self.color.CMYK
            CMYK.cyan = CGFloat(value).clampedTo01
            self.color = UIColor(CMYK:CMYK).withAlphaComponent(self.color.alpha)
        }
        
        slider.slider.addTarget(self, action: #selector(PickerOfColorWithSliders.handleSliderEvent(_:)), for: .allEvents)
        
        return slider
    }
    
    public func addComponentSliderMagenta           (side:CGFloat = 32, action:((Int)->Bool)? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label: "M" | UIColor.black | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize), color: UIColor.magenta, side:side)
        
        slider.slider.maximumValue = 1
        slider.slider.isContinuous = true
        
        slider.update = { [weak slider] color in
            guard let `slider` = slider else { return }
            let CMYK = color.CMYK
            slider.slider.setValue(Float(CMYK.magenta), animated:true)
            slider.rightView.backgroundColor = UIColor.magenta.withAlphaComponent(CMYK.magenta)
            slider.rightView.setNeedsDisplay()
        }
        
        slider.action = { [weak self] value in
            guard let `self` = self else { return }
            var CMYK = self.color.CMYK
            CMYK.magenta = CGFloat(value).clampedTo01
            self.color = UIColor(CMYK:CMYK).withAlphaComponent(self.color.alpha)
        }
        
        slider.slider.addTarget(self, action: #selector(PickerOfColorWithSliders.handleSliderEvent(_:)), for: .allEvents)
        
        return slider
    }
    
    public func addComponentSliderYellow        (side:CGFloat = 32, action:((Int)->Bool)? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label: "Y" | UIColor.black | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize), color: UIColor.yellow, side:side)
        
        slider.slider.maximumValue = 1
        slider.slider.isContinuous = true
        
        slider.update = { [weak slider] color in
            guard let `slider` = slider else { return }
            let CMYK = color.CMYK
            slider.slider.setValue(Float(CMYK.yellow), animated:true)
            slider.rightView.backgroundColor = UIColor.yellow.withAlphaComponent(CMYK.yellow)
            slider.rightView.setNeedsDisplay()
        }
        
        slider.action = { [weak self] value in
            guard let `self` = self else { return }
            var CMYK = self.color.CMYK
            CMYK.yellow = CGFloat(value).clampedTo01
            self.color = UIColor(CMYK:CMYK).withAlphaComponent(self.color.alpha)
        }
        
        slider.slider.addTarget(self, action: #selector(PickerOfColorWithSliders.handleSliderEvent(_:)), for: .allEvents)
        
        return slider
    }
    
    public func addComponentSliderKey           (side:CGFloat = 32, action:((Int)->Bool)? = nil) -> ComponentSlider {
        
        let slider = self.addComponentSlider(label: "K" | UIColor.white | UIFont.systemFont(ofSize: UIFont.smallSystemFontSize), color: UIColor.black, side:side)
        
        slider.slider.maximumValue = 1
        slider.slider.isContinuous = true

        slider.update = { [weak slider] color in
            guard let `slider` = slider else { return }
            let CMYK = color.CMYK
            slider.slider.setValue(Float(CMYK.key), animated:true)
            slider.rightView.backgroundColor = UIColor.black.withAlphaComponent(CMYK.key)
            slider.rightView.setNeedsDisplay()
        }
        
        slider.action = { [weak self] value in
            guard let `self` = self else { return }
            var CMYK = self.color.CMYK
            CMYK.key = CGFloat(value).clampedTo01
            self.color = UIColor(CMYK:CMYK).withAlphaComponent(self.color.alpha)
        }
        
        slider.slider.addTarget(self, action: #selector(PickerOfColorWithSliders.handleSliderEvent(_:)), for: .allEvents)
        
        return slider
    }
    

    open func addComponentSlider           (label:NSAttributedString, color:UIColor, side:CGFloat = 32) -> ComponentSlider {
        
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
        leftButton.circle(for: .normal).fillColor = UIColor(white:0.9).cgColor

        rightButton.setAttributedTitle("+" | UIColor.white, for: .normal)
        rightButton.circle(for: .normal).radius = side/2
        rightButton.circle(for: .normal).fillColor = UIColor(white:0.9).cgColor
        
        
        
//        var someObject:AnyObject = "whatever" as AnyObject
//        let interval = someObject.timeIntervalSinceNow
        
        
        let result = ComponentSlider()
        
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

        self.componentSliders  = self.subviews.filter { $0 is ComponentSlider }.map { $0 as! ComponentSlider }
        self.componentDisplays = self.subviews.filter { $0 is ComponentColorDisplay }.map { $0 as! ComponentColorDisplay }

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
                
            default: _ = result.addComponentSliderRed(side:16)
                
            }
        }

        result.build()
//        result.addArrangedSubview(StorageOfColor(withOperations:[.add,.remove,.close,.select), columns:5, spacing:4))
        
        return result
    }
}
