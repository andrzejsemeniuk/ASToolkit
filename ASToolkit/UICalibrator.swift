//
//  UICalibrator.swift
//  ASToolkit
//
//  Created by andrej on 4/29/19.
//  Copyright © 2019 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit


open class UICalibrator : UIView {

	let TagForButtonOperationLabel = 183

	var root : UIViewController? {
		return UIApplication.shared.keyWindow?.rootViewController
	}

	public struct ConfigurationForSlider {
		var initial			: Float
		var `default`		: Float
		var min 			: Float
		var max 			: Float
		var step 			: Float
		var snap 			: Bool
		var circular		: Bool

		public init(initial: Float, default: Float? = nil, min: Float, max: Float, step: Float = 0, snap: Bool = false, circular: Bool = true) {
			self.initial 	= initial
			self.default 	= `default` ?? initial
			self.min 		= min
			self.max 		= max
			self.step 		= abs(step)
			self.snap 		= snap
			self.circular 	= circular
		}
	}

	var FONT : UIFont {
		return font(0)
	}

	func font(_ size: CGFloat) -> UIFont {
		if let font = styleManager[style]?.variable("label/text:font")?.variableForUIFont?.toUIFont() {
			return font.withSize(font.pointSize + size)
		}
		return
			UIFont.init(name: "Gill Sans", size: UIFont.labelFontSize + size)
			??
			UIFont.defaultFontForLabel.withSize(UIFont.labelFontSize + size)
	}

	var fontForLabel : UIFont {
		return FONT
	}
	var colorForLabelText : UIColor {
		return styleManager[style]?.variable("label/text:color")?.variableForUIColor?.toUIColor() ?? .white
	}
	var colorForLabelFill : UIColor {
		return styleManager[style]?.variable("label/fill:color")?.variableForUIColor?.toUIColor() ?? .gray
	}
	var fontForButton : UIFont {
		return styleManager[style]?.variable("button/text:font")?.variableForUIFont?.toUIFont() ?? FONT
	}
	var colorForButtonText : UIColor {
		return styleManager[style]?.variable("button/text:color")?.variableForUIColor?.toUIColor() ?? .white
	}
	var colorForButtonTextSelected : UIColor {
		return colorForButtonFill
	}
	var colorForButtonFill : UIColor {
		return styleManager[style]?.variable("button/fill:color")?.variableForUIColor?.toUIColor() ?? .white
	}
	var colorForButtonRim : UIColor {
		return styleManager[style]?.variable("button/rim:color")?.variableForUIColor?.toUIColor() ?? .white
	}
	var colorForButtonBackgroundSelected : UIColor {
		return colorForButtonText
	}
	var colorForButtonBackgroundNormal : UIColor {
		return colorForButtonFill
	}
	func colorForButtonBackground(selected: Bool) -> UIColor {
		return selected ? colorForButtonBackgroundSelected : colorForButtonBackgroundNormal
	}
	var thicknessForButtonBand : CGFloat {
		return CGFloat(styleManager[style]?.variable("button/band:float")?.variableForFloat?.value ?? 8)
	}
	var radiusForButton : CGFloat {
		return CGFloat(styleManager[style]?.variable("button/radius:float")?.variableForFloat?.value ?? 16)
	}
	var bandForGroup : CGFloat {
		return CGFloat(styleManager[style]?.variable("group/band:float")?.variableForFloat?.value ?? 4)
	}
	var colorForGroup : UIColor {
		return styleManager[style]?.variable("group/band:color")?.variableForUIColor?.toUIColor() ?? UIColor.init(white: 1, alpha: 0.3)
	}


	var pane										: UIView!						= UIView.init()

	public private(set) var buttonExit				: UIButtonWithCenteredCircle!	= UIButtonWithCenteredCircle.init(frame: .zero)

	public private(set) var buttonPropertyNext		: UIButtonWithCenteredCircle!	= UIButtonWithCenteredCircle.init(frame: .zero)
	public private(set) var buttonPropertyPrev		: UIButtonWithCenteredCircle!	= UIButtonWithCenteredCircle.init(frame: .zero)
	public private(set) var buttonPropertyCopy 		: UIButtonWithCenteredCircle!	= UIButtonWithCenteredCircle.init(frame: .zero)
	public private(set) var buttonPropertyPaste		: UIButtonWithCenteredCircle!	= UIButtonWithCenteredCircle.init(frame: .zero)
	public private(set) var buttonPropertyInitial	: UIButtonWithCenteredCircle!	= UIButtonWithCenteredCircle.init(frame: .zero)
	public private(set) var buttonPropertyDefault	: UIButtonWithCenteredCircle!	= UIButtonWithCenteredCircle.init(frame: .zero)

	public private(set) var buttonValueDefault		: UIButtonWithCenteredCircle!	= UIButtonWithCenteredCircle.init(frame: .zero)
	public private(set) var buttonValueInitial		: UIButtonWithCenteredCircle!	= UIButtonWithCenteredCircle.init(frame: .zero)
	public private(set) var buttonValueRedo			: UIButtonWithCenteredCircle!	= UIButtonWithCenteredCircle.init(frame: .zero)
	public private(set) var buttonValueUndo			: UIButtonWithCenteredCircle!	= UIButtonWithCenteredCircle.init(frame: .zero)
	public private(set) var buttonValueHistoryClear	: UIButtonWithCenteredCircle!	= UIButtonWithCenteredCircle.init(frame: .zero)

	public private(set) var buttonMode				: UIButtonWithCenteredCircle!	= UIButtonWithCenteredCircle.init(frame: .zero)
	public private(set) var buttonStyle				: UIButtonWithCenteredCircle!	= UIButtonWithCenteredCircle.init(frame: .zero)
	public private(set) var buttonStyleAdd			: UIButtonWithCenteredCircle!	= UIButtonWithCenteredCircle.init(frame: .zero)
	public private(set) var buttonCalibration		: UIButtonWithCenteredCircle!	= UIButtonWithCenteredCircle.init(frame: .zero)
	public private(set) var buttonSave				: UIButtonWithCenteredCircle!	= UIButtonWithCenteredCircle.init(frame: .zero)

	public private(set) var buttonManagerPrint		: UIButtonWithCenteredCircle!	= UIButtonWithCenteredCircle.init(frame: .zero)
	public private(set) var buttonPropertyPrint		: UIButtonWithCenteredCircle!	= UIButtonWithCenteredCircle.init(frame: .zero)
	public private(set) var buttonManagerAdd		: UIButtonWithCenteredCircle!	= UIButtonWithCenteredCircle.init(frame: .zero)
	public private(set) var buttonManagerNext		: UIButtonWithCenteredCircle!	= UIButtonWithCenteredCircle.init(frame: .zero)
	public private(set) var buttonManagerPrev		: UIButtonWithCenteredCircle!	= UIButtonWithCenteredCircle.init(frame: .zero)

	public private(set) var buttonOperation1		: UIButtonWithCenteredCircle!	= UIButtonWithCenteredCircle.init(frame: .zero)
	public private(set) var buttonOperation2		: UIButtonWithCenteredCircle!	= UIButtonWithCenteredCircle.init(frame: .zero)
	public private(set) var buttonOperation3		: UIButtonWithCenteredCircle!	= UIButtonWithCenteredCircle.init(frame: .zero)
	public private(set) var buttonOperation4		: UIButtonWithCenteredCircle!	= UIButtonWithCenteredCircle.init(frame: .zero)
	public private(set) var buttonOperation5		: UIButtonWithCenteredCircle!	= UIButtonWithCenteredCircle.init(frame: .zero)

	public private(set) var labelHeading			: UILabelWithInsets!			= UILabelWithInsets.init(frame: .zero)
	public private(set) var labelPropertyTitle		: UILabelWithInsets!			= UILabelWithInsets.init(frame: .zero)
	public private(set) var labelStyle				: UILabelWithInsets!			= UILabelWithInsets.init(frame: .zero)

	private var viewForConfigurations = UIStackView()

	public private(set) var buttonsForConfiguration	: [UIButton]					= []

	public typealias Operation = (title: String, operation: ()->())
	public var operation1 : Operation? {
		didSet {
			define(operation: 1)
		}
	}
	public var operation2 : Operation? {
		didSet {
			define(operation: 2)
		}
	}
	public var operation3 : Operation? {
		didSet {
			define(operation: 3)
		}
	}
	public var operation4 : Operation? {
		didSet {
			define(operation: 4)
		}
	}
	public var operation5 : Operation? {
		didSet {
			define(operation: 5)
		}
	}

	public var informWillDefinePropertyGroup : (()->())?
	public var informDidDefinePropertyGroup : (()->())?
	public var informWillDefineProperty : (()->())?
	public var informDidDefineProperty : (()->())?

	private var clipboardForProperty : [WeakRef<Property>] = []

	private var labelForDemo						: UILabelWithInsets!			= UILabelWithInsets.init(frame: .zero)
	private var buttonForDemo						: UIButtonWithCenteredCircle!	= UIButtonWithCenteredCircle.init(frame: .zero)

	private var animated = false

	private class SliderRow : UIView {

		let index			: Int

		var labelTitle		: UILabelWithInsets = UILabelWithInsets()
		var labelValue		: UILabelWithInsets = UILabelWithInsets()
		var slider			: UISlider = UISlider.init()
		var buttonValueDecrement	: UIButtonWithCenteredCircle = UIButtonWithCenteredCircle()
		var buttonValueIncrement	: UIButtonWithCenteredCircle = UIButtonWithCenteredCircle()

		static var imageForThumb : UIImage = {
			let thickness = CGFloat(5)
			var image = UIViewWithDrawings.init(frame: CGRect.init(width: thickness, height: UIFont.defaultFont.lineHeight+6))
			image.backgroundColor = .clear
			image.drawingAddLineVertical(position: CGPosition.init(0), stroke: CGStroke.init(color: .white, thickness: thickness), after: true)
			return image.asUIImage
		}()

		init(index: Int) {
			self.index = index
			super.init(frame: .zero)

			self.isUserInteractionEnabled = true

			self.addSubviews([slider, buttonValueDecrement, buttonValueIncrement, labelTitle, labelValue])

			slider.setThumbImage(SliderRow.imageForThumb, for: .normal)
			slider.setThumbImage(SliderRow.imageForThumb, for: .selected)
			slider.setThumbImage(SliderRow.imageForThumb, for: .disabled)
		}



		required init?(coder aDecoder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}

	}

