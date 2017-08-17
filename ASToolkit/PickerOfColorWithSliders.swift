//
//  PickerOfColorWithSliders.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 8/16/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

open class PickerOfColorWithSliders : UIView {

    open class StoredColors : UIView {
        
        private var buttons : [[UIButtonWithCenteredCircle]] = []
        
        public var limit    = 32
        
        public var columns  = 4
        
        // constraint on count of columns? on button radius? on margin?
        
        public func set     (colors:[UIColor]) {
            
        }
        
        public func add     (color:UIColor) {
            
        }
        
        public func remove  (color:UIColor) {
            
        }
    }
    
    open class Slider : UIView {
        
        public enum Kind {
            case red(height:CGFloat),green(height:CGFloat),blue(height:CGFloat)
            case hue(height:CGFloat),saturation(height:CGFloat),value(height:CGFloat)
            case alpha(height:CGFloat)
            case custom(height:CGFloat, color:UIColor, label:NSAttributedString, value0:Float, value1:Float)
        }
        
        public weak var leftView    : UILabelWithInsetsAndCenteredCircle!
        public weak var leftButton  : UIButtonWithCenteredCircle!
        public weak var slider      : UISlider!
        public weak var rightButton : UIButtonWithCenteredCircle!
        public weak var rightView   : UILabelWithInsetsAndCenteredCircle!
        
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
    