	private var sliderRows : [SliderRow] = [
		SliderRow.init(index: 0),
		SliderRow.init(index: 1),
		SliderRow.init(index: 2),
		SliderRow.init(index: 3),
		SliderRow.init(index: 4),
		SliderRow.init(index: 5),
		SliderRow.init(index: 6),
		SliderRow.init(index: 7),
		SliderRow.init(index: 8),
		SliderRow.init(index: 9),
		SliderRow.init(index: 10),
		]


	private var groups : [UIView] {
		return pane?.subviews(withTag:473) ?? []
	}


	private var adding = false {
		didSet {
			if adding {
				doLayoutForModeTransparent()
				self.buttonMode.isHidden = true
				self.buttonExit.isHidden = true
			} else {
				doLayoutForModeFull()
				self.buttonMode.isHidden = false
				self.buttonExit.isHidden = false
			}
		}
	}


	enum Mode : String {
		case initial		= "i"
		//		case compact		= "C"
		case full			= "F"
		//		case essential		= "E"
		case transparent	= "T"


		static func from(string: String) -> Mode {
			return Mode.init(rawValue: string) ?? .initial
		}

		var string : String {
			return "\(rawValue)"
		}


	}

	var mode 				: Mode = .initial {

		didSet {

			if oldValue != mode {

				UserDefaults.standard.set(mode.rawValue, forKey: "mode")
				UserDefaults.standard.synchronize()

				switch mode {
				case .full:
					doLayoutForModeFull()
				case .transparent:
					doLayoutForModeTransparent()
				case .initial:
					break
				}

			}
		}
	}

	var modes : CyclicQueue<Mode> = .init([.full, .transparent]) {
		didSet {
			self.mode = modes.next
		}
	}






	enum Demo : String {
		case none				= "?"
		case one				= "1"
		case two				= "2"
		case three				= "3"
		case four				= "4"

		static func from(string: String) -> Demo {
			switch string {
			case "1" : return .one
			case "2" : return .two
			case "3" : return .three
			case "4" : return .four
			default:
				return .none
			}
		}

		var string : String {
			return "\(rawValue)"
		}
	}

	var demo : Demo = .none {
		didSet {
			restyleButtonForDemo()
		}
	}

	private func restyleButtonForDemo() {

		self.style(button: buttonForDemo, title: self.demo.string, insets: .init())

		updateLabelForDemo()
	}

	func updateLabelForDemo() {

		switch currentProperty.kind {

		case .array:
			break

		case .float:
			break

		case .string:
			break

		case .color:

			let demoColor = currentProperty.valuator() as? UIColor

			self.labelForDemo.numberOfLines = 0
			self.labelForDemo.attributedText = nil
			self.labelForDemo.frame.size.height = 96

			switch demo {

			case .none:
				self.labelForDemo.backgroundColor = nil
			case .one:
				self.labelForDemo.backgroundColor = demoColor
				self.labelForDemo.borderColor = nil
				self.labelForDemo.borderWidth = 0
			case .two:
				self.labelForDemo.backgroundColor = demoColor
				self.labelForDemo.borderColor = .white
				self.labelForDemo.borderWidth = 32
			case .three:
				self.labelForDemo.backgroundColor = demoColor
				self.labelForDemo.borderColor = .black
				self.labelForDemo.borderWidth = 32
			case .four:
				self.labelForDemo.backgroundColor = demoColor
				self.labelForDemo.borderColor = .gray
				self.labelForDemo.borderWidth = 32
			}

		case .font:

			self.labelForDemo.textAlignment = NSTextAlignment.center
			self.labelForDemo.numberOfLines = 4
			let string = "The quick brown fox jumps over the lazy dog\n1234567890 !@#$%^&*() `~ []{}\\|;:'\",./<>?\nABCDEFGHIJKLMNOPQRSTUVWXYZ\nabcdefghijklmnopqrstuvwxyz"
			let demoFont : UIFont = currentProperty.valuator() as? UIFont ?? FONT

			self.labelForDemo.borderColor = nil
			self.labelForDemo.borderWidth = 0

			switch demo {

			case .none:
				self.labelForDemo.backgroundColor = nil
			case .one:
				self.labelForDemo.backgroundColor = UIColor.init(white: 1, alpha: 0.7)
				self.labelForDemo.attributedText = string | UIColor.black | demoFont
			case .two:
				self.labelForDemo.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
				self.labelForDemo.attributedText = string | UIColor.white | demoFont
			case .three:
				self.labelForDemo.backgroundColor = UIColor.init(white: 1, alpha: 0.7)
				self.labelForDemo.attributedText = string | UIColor.gray | demoFont
			case .four:
				self.labelForDemo.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
				self.labelForDemo.attributedText = string | UIColor.gray | demoFont
			}

		}

		switch demo {

		case .none:
			self.labelForDemo.isHidden = true
		default:
			self.labelForDemo.isHidden = false
		}

	}




	let defaultStyles = ["white/black","white/gray","gray/white","paper","yellow"].sorted()

	let userStylesKey = "user-styles"

	var userStyles : [String] {
		get {
			return UserDefaults.standard.stringArray(forKey: userStylesKey) ?? []
		}
		set {
			UserDefaults.standard.set(newValue.sorted(), forKey:userStylesKey)
		}
	}

	var styles : [String] = []

	var style : String = "?" {

		didSet {

			guard oldValue != style else { return }

			UserDefaults.standard.set(style, forKey: "style")
			UserDefaults.standard.synchronize()

			restyle()
		}
	}






	fileprivate func updateUIPropertyConfigurationButton(_ button: UIButton) {
		button.setAttributedTitle((button.title(for: .normal) ?? "???") | fontForLabel | colorForButtonText, for: .normal)
		button.setAttributedTitle((button.title(for: .selected) ?? "???") | fontForLabel | colorForButtonTextSelected, for: .selected)
		button.backgroundColor = colorForButtonBackground(selected: button.isSelected)

		button.borderColor = colorForButtonRim
		button.borderWidth = thicknessForButtonBand
		button.contentEdgeInsets.set(w: 8, h: 4)
		button.cornerRadius = 2
	}

	fileprivate func restyleButtons() {

		let none = UIEdgeInsets.init()

		for (title, insets, button) in [
			(demo.string	, none, buttonForDemo),
			("p"			, none, buttonPropertyPrint),
			("P"			, none, buttonManagerPrint),
			("+"			, UIEdgeInsets.init(top: 1.5), buttonManagerAdd),
			("i"			, none, buttonValueInitial),
			("d"			, none, buttonValueDefault),
			("\u{21BA}"		, UIEdgeInsets.init(top: 2.5), buttonValueUndo),
			("\u{21BB}"		, UIEdgeInsets.init(top: 2.5), buttonValueRedo),
			("\u{2395}"		, UIEdgeInsets.init(top: -1.5), buttonValueHistoryClear),
			(mode.string	, none, buttonMode),
			("@"			, UIEdgeInsets.init(top:-2, left: 0), buttonCalibration),
			("!"			, UIEdgeInsets.init(top:-1.5, left: 0), buttonSave),
			("<"			, UIEdgeInsets.init(top: 1.5, left: 0), buttonPropertyPrev),
			(">"			, UIEdgeInsets.init(top: 1.5, left: 1), buttonPropertyNext),
			("c"			, UIEdgeInsets.init(top: 1.5, left: 1), buttonPropertyCopy),
			("p"			, UIEdgeInsets.init(top: 1.5, left: 1), buttonPropertyPaste),
			("i"			, none, buttonPropertyInitial),
			("d"			, none, buttonPropertyDefault),
			("<"			, UIEdgeInsets.init(top: 1.5, left: 0), buttonManagerPrev),
			(">"			, UIEdgeInsets.init(top: 1.5, left: 1), buttonManagerNext),
			//			("\u{2780}"		, none, buttonOperation1),
			//			("\u{278B}"		, none, buttonOperation2),
			//			("\u{278C}"		, none, buttonOperation3),
			//			("\u{278D}"		, none, buttonOperation4),
			//			("\u{278E}"		, none, buttonOperation5),
			("1"		, none, buttonOperation1),
			("2"		, none, buttonOperation2),
			("3"		, none, buttonOperation3),
			("4"		, none, buttonOperation4),
			("5"		, none, buttonOperation5),
			("~"		, none, buttonStyle),
			("+"		, UIEdgeInsets.init(top: 1.5), buttonStyleAdd),
			]
		{
			self.style(button: button, title: title, insets: insets)
		}

		for button in self.viewForConfigurations.descendants().filtered(type: UIButton.self) {
			updateUIPropertyConfigurationButton(button)
		}

		self.viewForConfigurations.setNeedsLayout()
	}

	fileprivate func restyleLabels() {
//		let manager 	= styleManager[style]!

		let backgroundColor 		= colorForLabelFill // manager.property("label/fill:color").variableForUIColor.toUIColor()
		let ctext		= colorForLabelText // manager.property("label/text:color").variableForUIColor.toUIColor()
		let font		= fontForLabel // manager.property("label/text:font")?.variableForUIFont.toUIFont()
//		let borderColor	= UIColor.init(white: 0.4, alpha: 0.2)


		let styleLabelTitle : (UILabelWithInsets)->() = { label in
			label.font 				= font
			label.textColor 		= ctext
			label.backgroundColor 	= backgroundColor
			label.borderColor 		= .clear
			label.borderWidth 		= 0
			label.insets.left 		= 8
			label.insets.right 		= 8
			label.insets.top 		= 4
			label.insets.bottom 	= 4
		}

		let styleLabelValue : (UILabelWithInsets,CGFloat)->() = { label,alpha in
			label.font 				= font
			label.textColor 		= ctext
			label.backgroundColor 	= backgroundColor
			label.borderColor 		= UIColor.init(white: 1, alpha: alpha)
			label.borderWidth 		= 1
			label.insets.left 		= 8
			label.insets.right 		= 8
			label.insets.top 		= 4
			label.insets.bottom 	= 4

		}

		for row in sliderRows {

			self.style(button: row.buttonValueDecrement, title: "\u{2212}", insets: UIEdgeInsets.init(top: +1.5, left: 1))
			self.style(button: row.buttonValueIncrement, title: "+", insets: UIEdgeInsets.init(top: +1.5))

			styleLabelTitle(row.labelTitle)
			styleLabelValue(row.labelValue,0.3)
		}


		let labelsForOperations = [buttonOperation1, buttonOperation2, buttonOperation3, buttonOperation4, buttonOperation5].compactMap {
			$0?.subview(withTag: TagForButtonOperationLabel) as? UILabelWithInsets
		}

		for label in labelsForOperations {
			styleLabelTitle(label)
		}
		for label in [labelStyle,labelPropertyTitle,labelHeading] {
			styleLabelValue(label!,0.5)
		}

//		self.labelStyle.backgroundColor			= .clear
//		self.labelStyle.font				    ?= self.labelStyle.font?.italicSibling()
		self.labelStyle.attributedText			= "\"\(style)\"" | font.withSize(font.pointSize - 2) | ctext



	}

	fileprivate func restyleGroups() {

		let bg = colorForGroup
		let f = bandForGroup
		let r = radiusForButton

		for group in groups {

			group.backgroundColor 			= bg

			group.layoutMargins.left 		= -f-r
			group.layoutMargins.right 		= +f+r
			group.layoutMargins.bottom 		= +f+r
			group.layoutMargins.top 		= -f-r

			group.updateConstraints()
		}

	}




	public func restyle() {

		restyleButtons()

		restyleLabels()

		restyleGroups()

	}





//	var styleOrangeButtonTitleNormalColor			= UIColor.white
//	var styleOrangeButtonTitleSelectedColor			= UIColor.black
//	var styleOrangeButtonTitleDisabledColor			= UIColor.orange
//
//	var styleOrangeButtonTitleNormalFont			= UIFont.init(name: "GillSans", size: 17)!
//	var styleOrangeButtonTitleSelectedFont			= UIFont.init(name: "GillSans-Bold", size: 17)!
//	var styleOrangeButtonTitleDisabledFont			= UIFont.init(name: "GillSans-Italic", size: 17)!
//
//	var styleOrangeButtonCircleNormalStrokeColor	= UIColor.white
//	var styleOrangeButtonCircleSelectedStrokeColor	= UIColor.orange
//	var styleOrangeButtonCircleDisabledStrokeColor	= UIColor.white
//
//	var styleOrangeButtonCircleNormalFillColor		= UIColor.orange
//	var styleOrangeButtonCircleSelectedFillColor	= UIColor.orange
//	var styleOrangeButtonCircleDisabledFillColor	= UIColor.white
//
//	var styleOrangeButtonCircleNormalRadius			= CGFloat(16)
//	var styleOrangeButtonCircleSelectedRadius		= CGFloat(16)
//	var styleOrangeButtonCircleDisabledRadius		= CGFloat(16)
//
//	var styleOrangeButtonCircleNormalLineWidth		= CGFloat(4)
//	var styleOrangeButtonCircleSelectedLineWidth	= CGFloat(3)
//	var styleOrangeButtonCircleDisabledLineWidth	= CGFloat(0)


	//	var styleOrangeButtonCircleNormal				= UIButtonWithCenteredCircle.Circle.init() { layer in
	//		let layer = layer as! UIButtonWithCenteredCircle.Circle
	//		layer.lineWidth = 3
	//		layer.radius = 16
	//	}


	var styleManager : [String : StorableVariableManager]



	private func style(button: UIButtonWithCenteredCircle!, title: String, insets: UIEdgeInsets) {


//		let manager = styleManager[style]!


		let Fdisabled		= fontForButton.italicSibling() ?? fontForButton


		button?.setAttributedTitle(title | colorForButtonText | fontForButton, for: .normal)
		button?.setAttributedTitle(title | colorForButtonFill | fontForButton, for: .selected)
		button?.setAttributedTitle(title | colorForButtonText.withAlphaComponent(0.8) | Fdisabled, for: .disabled)


		if let circle = button?.circle(for: .normal) {
			circle.radius 		= radiusForButton
			circle.lineWidth 	= thicknessForButtonBand
			circle.strokeColor 	= colorForButtonRim.cgColor
			circle.fillColor 	= colorForButtonFill.cgColor
		}

		if let circle = button?.circle(for: .selected) {
			circle.radius 		= radiusForButton
			circle.lineWidth 	= thicknessForButtonBand
			circle.strokeColor 	= colorForButtonFill.cgColor
			circle.fillColor 	= colorForButtonRim.cgColor
		}

		if let circle = button?.circle(for: .disabled) {
			circle.radius 		= radiusForButton
			circle.lineWidth 	= thicknessForButtonBand
			circle.strokeColor 	= colorForButtonRim.cgColor
			circle.fillColor 	= colorForButtonFill.withAlphaComponent(0.5).withSaturation(0).cgColor
		}

		button?.setNeedsDisplay()


	}






	public enum ListenerInfo {
		case open
		case close
		case update(String,String)
	}

	public typealias Listener = (ListenerInfo)->()

	var listener : Listener