    override public init            (frame:CGRect) {
        super.init(frame:frame)
    }
    
    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addSliderRed        (side:CGFloat = 32, action:((Int)->Bool)? = nil) -> Slider {
        let slider = self.addSlider(label: "R" | UIColor.white, color: UIColor(rgb:[1,0,0]), side:side)
        
        slider.update = { [weak slider] color in
            let RGBA = color.RGBA
            slider?.slider.setValue(Float(RGBA.red*255), animated:true)
            slider?.rightView.circle.fillColor = UIColor(rgba:[1,0,0,RGBA.red]).cgColor
            slider?.rightView.setNeedsDisplay()
        }
        
        slider.action = { [weak slider, weak self] value in
            guard let `self` = self else { return }
            var RGBA = self.color.RGBA
            RGBA.red = CGFloat(value) / CGFloat(255.0)
            self.color = UIColor(rgba: [RGBA.red,RGBA.green,RGBA.blue,RGBA.alpha])
            slider?.rightView.circle.fillColor = UIColor(rgba:[1,0,0,RGBA.red]).cgColor
            slider?.rightView.setNeedsDisplay()
        }
        
        slider.slider.addTarget(self, action: #selector(PickerOfColorWithSliders.handleSliderEvent(_:)), for: .allEvents)
        
        return slider
    }
    
    public func addSliderGreen      (side:CGFloat = 32, action:((Int)->Bool)? = nil) -> Slider {
        
        let slider = self.addSlider(label: "G" | UIColor.white, color: UIColor(rgb:[0,0.9,0]), side:side)
        
        slider.update = { [weak slider] color in
            let RGBA = color.RGBA
            slider?.slider.setValue(Float(RGBA.green*255), animated:true)
            slider?.rightView.circle.fillColor = UIColor(rgba:[0,0.9,0,RGBA.green]).cgColor
            slider?.rightView.setNeedsDisplay()
        }
        
        slider.action = { [weak slider, weak self] value in
            guard let `self` = self else { return }
            var RGBA = self.color.RGBA
            RGBA.green = CGFloat(value) / CGFloat(255.0)
            self.color = UIColor(rgba: [RGBA.red,RGBA.green,RGBA.blue,RGBA.alpha])
            slider?.rightView.circle.fillColor = UIColor(rgba:[0,0.9,0,RGBA.green]).cgColor
            slider?.rightView.setNeedsDisplay()
        }
        
        slider.slider.addTarget(self, action: #selector(PickerOfColorWithSliders.handleSliderEvent(_:)), for: .allEvents)
        
        return slider
    }
    
    public func addSliderBlue       (side:CGFloat = 32, action:((Int)->Bool)? = nil) -> Slider {
        
        let slider = self.addSlider(label: "B" | UIColor.white, color: UIColor(rgb:[0.4,0.6,1]), side:side)
        
        slider.update = { [weak slider] color in
            let RGBA = color.RGBA
            slider?.slider.setValue(Float(RGBA.blue*255), animated:true)
            slider?.rightView.circle.fillColor = UIColor(rgba:[0.4,0.6,1,RGBA.blue]).cgColor
            slider?.rightView.setNeedsDisplay()
        }
        
        slider.action = { [weak slider, weak self] value in
            guard let `self` = self else { return }
            var RGBA = self.color.RGBA
            RGBA.blue = CGFloat(value) / CGFloat(255.0)
            self.color = UIColor(rgba: [RGBA.red,RGBA.green,RGBA.blue,RGBA.alpha])
            slider?.rightView.circle.fillColor = UIColor(rgba:[0.4,0.6,1,RGBA.blue]).cgColor
            slider?.rightView.setNeedsDisplay()
        }
        
        slider.slider.addTarget(self, action: #selector(PickerOfColorWithSliders.handleSliderEvent(_:)), for: .allEvents)
        
        return slider
    }
    
    public func addSliderAlpha      (side:CGFloat = 32, action:((Int)->Bool)? = nil) -> Slider {
        
        let slider = self.addSlider(label: "A" | UIColor.gray, color: UIColor(white:1.0), side:side)
        
        slider.update = { [weak slider] color in
            let RGBA = color.RGBA
            slider?.slider.setValue(Float(RGBA.alpha*255), animated:true)
            slider?.rightView.circle.fillColor = UIColor(white:1.0,alpha:RGBA.alpha).cgColor
            slider?.rightView.setNeedsDisplay()
        }
        
        slider.action = { [weak slider, weak self] value in
            guard let `self` = self else { return }
            var RGBA = self.color.RGBA
            RGBA.alpha = CGFloat(value) / CGFloat(255.0)
            self.color = UIColor(rgba: [RGBA.red,RGBA.green,RGBA.blue,RGBA.alpha])
            slider?.rightView.circle.fillColor = UIColor(white:1.0,alpha:RGBA.alpha).cgColor
            slider?.rightView.setNeedsDisplay()
        }
        
        slider.slider.addTarget(self, action: #selector(PickerOfColorWithSliders.handleSliderEvent(_:)), for: .allEvents)
        
        return slider
    }
    
    func handleSliderEvent(_ control:UIControl) {
        if let uislider = control as? UISlider {
            if let slider = self.sliders.find({ $0.slider == uislider }) {
                slider.action(uislider.value)
            }
        }
    }
    
    private var displayColor : UIView?
    
    public func addDisplayColor     (side:CGFloat = 128) -> UIView {
        self.displayColor?.removeFromSuperview()
        let displayColor = UIViewCircle(frame: CGRect(side:side))
        displayColor.backgroundColor = self.color
        self.addSubview(displayColor)
        self.displayColor = displayColor

        displayColor.translatesAutoresizingMaskIntoConstraints=false
        displayColor.heightAnchor.constraint(equalToConstant: side).isActive=true
        displayColor.widthAnchor.constraint(equalToConstant: side).isActive=true
        displayColor.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive=true
        
        return displayColor
    }
    
    public func addSlider           (label:NSAttributedString, color:UIColor, side:CGFloat = 32) -> Slider {
        
        let leftView        = UILabelWithInsetsAndCenteredCircle    ()
        let leftButton      = UIButtonWithCenteredCircle            ()
        let slider          = UISlider()
        let rightButton     = UIButtonWithCenteredCircle            ()
        let rightView       = UILabelWithInsetsAndCenteredCircle    ()
        
        slider.minimumValue = 0
        slider.maximumValue = 255
        slider.tintColor = color
        slider.isContinuous = false
        
        leftView.attributedText     = label
        leftView.circle.radius      = side/2
        leftView.circle.fillColor   = color.cgColor
        leftView.sizeToFit()

        rightView.circle.radius     = side/2
        rightView.circle.fillColor  = UIColor.clear.cgColor

        leftButton.setAttributedTitle("-" | UIColor.white, for: .normal)
        leftButton.circle(for: .normal).radius = side/2
        leftButton.circle(for: .normal).fillColor = UIColor(white:0.9).cgColor

        rightButton.setAttributedTitle("+" | UIColor.white, for: .normal)
        rightButton.circle(for: .normal).radius = side/2
        rightButton.circle(for: .normal).fillColor = UIColor(white:0.9).cgColor
        
        
        
//        var someObject:AnyObject = "whatever" as AnyObject
//        let interval = someObject.timeIntervalSinceNow
        
        
        let result = Slider()
        
        result.leftView     = leftView
        result.leftButton   = leftButton
        result.slider       = slider
        result.rightButton  = rightButton
        result.rightView    = rightView
        
        self.addSubview(result)
        
        result.build(side:side)
        
        return result
    }
    
    public var sliders : [Slider] {
        return self.subviews.filter { $0 is Slider }.map { $0 as! Slider }
    }
    
    public var color : UIColor = .clear {
        didSet {
            sliders.forEach { $0.update(color) }
            displayColor?.backgroundColor = color
            handler?(color)
        }
    }
    
    
    private func build() {
        
        // the width of each element in box equals this width
        // the height of each element in box is variant
        // the box is centered vertically and horizontally to this view
        
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
                if subview is Slider {
                    subview.leftAnchor.constraint(equalTo: self.leftAnchor).isActive=true
                    subview.rightAnchor.constraint(equalTo: self.rightAnchor).isActive=true
                }
            }
        }

    }
    
    
    /// This handler is called whenever the color changes
    public var handler  : ((UIColor)->())?
    
    
    static public func create           (withSliders kinds:[Slider.Kind], withStoredColors:[UIColor] = []) -> PickerOfColorWithSliders {
        let result = PickerOfColorWithSliders()
        
//        result.addArrangedSubview(CellForColor(radius:25))
        
        result.addDisplayColor(side:128)
        
        for kind in kinds {
            switch kind {
            case .red(let height)       : result.addSliderRed(side:height)
            case .green(let height)     : result.addSliderGreen(side:height)
            case .blue(let height)      : result.addSliderBlue(side:height)
            case .alpha(let height)     : result.addSliderAlpha(side:height)
                
            default: _ = result.addSliderRed(side:16)
            }
        }

        result.build()
//        result.addArrangedSubview(StorageOfColor(withOperations:[.add,.remove,.close,.select), columns:5, spacing:4))
        
        return result
    }
}