	internal init(heading: String? = nil, listener: @escaping Listener) {

		self.listener = listener

		self.styleManager = [:]

		super.init(frame: .zero)

		self.styles = defaultStyles + userStyles

		build()

		definePropertyGroup()


	}

	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}






	private var superviewInteractionEnabled = true







	private func snap(value v:Float, variable: Variable? = nil) -> Float {

		let variable = variable ?? self.selectedVariable

		let step = abs(variable.slider.step)

		if 0 < step {
			//			print("snap: v=\(v), self.slider.minimumValue=\(self.slider.minimumValue), step=\(step)")
			var m = (v - variable.slider.min) / step
//			var m = v / step
			//			print("snap: m=\(m)")
			m = m.rounded()
			//			print("snap: v=\(v), m=\(m), step=\(step), m*step=\(m * step), new value=\(self.slider.minimumValue + m * step)")
			return variable.slider.min + m * step
//			return m * step
		}

		return v
	}




	func buildStyleManagers() {

		let FONT0 = UIFont.init(name: "Gill Sans", size: UIFont.labelFontSize)!

		let variableForDefaultUIFont = {
//			return StorableVariable.VariableForUIFont.from(font: .defaultFontForLabel, families2names: UIFont.familiesAndNames, min: 5, max: 36) { [weak self] string in
			return StorableVariable.VariableForUIFont.from(font: FONT0,
														families2names: UIFont.familiesAndNames,
														min: 5,
														max: 36)
			{ [weak self] string in
				self?.restyle()
				print("font change for key: \(string)")
			}
		}

		let variableForUIFont = { (name: String, size: CGFloat? ) in
			return StorableVariable.VariableForUIFont.from(font: UIFont.init(name: name, size: size ?? UIFont.defaultFontForLabel.pointSize) ?? .defaultFontForLabel,
														families2names: UIFont.familiesAndNames, //.filter({ key,value in key.contains(name) }),
														min: 5,
														max: 36) { [weak self] string in
				self?.restyle()
				print("font change for key: \(string)")
			}
		}

		let variableForUIColor = { (color: UIColor) in
			return StorableVariable.VariableForUIColor.from(color: color) { [weak self] string in
				self?.restyle()
				print("color change for key: \(string)")
			}
		}

		let variableForBorderInsets = {
			return StorableVariable.VariableForFloat.init(value: 0, default: 0, min: 0, max: 16, step: 1) { [weak self] string in
				self?.restyle()
				print("float change for key: \(string)")
			}
		}

		let variableForBorderWidth = variableForBorderInsets

//		let variableForDefaultCircleRadius = {
//			return StorableVariable.VariableForFloat.init(value: 16, default: 16, min: 0, max: 48, step: 1) { [weak self] string in
//				self?.restyle()
//				print("float change for key: \(string)")
//			}
//		}

		let variableForCircleRadius = { (radius: Float) in
			return StorableVariable.VariableForFloat.init(value: radius, default: radius, min: 0, max: 48, step: 1) { [weak self] string in
				self?.restyle()
				print("float change for key: \(string)")
			}
		}

//		let variableForDefaultCircleStrokeWidth = {
//			return StorableVariable.VariableForFloat.init(value: 0, default: 0, min: 0, max: 48, step: 1) { [weak self] string in
//				self?.restyle()
//				print("float change for key: \(string)")
//			}
//		}

		let variableForCircleStrokeWidth = { (width: Float) in
			return StorableVariable.VariableForFloat.init(value: width, default: width, min: 0, max: 48, step: 1) { [weak self] string in
				self?.restyle()
				print("float change for key: \(string)")
			}
		}

//		let propertiesForButton = {
//			return [
//				StorableVariable.init(key: "button/normal.text:font"					, value: variableForDefaultUIFont()),
//				StorableVariable.init(key: "button/normal.text:color"					, value: variableForUIColor(.white)),
//				//				StorableVariable.init(key: "button/normal.fill:color", value: variableForUIColor(.black)),
//				StorableVariable.init(key: "button/normal.circle.radius:float"			, value: variableForDefaultCircleRadius()),
//				StorableVariable.init(key: "button/normal.circle.stroke.width:float"	, value: variableForDefaultCircleStrokeWidth()),
//				StorableVariable.init(key: "button/normal.circle.stroke:color"			, value: variableForUIColor(.white)),
//				StorableVariable.init(key: "button/normal.circle.fill:color"			, value: variableForUIColor(.black)),
//
//
//				StorableVariable.init(key: "button/selected.text:font"					, value: variableForDefaultUIFont()),
//				StorableVariable.init(key: "button/selected.text:color"					, value: variableForUIColor(.white)),
//				//			StorableVariable.init(key: "button/selected.fill:color"					, value: variableForUIColor(.black)),
//				StorableVariable.init(key: "button/selected.circle.radius:float"		, value: variableForDefaultCircleRadius()),
//				StorableVariable.init(key: "button/selected.circle.stroke.width:float"	, value: variableForDefaultCircleStrokeWidth()),
//				StorableVariable.init(key: "button/selected.circle.stroke:color"		, value: variableForUIColor(.white)),
//				StorableVariable.init(key: "button/selected.circle.fill:color"			, value: variableForUIColor(.black)),
//
//
//				StorableVariable.init(key: "button/disabled.text:font"					, value: variableForDefaultUIFont()),
//				StorableVariable.init(key: "button/disabled.text:color"					, value: variableForUIColor(.white)),
//				//			StorableVariable.init(key: "button/disabled.fill:color"					, value: variableForUIColor(.black)),
//				StorableVariable.init(key: "button/disabled.circle.radius:float"		, value: variableForDefaultCircleRadius()),
//				StorableVariable.init(key: "button/disabled.circle.stroke.width:float"	, value: variableForDefaultCircleStrokeWidth()),
//				StorableVariable.init(key: "button/disabled.circle.stroke:color"		, value: variableForUIColor(.white)),
//				StorableVariable.init(key: "button/disabled.circle.fill:color"			, value: variableForUIColor(.black)),
//				]
//		}

		let propertiesForLabel = { (key: String) in
			return [
				StorableVariable.init(key: "\(key)/text:font"							, value: variableForDefaultUIFont()),
				StorableVariable.init(key: "\(key)/text:color"							, value: variableForUIColor(.white)),
				StorableVariable.init(key: "\(key)/fill:color"							, value: variableForUIColor(.gray)),
//				StorableVariable.init(key: "\(key)/border.insets:float"					, value: variableForBorderInsets()),
//				StorableVariable.init(key: "\(key)/border.width:float"					, value: variableForBorderWidth()),
//				StorableVariable.init(key: "\(key)/border:color"						, value: variableForUIColor(.white)),
				]
		}

		UserDefaults.clear()



		for style in defaultStyles {

			let bcolor0 			: UIColor // bg color / circle fill color
			let bcolor1 			: UIColor // text color
			var bcolorstroke    	: UIColor = .clear // color for circle stroke
			let bfont   			: String
			var bborder    			: Float = 0 // circle-stroke-width
			let bradius				: Float = 16
			var gcolor				: UIColor = UIColor.init(white: 1, alpha: 0.3)
			var gband				: Float = 2

			switch style {

			case "white/black":
				bcolor0 = UIColor.init(white: 0, alpha:0.9)
				bcolor1 = UIColor.init(white: 1, alpha:0.9)
				bfont = "Futura"
			case "white/gray":
				bcolor0 = .gray
				bcolor1 = .white
				bfont = "GillSans"
				bborder = 1
				bcolorstroke = .init(white: 1, alpha:0.34)
				gband = 2
			case "gray/white":
				bcolor0 = .white
				bcolor1 = .gray
				bfont = UIFont.defaultFontForLabel.fontName
				gcolor = UIColor.init(white: 0, alpha: 0.3)
			case "paper":
//				[color : "button/normal.circle.fill:color" : HSVA=["(A=1.0)", "(V=0.7294118)", "(S=0.6039217)", "(H=0.10588239)"]]
//				[color : "button/normal.circle.fill:color" : HSVA=["(A=1.0)", "(V=0.70980394)", "(S=0.6666667)", "(H=0.09019565)"]]
//				bcolor0 = .init(hsb: [0.0902,0.665,0.84])
				bcolor0 = .init(hsb: [0.095,0.52,0.74])
				bcolor1 = .black
				bfont = "Arial"
			case "yellow":
				fallthrough
			default:
				bcolor0 = .init(hsb: [0.121568635,1,0.97])
				bcolor1 = .black
				bfont = "GillSans"
			}

			var array : [StorableVariable] = []

			array += propertiesForLabel("label")
			//				array += propertiesForLabel("label/key")
			//				array += propertiesForLabel("label/value")
			//				array += propertiesForLabel("label/property")
			//				array += propertiesForLabel("label/manager")


			array += [
				StorableVariable.init(key: "button/text:font"				, value: variableForUIFont(bfont,nil)),
				StorableVariable.init(key: "button/text:color"				, value: variableForUIColor(bcolor1)),
				StorableVariable.init(key: "button/fill:color"				, value: variableForUIColor(bcolor0)),
				StorableVariable.init(key: "button/rim:color"				, value: variableForUIColor(bcolorstroke)),
				StorableVariable.init(key: "button/radius:float"			, value: variableForCircleRadius(bradius)),
				StorableVariable.init(key: "button/band:float"				, value: variableForCircleStrokeWidth(bborder)),
			]

			array += [
				StorableVariable.init(key: "group/band:color"				, value: variableForUIColor(gcolor)),
				StorableVariable.init(key: "group/band:float"				, value: variableForCircleStrokeWidth(gband)),
			]


			styleManager[style] = StorableVariableManager.init(key: "@/style/\(style)", variables: array)

			styleManager[style]?.load(overwrite: true)

		}

		for style in userStyles {

			let manager = StorableVariableManager.init(key: "@/style/\(style)")

			manager.load()

			styleManager[style] = manager

			for property in manager.variables {
				property.assign(listener: { [weak self] _ in
					self?.restyle()
				})
			}
		}

		for manager in styleManager.values.sorted(by: { $0.key < $1.key }) {
			add(manager: UICalibrator.PropertyGroup.init(title: manager.key, variables: manager.variables, store: { [weak manager] in
				manager?.store()
			}), calibration: true)
		}

	}



	func save(user: Bool, calibration: Bool) {

		if user {
			managersForUser.store()
		}
		if calibration {
			managersForCalibration.store()
		}

//		self.styleManager.forEach { (key,manager) in
//			manager.store()
//		}

		UserDefaults.standard.synchronize()
	}



	func build() {



		self.buildStyleManagers()



		self.addSubview(pane)

		self.pane.constrainToSuperview()







		self.buttonExit.setAttributedTitle("??" | UIColor.white | FONT, for: .normal)
		self.buttonExit.circle(for: .normal).radius = 16
		self.buttonExit.circle(for: .normal).strokeColor = UIColor.white.cgColor
		self.buttonExit.circle(for: .normal).lineWidth = 3
		self.buttonExit.circle(for: .normal).fillColor = nil
		self.buttonExit.setAttributedTitle("??" | UIColor.white | FONT, for: .selected)
		self.buttonExit.circle(for: .selected).radius = 16
		self.buttonExit.circle(for: .selected).fillColor = UIColor.red.cgColor
		//		self.button.circle(for: .selected).lineWidth = 2
		//		self.button.circle(for: .selected).lineDashPattern = [2,2]
		self.buttonExit.sizeToFit()

		//		editor.translatesAutoresizingMaskIntoConstraints=false

		self.addSubview(buttonExit)

		buttonExit.addTapIfSelected(deselect: 0.1) { [weak self] in
			self?.pane.isHidden = true
			self?.superview?.isUserInteractionEnabled = self?.superviewInteractionEnabled ?? true

			self?.save(user: true, calibration: true)

			self?.listener(.close)
		}

		buttonExit.addTapIfNotSelected { [weak self] in
			self?.pane.isHidden = false
			self?.superviewInteractionEnabled = self?.superview?.isUserInteractionEnabled ?? false
			self?.updateUI()
			self?.listener(.open)
		}






		pane.addSubview(labelForDemo)
		pane.addSubview(labelHeading)
		pane.addSubview(labelStyle)
		pane.addSubview(labelPropertyTitle)

		pane.addSubview(viewForConfigurations)

		pane.addSubview(buttonValueInitial)
		pane.addSubview(buttonValueDefault)
		pane.addSubview(buttonValueUndo)
		pane.addSubview(buttonValueRedo)
		pane.addSubview(buttonValueHistoryClear)

		pane.addSubview(buttonManagerPrint)
		pane.addSubview(buttonPropertyPrint)

		pane.addSubview(buttonPropertyPrev)
		pane.addSubview(buttonPropertyNext)
		pane.addSubview(buttonPropertyCopy)
		pane.addSubview(buttonPropertyPaste)
		pane.addSubview(buttonPropertyInitial)
		pane.addSubview(buttonPropertyDefault)

		pane.addSubview(buttonManagerPrev)
		pane.addSubview(buttonManagerNext)
		pane.addSubview(buttonManagerAdd)

		pane.addSubview(buttonOperation1)
		pane.addSubview(buttonOperation2)
		pane.addSubview(buttonOperation3)
		pane.addSubview(buttonOperation4)
		pane.addSubview(buttonOperation5)

		pane.addSubview(buttonCalibration)
		pane.addSubview(buttonSave)
		pane.addSubview(buttonStyle)
		pane.addSubview(buttonStyleAdd)
		pane.addSubview(buttonForDemo)
		pane.addSubview(buttonMode)





		var row0 : SliderRow?

		
		for (index,row) in sliderRows.enumerated() {


			pane.addSubview(row)

			let margin = CGFloat(16)

			row.tag = index
			row.slider.tag = index
			row.slider.constrainWidth(to: pane).multiplied(0.33)
			//			self.slider.constrainCenterYToSuperview()?.multiplied(1.5),
			row.slider.constrainCenterXToSuperview()
			row.slider.constrainCenterYToSuperview()
			row.slider.constrainViewsRightToLeft(for: [row.buttonValueDecrement, row.labelTitle], offset: -margin)
			row.slider.constrainViewsLeftToRight(for: [row.buttonValueIncrement, row.labelValue], offset: +margin)
			row.slider.constrainViewsCenterYToCenterY(for: [row.labelTitle, row.buttonValueDecrement, row.buttonValueIncrement, row.labelValue])

			row.cornerRadius = 4

			row.constrainCenterXToSuperview()
			row.constrainWidth(to: row.superview!).extended(-32 * 2)
			row.constrainHeight(to: row.slider).extended(16)
			if let row0 = row0 {
				row.constrainCenterYToCenterY(of: row0, withMargin: -48)
			} else {
				row.constrainCenterYToCenterY(of: viewForConfigurations, withMargin: -48)
			}



			row.slider.addTarget(self, action: #selector(handleEventForSlider(_:event:)), for: .allEvents)

			row.buttonValueDecrement.addTapIfNotSelected(named: "action", deselect: 0.15) { [weak self] in
				guard let `self` = self else { return }
				self.selectRow(index: index)
				self.selectedVariable.redosClear()
				let v0 = self.currentSliderRow.slider.value
				var v1 = self.snap(value: v0)
				if v0 <= v1 {
					v1 -= self.selectedVariable.slider.step
				}
				self.setValue(float: v1)
			}

			row.buttonValueIncrement.addTapIfNotSelected(named: "action", deselect: 0.15) { [weak self] in
				guard let `self` = self else { return }
				self.selectRow(index: index)
				self.selectedVariable.redosClear()
				let v0 = self.currentSliderRow.slider.value
				var v1 = self.snap(value: v0)
				if v1 <= v0 {
					v1 += self.selectedVariable.slider.step
				}
				self.setValue(float: v1)
			}

			row.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleTapGestureRecognizerOnRow(_:))))

			row.isHidden = true

			row0 = row
		}









		self.buttonValueInitial.addTapIfNotSelected(named: "action", deselect: 0.15) { [weak self] in
			guard let `self` = self else { return }
			self.selectedVariable.redosClear()
			self.setValue(float: self.selectedVariable.valueInitial)
		}

		self.buttonValueDefault.addTapIfNotSelected(named: "action", deselect: 0.15) { [weak self] in
			guard let `self` = self else { return }
			self.selectedVariable.redosClear()
			self.setValue(float: self.selectedVariable.valueDefault)
		}

		self.buttonValueUndo.addTapIfNotSelected(named: "action", deselect: 0.05) { [weak self] in
			guard let `self` = self else { return }
			if self.selectedVariable.undo() {
				//				self.setValue(float: self.property.value)
				self.updateUI()
			}
		}

		self.buttonValueRedo.addTapIfNotSelected(named: "action", deselect: 0.05) { [weak self] in
			guard let `self` = self else { return }
			if self.selectedVariable.redo() {
				//				self.setValue(float: self.property.value)
				self.updateUI()
			}
		}

		self.buttonValueHistoryClear.addTapIfNotSelected(named: "action", deselect: 0.15) { [weak self] in
			guard let `self` = self else { return }
			self.selectedVariable.historyClear()
			self.updateUI()
		}



		self.buttonPropertyPrev.addTapIfNotSelected(named: "action", deselect: 0.33) { [weak self] in
			guard let `self` = self else { return }
//			print(self.currentProperty.valueAsString)
			var index = self.currentPropertyIndex
			index -= 1
			if index < 0 {
				index = self.properties.indexForSafeLastElement
			}
			if index != self.currentPropertyIndex {
				self.currentPropertyIndex = index
				self.defineProperty()
			}
		}

		self.buttonPropertyNext.addTapIfNotSelected(named: "action", deselect: 0.33) { [weak self] in
			guard let `self` = self else { return }
//			print(self.currentProperty.valueAsString)
			var index = self.currentPropertyIndex
			index += 1
			index %= self.properties.count
			if index != self.currentPropertyIndex {
				self.currentPropertyIndex = index
				self.defineProperty()
			}
		}

		self.buttonPropertyCopy.addTapIfNotSelected(named: "action", deselect: 0.33) { [weak self] in
			guard let `self` = self else { return }

			self.clipboardForProperty = self.clipboardForProperty.filter({ $0.value != nil })

			self.clipboardForProperty = self.clipboardForProperty.filter({ $0.value?.kind != self.currentProperty.kind })

			let entry : WeakRef<Property> = WeakRef<Property>.init(self.currentProperty)

			self.clipboardForProperty.append(entry)

			self.updateUI()
		}

		self.buttonPropertyPaste.addTapIfNotSelected(named: "action", deselect: 0.33) { [weak self] in
			guard let `self` = self else { return }

			self.clipboardForProperty = self.clipboardForProperty.filter({ $0.value != nil })

			for entry in self.clipboardForProperty {
				guard let value = entry.value else {
					continue
				}
				if self.currentProperty.kind == value.kind {
					let variables = value.variablesForConfiguration(self.currentProperty.configuration)
					assert(variables.count == self.currentProperty.variables.count)
					for i in 0..<variables.count {
						self.currentProperty.variables[i].value = variables[i].value
					}
					self.defineProperty()
					break
				}
			}

			self.updateUI()
		}

		self.buttonPropertyInitial.addTapIfNotSelected(named: "action", deselect: 0.33) { [weak self] in
			guard let `self` = self else { return }

			for variable in self.variables {
				variable.register()
				variable.value = variable.valueInitial
			}

			self.defineProperty()
		}

		self.buttonPropertyDefault.addTapIfNotSelected(named: "action", deselect: 0.33) { [weak self] in
			guard let `self` = self else { return }

			for variable in self.variables {
				variable.register()
				variable.value = variable.valueDefault
			}

			self.defineProperty()
		}

		self.buttonCalibration.addTap(named: "action") { [weak self] in
			guard let `self` = self else { return }

			if self.isCalibrating {
				self.save(user: false, calibration:true)
			}

			self.buttonCalibration.isSelected.flip()

			self.definePropertyGroup()
		}

		self.buttonSave.addTapIfNotSelected(named: "action", deselect: 0.5) { [weak self] in

			guard let `self` = self else { return }

			self.save(user: true, calibration:true)
		}

		self.buttonMode.addTapIfNotSelected(named: "action", deselect: 0.5) { [weak self] in
			guard let `self` = self else { return }

			self.mode = self.modes.next
		}

		self.buttonStyle.addTapIfNotSelected(named: "action", deselect: 0.5) { [weak self] in

			guard let `self` = self else { return }

			let all = self.styles

			if let index = all.index(of: self.style) {
				let index1 = (index + 1) % all.count
				self.style = all[index1]
			} else {
				self.style = all[0]
			}
		}

		self.buttonStyleAdd.addTapIfNotSelected(named: "action", deselect: 0.5) { [weak self] in

			guard let `self` = self else { return }

			let vc = UIApplication.shared.keyWindow?.rootViewController

			vc?.presentAlertForInput(title		: "Style",
																					message		: "Add a new custom style",
																					value		: self.style,
																					ok			: "Add")
			{ style in

				let style = style.trimmed()

				if style.isEmpty {
					vc?.presentAlertForAnswer(title: "Invalid Style Name", message: "Style name is empty.")
				} else if self.userStyles.contains(style) || self.defaultStyles.contains(style) {
					vc?.presentAlertForAnswer(title: "Invalid Style Name", message: "Style name \"\(style)\" already exists.")
				} else {
					let manager0 = self.styleManager[self.style]!

					let manager1 = manager0.copy(key: "@/style/\(style)", cloneListeners: true)

					print("manager1 \(style) before store: \(manager1)")
					manager1.store()

					self.styleManager[style] = manager1

					self.add(manager: UICalibrator.PropertyGroup.init(title: manager1.key, variables: manager1.variables, store: { [weak manager1] in
						manager1?.store()
					}), calibration: true)

					self.userStyles = self.userStyles + [style]

					self.styles = self.defaultStyles + self.userStyles

					self.style = style
				}

			}


		}


		self.buttonForDemo.addTapIfNotSelected(deselect: 0.5) { [weak self] in

			guard let `self` = self else { return }

			switch self.currentProperty.kind
			{
			case .color, .font:

				switch self.demo {

				case .none:
					self.demo = .one
				case .one:
					self.demo = .two
				case .two:
					self.demo = .three
				case .three:
					self.demo = .four
				case .four:
					self.demo = .none
				}

			default:
				self.demo = .none
			}

		}

		self.buttonPropertyPrint.addTapIfNotSelected(named: "action", deselect: 0.5) { [weak self] in
			guard let `self` = self else { return }

			print(self.currentProperty.valueAsString)
		}

		self.buttonManagerPrint.addTapIfNotSelected(named: "action", deselect: 0.5) { [weak self] in
			guard let `self` = self else { return }

			self.properties.forEach {
				print($0.valueAsString)
			}
		}

		self.buttonManagerAdd.addTapIfNotSelected(named: "action", deselect: 0.5) { [weak self] in
			guard let `self` = self else { return }

			// hide pane
			// set mode to capture manager
			// let gesture recognizer detect tap on object and introspect a manager

			self.adding = true
		}

		self.buttonManagerPrev.addTapIfNotSelected(named: "action", deselect: 0.33) { [weak self] in
			guard let `self` = self else { return }
			var index = self.currentPropertyGroupIndex
			index -= 1
			if index < 0 {
				index = self.managers.indexForSafeLastElement
			}
			if index != self.currentPropertyGroupIndex {
				self.currentPropertyGroupIndex = index
				self.definePropertyGroup()
			}
		}

		self.buttonManagerNext.addTapIfNotSelected(named: "action", deselect: 0.33) { [weak self] in
			guard let `self` = self else { return }
			var index = self.currentPropertyGroupIndex
			index += 1
			index %= self.managers.count
			if index != self.currentPropertyGroupIndex {
				self.currentPropertyGroupIndex = index
				self.definePropertyGroup()
			}
		}





		for button in [buttonOperation1, buttonOperation2, buttonOperation3, buttonOperation4, buttonOperation5] {

			let label = UILabelWithInsets.init(frame: .zero)
			button?.addSubview(label)

			label.tag = TagForButtonOperationLabel

			label.constrainLeftToRight(of: button!, withMargin: 16/2)
			label.constrainCenterYToSuperview()
		}



		self.buttonOperation1.addTapIfNotSelected(named: "action", deselect: 0.33) { [weak self] in
			self?.operation1?.operation()
		}
		self.buttonOperation2.addTapIfNotSelected(named: "action", deselect: 0.33) { [weak self] in
			self?.operation2?.operation()
		}
		self.buttonOperation3.addTapIfNotSelected(named: "action", deselect: 0.33) { [weak self] in
			self?.operation3?.operation()
		}
		self.buttonOperation4.addTapIfNotSelected(named: "action", deselect: 0.33) { [weak self] in
			self?.operation4?.operation()
		}
		self.buttonOperation5.addTapIfNotSelected(named: "action", deselect: 0.33) { [weak self] in
			self?.operation5?.operation()
		}






		let TR = buttonExit!
		let TL = buttonManagerPrint!
		let BL = buttonPropertyPrint!
		let BR = buttonStyle!



		TR.constrainRightToSuperviewRight()?.extended(-8)
		TR.constrainTopToSuperviewTop()?.extended(+8)

		BL.constrainLeftToSuperviewLeft(withMargin: +8)
		BL.constrainBottomToSuperviewBottom(withMargin: -32)



		TR.constrainViewsCenterXToCenterX(for: [
			buttonMode,
			buttonCalibration,
			buttonSave,
			buttonStyle,
			buttonForDemo,
			buttonValueUndo,
			buttonValueInitial,
			buttonValueHistoryClear,
			buttonValueDefault,
			buttonValueRedo
			])
		TR.constrainViewsCenterYToCenterY(for: [
			buttonManagerPrint,
			buttonManagerPrev,
			buttonManagerNext,
			buttonManagerAdd,
			labelHeading,
			])
		TR.constrainViewsTopToBottom(for: [
			buttonMode,
			buttonForDemo,
			buttonCalibration,
			buttonSave
			], offset: 16)



		BL.constrainViewsCenterXToCenterX(for: [
			buttonManagerPrint,
			buttonOperation1,
			buttonOperation2,
			buttonOperation3,
			buttonOperation4,
			buttonOperation5,
			])
		BL.constrainViewsLeftToRight(for: [
			buttonPropertyPrev,
			buttonPropertyNext,
			buttonPropertyCopy,
			buttonPropertyPaste,
			buttonPropertyInitial,
			buttonPropertyDefault
			], offset: 16)
		BL.constrainViewsCenterYToCenterY(for: [
			buttonPropertyPrev,
			buttonPropertyNext,
			buttonPropertyCopy,
			buttonPropertyPaste,
			buttonPropertyInitial,
			buttonPropertyDefault,
			buttonStyle
			])



		TL.constrainViewsLeftToRight(for: [
			buttonManagerPrev,
			buttonManagerNext,
			buttonManagerAdd
			], offset: 16)



		viewForConfigurations.constrainCenterXToSuperview()
		viewForConfigurations.constrainCenterYToCenterY(of: BL, withMargin: -48)



		self.buttonValueHistoryClear.constrainCenterYToSuperview()
		self.buttonValueHistoryClear.constrainViewsBottomToTop(for: [buttonValueUndo, buttonValueInitial], offset: -16)
		self.buttonValueHistoryClear.constrainViewsTopToBottom(for: [buttonValueRedo, buttonValueDefault], offset: +16)



		buttonOperation3.constrainCenterYToSuperview()
		buttonOperation3.constrainViewsTopToBottom(for: [buttonOperation4, buttonOperation5], offset: +16)
		buttonOperation3.constrainViewsBottomToTop(for: [buttonOperation2, buttonOperation1], offset: -16)


		labelHeading.constrainCenterXToSuperview()

		labelPropertyTitle.constrainCenterXToSuperview()
		labelPropertyTitle.constrainCenterYToCenterY(of: BL)

		self.labelForDemo.lineBreakMode = .byWordWrapping
//		self.labelForDemo.constrainCenterXToSuperview()
//		self.labelForDemo.constrainCenterYToSuperview()
		self.labelForDemo.constrainTopToBottom(of: labelHeading, withMargin: 16)
		self.labelForDemo.constrainLeftToSuperviewLeft()?.extended(+16)
		self.labelForDemo.constrainRightToSuperviewRight()?.extended(-64+12)
//		self.labelForDemo.constrainWidthToSuperview()?.extended(-96)

		buttonStyle.constrainViewsCenterYToCenterY(for: [labelStyle, buttonStyleAdd])
		buttonStyle.constrainViewsRightToLeft(for: [buttonStyleAdd, labelStyle], offset: -16)


		

		add(group: "PROPERTY NAVIGATION", left: buttonPropertyPrev, right: buttonPropertyNext, top: buttonPropertyNext, bottom: buttonPropertyNext)






		pane.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleGestureRecognizerForTap(_:))))
		pane.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(handleGestureRecognizerForPan(_:))))





		registerViewAction(on: labelPropertyTitle) { [weak self] in

			guard let `self` = self else { return }

			self.presentPropertyList(properties	: self.properties.map { $0.title },
								selected		: self.currentProperty.title)
			{ [weak self] selected in

				guard let `self` = self else { return }

				if let selected = selected, selected != self.currentProperty.title {
					if let (index,_) = self.properties.enumerated().first(where: { $0.1.title == selected }) {
						self.currentPropertyIndex = index
						self.defineProperty()
					}
				}

			}

		}


		registerViewAction(on: labelHeading) { [weak self] in

			guard let `self` = self else { return }

			self.presentPropertyList(properties		: self.managers.map { $0.title },
									 selected		: self.currentPropertyGroup.title)
			{ [weak self] selected in

				guard let `self` = self else { return }

				if let selected = selected, selected != self.currentPropertyGroup.title {
					if let (index,_) = self.managers.enumerated().first(where: { $0.1.title == selected }) {
						self.currentPropertyGroupIndex = index
					}
				}

			}

		}


		registerViewAction(on: labelStyle) { [weak self] in

			guard let `self` = self else { return }

			self.presentPropertyList(properties		: self.styles,
									 selected		: self.style)
			{ [weak self] selected in

				guard let `self` = self else { return }

				if let selected = selected, selected != self.style {
					self.style = selected
				}

			}

		}



		//		self.pane.addObserver(self, forKeyPath: ".isHidden", options: [.new], context: nil)


		let style = UserDefaults.standard.string(forKey: "style") ?? defaultStyles.first!

		if self.styles.contains(style) {
			self.style = style
		} else {
			self.style = self.styles.first!
		}



		let mode = Mode.init(rawValue: UserDefaults.standard.string(forKey: "mode") ?? Mode.full.rawValue) ?? modes.next
		repeat {
			self.mode = modes.next
		} while self.mode != mode



		self.pane.isHidden = true

	}


	//	override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
	//		return !pane.isHidden || self.buttonExit.frame.contains(point) // self.buttonExit.point(inside:point, with: event)
	//	}


	public var obtainPropertyGroupForTap : ((_ recognizer: UITapGestureRecognizer?)->PropertyGroup?)!


	@objc func handleEventForSlider(_ source: UISlider?, event: UIControl.Event) {
		if let slider = source {
//			print("slider value=\(String(describing: slider.value))")
			let row = slider.tag
			selectRow(index: row)
			self.setValue(float: slider.value)
		}
	}


	@objc func handleTapGestureRecognizerOnRow(_ recognizer: UITapGestureRecognizer!) {

		if pane.isHidden {
			return
		}


		if mode != .transparent {
			//		print("tap: \(recognizer.debugDescription)")

			switch recognizer.state {

			case .began, .changed, .ended:

				if let index = recognizer.view?.tag {
					self.selectRow(index: index)
				}

			default:
				break
			}
		}

		if !pane.isHidden {
			//			recognizer.consu
		}
	}

	@objc func handleGestureRecognizerForTap(_ recognizer: UITapGestureRecognizer!) {

		if adding {

			switch recognizer.state {

			case .began, .changed, .ended:

				if let manager = obtainPropertyGroupForTap?(recognizer) {
					if self.add(manager: manager).isEmpty {
						print("can't add manager! \(manager.title)")
					}
				}

			default:
				break
			}

			self.adding = false

			return
		}

		if pane.isHidden {
			return
		}


		if mode == .transparent {
			//		print("tap: \(recognizer.debugDescription)")

			switch recognizer.state {

			case .began, .changed, .ended:
				if self.frame.width > 4 {
					let location = recognizer.location(in: self)
					let ratio = Float(location.x / (self.frame.width - 4))
					//					print("tap, location: \(location), ratio=\(ratio)")
					self.setValue01(ratio: ratio)
				}

			default:
				break
			}
		}

		if !pane.isHidden {
			//			recognizer.consu
		}
	}

	@objc func handleGestureRecognizerForPan(_ recognizer: UIPanGestureRecognizer!) {

		if pane.isHidden {
			return
		}

		if mode == .transparent {

			//			print("pan: \(recognizer.debugDescription)")

			switch recognizer.state {

			case .began, .changed, .ended:
				if 0 < self.frame.width {
					let location = recognizer.location(in: pane)
					let ratio = Float(location.x / (pane.frame.width - 4))
					//					print("pan, location: \(location), ratio=\(ratio)")
					self.setValue01(ratio: ratio)
				}

			default:
				break
			}

		}

		//		recognizer.cancelsTouchesInView = true

	}

	fileprivate func presentPropertyList(properties: [String], selected: String, completion: @escaping (String?) -> ()) {

		let bg = UIView()

		self.pane.addSubview(bg)

		bg.isOpaque = false
		bg.backgroundColor = UIColor.init(white: 0.2, alpha: 0.3)
		bg.constrainToSuperview()

		let table = UICalibratorPropertyList.init(properties				: properties,
												   selected					: selected,
												   colorBackground 			: colorForButtonFill.withAlphaComponent(0.8),
												   colorBackgroundSelected	: colorForButtonBackgroundSelected,
												   colorTextSelected		: colorForButtonTextSelected,
												   colorText				: colorForButtonText,
												   fontText					: fontForButton,
												   fontTextSelected			: fontForButton)
		{ selected in

			bg.removeFromSuperview()

			completion(selected)
		}

		bg.addSubview(table)

		table.constrainToSuperview(withMargins: .init(tlbr: [64,64,-64,-64]))
		table.contentInset = .init(tlbr: [16,16,8,-16])
	}

	fileprivate func add(group name: String, left: UIView, right: UIView, top: UIView, bottom: UIView) {
		let group = UIView.init()
		group.tag = 473
//		group.put("group.name", name)

		self.pane.insertSubview(group, at: 1)

		let band = 0 //bandForGroup

		let radius = 0 //radiusForButton

		group.constrainLeftToLeft(of: left) //, withMargin: -band - radius)
		group.constrainRightToRight(of: right) //, withMargin: band + radius)
		group.constrainTopToTop(of: top) //, withMargin: -band - radius)
		group.constrainBottomToBottom(of: bottom) //, withMargin: band + radius)

		group.cornerRadius = radiusForButton // radius + band
	}








	private var viewActions : [UIView? : ()->()] = [:]

	func registerViewAction(on view: UIView, action: (()->())?) {

		view.gestureRecognizers?.forEach {
			view.removeGestureRecognizer($0)
		}
		if let action = action {
			view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleGestureRecognizerOnViews(_:))))
			view.isUserInteractionEnabled=true

			viewActions[view] = action
		} else {
			viewActions.removeValue(forKey: view)
		}
	}

	@objc func handleGestureRecognizerOnViews(_ recognizer: UIPanGestureRecognizer!) {

		if pane.isHidden {
			return
		}

		if mode != .transparent {

			//			print("pan: \(recognizer.debugDescription)")

			switch recognizer.state {

			case .ended:

				viewActions[recognizer.view]?()

			default:
				break
			}

		}

		//		recognizer.cancelsTouchesInView = true

	}





	var layoutconstraints : [NSLayoutConstraint?] = []






	func doLayoutForModeFull() {

		let count = variables.count
		for (index,row) in sliderRows.enumerated() {
			if index < count {
				row.isHidden = true
			} else {
				break
			}
		}
		pane.subviews.forEach {
			$0.isHidden = false
		}
		self.updateUI()
	}

	func doLayoutForModeTransparent() {

		NSLayoutConstraint.deactivate(layoutconstraints.compactMap { $0 })

		layoutconstraints = [
		]

		pane.subviews.forEach {
			$0.isHidden = $0 != buttonMode
		}

		self.updateUI()
	}







	public class Variable {

		public typealias Listener = ()->()
		public typealias Converter = (Float)->String

		public var title 		: String = ""
		public var slider 		: ConfigurationForSlider
		public var converter 	: Converter
		public var listener		: Listener!
		public var value 		: Float {
			get {
				return valueGetter?() ?? __value
			}
			set {
				valueSetter?(newValue)
				__value = newValue
				listener?()
			}
		}
		private var __value : Float = 0

		public typealias Getter = ()->Float?
		public typealias Setter = (Float)->()

		public var redefine		= false
		public var valueGetter	: Getter!
		public var valueSetter	: Setter!

		public var valueInitial	: Float
		public var valueDefault	: Float

		public init(title: String, slider: ConfigurationForSlider, getter: Getter? = nil, setter: Setter? = nil, listener: Listener! = nil, converter: @escaping Converter = { String($0) }) {
			self.title 			= title
			self.slider 		= slider
			self.listener 		= listener
			self.converter 		= converter
			self.valueDefault 	= slider.`default`
			self.valueInitial 	= slider.initial
			self.valueGetter 	= getter
			self.valueSetter 	= setter
			self.__value 		= slider.initial
		}

		private(set) var undos : [Float] = []
		private(set) var redos : [Float] = []

		func undo() -> Bool {
			if let v = undos.last {
				redos.append(value)
				undos.removeLast()
				value = v
				return true
			}
			return false
		}

		func redo() -> Bool {
			if let v = redos.last {
				undos.append(value)
				redos.removeLast()
				value = v
				return true
			}
			return false
		}

		@discardableResult
		func register() -> Bool {
			if undos.isEmpty || undos.last! != value {
				self.undos.append(value)
				return true
			}
			return false
		}

		func historyClear() {
			undos = []
			redos = []
		}

		func redosClear() {
			redos = []
		}
	}



	@discardableResult
	public func add(manager: PropertyGroup, calibration: Bool = false) -> [Variable] {
		let managers : ManagerOfPropertyGroups
		if calibration {
			managers = managersForCalibration
		} else {
			managers = managersForUser
		}

		guard managers.array.index(where: { $0.title == manager.title }) == nil else {
			return []
		}
		managers.array.append(manager)
		manager.store()
		managers.currentIndex = managers.array.indexForSafeLastElement
		if isCalibrating == calibration {
			definePropertyGroup()
		}
		return variables
	}

	@discardableResult
	public func add(title: String, properties: [Property], store:@escaping ()->() = { }) -> [Variable] {
		return add(manager: PropertyGroup.init(title: title, properties: properties, store: store))
	}

	@discardableResult
	public func add(title: String, variables: [StorableVariable], truncatePrefix: String? = nil, store:@escaping ()->() = { }) -> [Variable] {
		return add(manager: PropertyGroup.init(title: title, properties: [
			Property.from(key: title, storableVariables: variables, truncatePrefix: truncatePrefix)
			], store: store))
	}





	public class PropertyGroup {
		let title 			: String
		var properties 		: [Property]
		var selectedIndex	: Int = 0

		public init(title: String, properties: [Property], store:@escaping ()->() = { }) {
			self.title = title
			self.properties = properties
			self.store = store
		}

		public init(title: String, variables: [StorableVariable], store:@escaping ()->() = { }) {
			self.title = title
			self.properties = variables.map { Property.from(storableVariable: $0) }
			self.store = store
		}

		var store : ()->()
	}




	static private let defaultPropertyGroup			= PropertyGroup.init(title: "???", properties: [UICalibrator.defaultProperty], store: { } )




	var isCalibrating : Bool {
		return buttonCalibration.isSelected
	}

	private var currentManagerOfPropertyGroups : ManagerOfPropertyGroups {
		get {
			if isCalibrating {
				return managersForCalibration
			} else {
				return managersForUser
			}
		}
	}

	private var currentPropertyGroupIndex		: Int {
		get {
			return currentManagerOfPropertyGroups.currentIndex
		}
		set {
			currentManagerOfPropertyGroups.currentIndex = newValue
			definePropertyGroup()
		}
	}






	class ManagerOfPropertyGroups {

		var array : [PropertyGroup] = [] {
			didSet {
				array.sort {
					$0.title < $1.title
				}
				currentIndex = 0
			}
		}
		var currentIndex = 0

		func store() {
			array.forEach { $0.store() }
		}
	}

	private var managersForCalibration	= ManagerOfPropertyGroups()

	private var managersForUser			= ManagerOfPropertyGroups()

	private var managers				: [PropertyGroup] {
		get {
			return currentManagerOfPropertyGroups.array
		}
		set {
			currentManagerOfPropertyGroups.array = newValue
		}
	}

	private var currentPropertyGroup			: PropertyGroup! {
		return managers[safe: currentPropertyGroupIndex] ?? UICalibrator.defaultPropertyGroup
	}

	private var properties				: [Property] = [UICalibrator.defaultProperty] {
		didSet {
			currentPropertyIndex = 0
//			self.defineProperty()
		}
	}

	private var variables 				: [Variable] {
		return currentProperty.variables
	}

	private var selectedVariableIndex 	: Int {
		return currentProperty.selectedIndex
	}

	private var selectedVariable 		: Variable {
		return variables[selectedVariableIndex]
	}

	private var currentPropertyIndex 	: Int = 0 {
		didSet {
			currentPropertyGroup.selectedIndex = currentPropertyIndex
		}
	}

	private var currentProperty			: Property {
		return properties[currentPropertyIndex]
	}

	private var currentSliderRow		: SliderRow {
		return sliderRows[selectedVariableIndex]
	}

	static private var defaultProperty = Property.init(kind: .float, title: "Default", valuator: { nil }, configurations: ["N/A"]) { configuration in
		return [Variable.init(title: "n/a", slider: .init(initial: 0, default: 0, min: 0, max: 1, step: 1, snap: true), converter: { _ in "?" })]
	}



	open func variable(with title:String) -> Variable? {
		return self.variables.compactMap { $0 }.first(where: { $0.title == title })
	}


	open func define(properties: [Property]) {
		self.properties = properties.isEmpty ? [UICalibrator.defaultProperty] : properties
	}

	open func define(operation: Int) {

		var button : UIButtonWithCenteredCircle!
		var title : String!

		switch operation {
		case 1:
			button = operation1 == nil ? nil : buttonOperation1
			title = operation1?.title
		case 2:
			button = operation2 == nil ? nil : buttonOperation2
			title = operation2?.title
		case 3:
			button = operation3 == nil ? nil : buttonOperation3
			title = operation3?.title
		case 4:
			button = operation4 == nil ? nil : buttonOperation4
			title = operation4?.title
		case 5:
			button = operation5 == nil ? nil : buttonOperation5
			title = operation5?.title
		default:
			break
		}

		let on = button != nil

		button?.isVisible = on
		if on, let label = button?.subview(withTag: TagForButtonOperationLabel) as? UILabelWithInsets, let title = title {
			label.attributedText = title | fontForLabel | colorForLabelText
		}

	}



	fileprivate func updateUIPropertyConfigurations() {

		viewForConfigurations.removeAllSubviews()

		if currentProperty.configurations.count < 2 {
			return
		}

		viewForConfigurations.axis = .horizontal
		viewForConfigurations.alignment = .center
		viewForConfigurations.distribution = .equalSpacing
		viewForConfigurations.spacing = 16

		for (index,configuration) in currentProperty.configurations.enumerated() {

			let button = UIButton.init()

			viewForConfigurations.addArrangedSubview(button)

			button.isSelected = currentProperty.configurationIndex == index
			button.setTitle(configuration, for: .normal)
			button.setTitle(configuration, for: .selected)

			updateUIPropertyConfigurationButton(button)

			if !button.isSelected {

				button.addTapIfNotSelected() { [weak self] in

					guard let `self` = self else { return }

					self.currentProperty.configurationIndex = index

					self.variables.forEach {
						$0.redefine = true
					}
					
					self.defineProperty()
				}

			}
		}

		viewForConfigurations.setNeedsLayout()
	}

	private func defineProperty() {

		informWillDefineProperty?()

		sliderRows.forEach {
			$0.isHidden = true
		}

		self.animated = true

		for (index,variable) in variables.enumerated() {

			let row = sliderRows[index]
//			print("DEFINE GROUP: property \(property.title) value=\(property.value)")
			define(row: row, variable: variable)

			row.isHidden = false || mode == .transparent

//			row.labelValue.gestureRecognizers?.forEach {
//				row.labelValue.removeGestureRecognizer($0)
//			}

			var action : (()->())? = nil

			if row.isVisible {

				let property = currentProperty

				switch property.kind {

				case .color, .float, .array:

						action = { [weak self, weak row, weak variable, weak property] in

							guard let `self` = self else { return }
//							guard let row = row else { return }
							guard let variable = variable else { return }

							self.selectRow(index: index)

							self.root?.presentAlertForInput(title		: variable.title,
															message		: "Enter new value",
															value		: variable.converter(variable.value))
							{ string in
								if let v = Float(string.trimmed()) {
									self.setValue(float: v, row: index)
								}
							}
						}

				case .font:
					fallthrough

				default:
					break
				}

				if false {
					registerViewAction(on: row.labelValue) { [weak self, weak row, weak variable, weak property] in

						guard let `self` = self else { return }
						guard let row = row else { return }
						guard let variable = variable else { return }
						guard let property = property else { return }

						self.presentPropertyList(properties		: self.properties.map { $0.title },
												 selected		: self.currentProperty.title)
						{ [weak self] selected in

							guard let `self` = self else { return }

							if let selected = selected, selected != self.currentProperty.title {
								if let (index,_) = self.properties.enumerated().first(where: { $0.1.title == selected }) {
									self.currentPropertyIndex = index
									self.defineProperty()
								}
							}

						}
					}
				}

				registerViewAction(on: row.labelValue, action: action)
			}
		}

		selectRow(index: selectedVariableIndex)

		self.animated = false
		

		updateUIPropertyConfigurations()


		labelPropertyTitle.attributedText = currentProperty.title | fontForLabel | colorForLabelText

		self.updateLabelForDemo()

		self.setNeedsLayout()

		informDidDefineProperty?()
	}

	private func define(row: SliderRow!, variable: Variable, setValue: Bool = true) {

		row.labelTitle.attributedText = variable.title | colorForLabelText | fontForLabel
		row.labelTitle.sizeToFit()

		row.slider.tintColor 	= .white

		row.slider.minimumValue = variable.slider.min
		row.slider.maximumValue = variable.slider.max
		row.slider.isContinuous = false

//		print("current slider: \(row.index) = \(property.slider.max) ~ \(row.slider.maximumValue)")

//		print("define: \"\(property.title)\" - property.value=\(property.value)")
		if setValue {
			self.setValue(float: variable.value, row: row, variable: variable)
		}

		row.setNeedsLayout()
	}

	private func definePropertyGroup() {
		informWillDefineProperty?()
		self.set(heading: currentPropertyGroup.title)
		let index = self.currentPropertyGroup.selectedIndex
		self.properties = self.currentPropertyGroup.properties
		self.currentPropertyIndex = index
		self.defineProperty()
		informDidDefinePropertyGroup?()
	}

	func set(heading: String) {
		self.labelHeading.attributedText = heading | UIColor.init(white: 0, alpha: 1) | FONT
		self.labelHeading.sizeToFit()
	}

	private func setValue01(ratio: Float) {
		let float = currentSliderRow.slider.minimumValue + (currentSliderRow.slider.maximumValue - currentSliderRow.slider.minimumValue) * ratio
		//		print("ratio: \(ratio), float: \(float)")
		setValue(float: float)
	}

	private func setValue(float: Float) {
		setValue(float: float, row: currentSliderRow, variable: selectedVariable)
	}

	private func setValue(float: Float, row index: Int) {
		setValue(float: float, row: sliderRows[index], variable: variables[index])
	}

	private func setValue(float: Float, row: SliderRow, variable: Variable) {
//		print("setValue: 0 float: \(float)")
		let value0 : Float
		if variable.slider.circular {
			if float < variable.slider.min {
				value0 = variable.slider.max
			} else if float > variable.slider.max {
				value0 = variable.slider.min
			} else {
				value0 = float
			}
		} else {
			value0 = max(row.slider.minimumValue, min(row.slider.maximumValue, float))
		}
//		print("setValue: 1 float: \(float), value0: \(value0)")
		var value1 = variable.slider.snap ? snap(value: value0, variable: variable) : value0
		value1 = min(value1, variable.slider.max)
		value1 = max(value1, variable.slider.min)
		variable.register()
		variable.value = value1
//		print("setValue: 2 float: \(float), value1: \(value1), value:\(property.value)")
		updateUI(row: row, variable: variable)
		for (index,variable) in variables.enumerated() {
			if variable.redefine {
				variable.redefine = false
				let row = sliderRows[index]
				define(row: row, variable: variable, setValue: false)
				updateUI(row: row, variable: variable)
			}
		}
		updateLabelForDemo()
	}

	private func updateUI(row: SliderRow, variable: Variable) {

		let value = variable.value

		row.slider.minimumValue = variable.slider.min
		row.slider.maximumValue = variable.slider.max

		if mode == .full {
			row.buttonValueIncrement.isHidden = variable.slider.step == 0
			row.buttonValueDecrement.isHidden = variable.slider.step == 0
			row.buttonValueDecrement.isEnabled = value > row.slider.minimumValue || variable.slider.circular
			row.buttonValueIncrement.isEnabled = value < row.slider.maximumValue || variable.slider.circular
			if row == currentSliderRow {
				self.buttonValueUndo.isEnabled = variable.undos.isNotEmpty
				self.buttonValueRedo.isEnabled = variable.redos.isNotEmpty
				self.buttonValueHistoryClear.isEnabled = self.buttonValueUndo.isEnabled || self.buttonValueRedo.isEnabled
			}
		}

		self.buttonManagerPrev.isEnabled = self.managers.count > 1
		self.buttonManagerNext.isEnabled = self.managers.count > 1

		self.buttonPropertyPrev.isEnabled = self.properties.count > 1
		self.buttonPropertyNext.isEnabled = self.properties.count > 1

		let canPaste : ()->Bool = {
			for entry in self.clipboardForProperty {
				if entry.value?.kind == self.currentProperty.kind {
					return true
				}
			}
			return false
		}

		self.buttonPropertyPaste.isEnabled = canPaste()

//		print("current slider: \(row.index) = \(property.slider.max) ~ \(row.slider.maximumValue)")

		row.slider.setValue(value, animated: animated)

		let string = variable.converter(value)

		row.labelValue.attributedText = string | colorForLabelText | fontForLabel
		row.labelTitle.attributedText = variable.title | colorForLabelText | fontForLabel

		self.listener(.update(variable.title, string))
	}



	private func updateUI() {

		sliderRows.forEach {
			$0.isHidden = true
		}

		if mode != .transparent && !adding {

			for (index,variable) in variables.enumerated() {

				sliderRows[index].isHidden = false || mode == .transparent

				updateUI(row: sliderRows[index], variable: variable)
			}

			selectRow(index: selectedVariableIndex)

			self.buttonOperation1.isHidden = self.operation1 == nil
			self.buttonOperation2.isHidden = self.operation2 == nil
			self.buttonOperation3.isHidden = self.operation3 == nil
			self.buttonOperation4.isHidden = self.operation4 == nil
			self.buttonOperation5.isHidden = self.operation5 == nil
		}

	}


	private func selectRow(index: Int) {

		let index0 = currentProperty.selectedIndex

		sliderRows.forEach { $0.backgroundColor = nil }
		sliderRows[index].backgroundColor = UIColor.init(white: 1, alpha: 0.1)

//		print("new selected row index: \(index)")

		if index0 != index {
			currentProperty.selectedIndex = index
		}
	}


}




extension UICalibrator {


	public class func create(heading: String? = nil, listener: @escaping Listener) -> UICalibrator {
		let r = UICalibrator.init(heading: heading, listener: listener)
		return r
	}

	public class func create(on view: UIView, listener: @escaping Listener) -> UICalibrator {

		let editor = UICalibrator.create(listener: listener)

		view.addSubview(editor)

		editor.constrainToSuperview()

		return editor
	}

}



extension UICalibrator {

	open func value(variable vkey: String, property pkey: String, group gkey: String) -> Any? {
		for group in managersForUser.array + managersForCalibration.array {
			if group.title == gkey {
				for property in group.properties {
					if property.title == pkey {
						for variable in property.variables {
							if variable.title == vkey {
								// TODO
//								return variable.objectFromValue(variable.value)
							}
						}
					}
				}
			}
		}

		return nil
	}
}



// TODO
// CONSUME/BLOCK UI EVENTS
// /PROPERTY PIN/UNPIN
// /PROPERTY TITLE/VALUE/SLIDE-LABEL .. "SLIDE LABEL" "CUSTOM SLIDER"?
// /MODE CUSTOM MODE ARRAY .. "ROTATING/CIRCULAR QUEUE"
// /MOVE UP/DOWN
// STEP MODE ONLY? CREATE A 1/100 STEP FOR UNSTEPPED PROPERTIES, HAVE NO SLIDER JUST -+ BUTTONS
//

extension NSObject {

	convenience init(initializer: (NSObject)->()) {
		self.init()
		initializer(self)
	}
}

// TODO
// -VARIABLES FOR STYLE LABELS
// -ADD COPY/PASTE BUTTONS?  COPY/PASTE PROPERTY VALUE(S)
// -SLIDER SUITE - HSVA, WA, RGBA, FN-FS, "REPRESENTATION" BUTTON TOGGLE?
// -BUTTON LABELS?
// -TAP ON UI ITEM, RECEIVE VARIABLE-MANAGER
// -SWITCH MANAGERS BUTTONS NEXT/PREV
// -LABEL-BUTTON?  N-PLY?  1, 2, 3, .. ETC .. N-PLY BUTTON?

// TODO 2019.6.25

//  -UPDATE ICONS UNDO/REDO/CLEAR/DEFAULT/INITIAL

//  -ADD + BUTTON
//  -MOVE EXIT/PRINT BUTTONS, ADD PROPERTY-MANAGER NEXT/PREV BUTTONS IF AT LEAST TWO MANAGERS EXIST
//  -DO MIRROR, HIDE PANE, TAP, INTROSPECT, FORM MANAGER OF VARIABLES
//  -CREATE PROTOCOL FOR HAVING STORED VARIABLES

// PropertyGroups => PropertyManager
// PropertyGroup => Property => Property, propertyGroup => property => property
// Property => YYYY => Variable, property => yyyy => variable
// Variable => ZZZZ => Property, variable => zzzz => property
//

// TODO
//  ADD @ BUTTON TO MODIFY CALIBRATOR PROPERTIES @
//  + STYLE BUTTON DISPLAYS A TEXT INPUT DIALOG
// 	RENAME AS UICALIBRATOR
//  BUILDING SETS, FACE SETS, LAYOUT SETS, MODEL TREE
//  TABLE-ADD FILTER SEARCH FIELD
//  TRANSFORM MANAGERS/PROPERTIES/STYLES INTO A TABLE-SELECTION?
//  ADD FILTER CAPABILITY TO STRING VARIABLE

// DONE //TODO EACH LABEL THAT CAN BE SET SHOULD HAVE A BORDER AROUND IT, MANAGER/PROPERTY/VARIABLE-VALUE, OTHERS - NO
// 1/2 //TODO POPUP INPUT DIALOG WHEN TAPPING ON VARIABLE VALUE TEXT LABEL TO SET PRECISELY VALUE, USING BUTTON VISUAL PROPERTIES
// DONE //TODO ADD 'D' / DEFAULT AND 'I' / INITIAL BUTTONS TO PROPERTY, AFTER PASTE BUTTON, AND SET EACH VARIABLE OF PROPERTY TO DEFAULT/INITIAL VALUE
// DONE //TODO ADD 'STORE' BUTTON TO SAVE TO PERSISTENT STATE
// TODO SOME BUTTONS LIKE PRINT AND PASTE HAVE SAME TEXT
// TODO ADD CALIBRATION SETTING FOR LAYOUT OFFSET/MARGIN
// TODO ADD SUPPORT FOR SLIDER TAP
// TODO ADD SUPPORT FOR STRING VARIABLE FILTER, STRING VARIABLE DIALOG INPUT
// TODO ADD SUPPORT FOR SLIDER MARKINGS ON/OFF (TAP ON TITLE LABEL?)
// TODO ADD FILTER BAR TO PROPERTY LIST TABLE
// TODO ADD CLOSE BUTTON TO PROPERTY LIST TABLE

// TODO VARIABLE STEPPING THROUGH A RANGE OF A VARIABLE .. EX. TIME BETWEEN 1 AND 3 WILL BE STEPPED BY 0.1, OTHERWISE BY 1

// TODO ADD BACKGROUND VIEW/SHADE TO SLIDERS JUST LIKE BG COLOR OF LABELS .. PERHAPS ENTIRE ROW?
