//
//  StorableVariable.swift
//  ASToolkit
//
//  Created by andrzej on 5/14/19.
//  Copyright © 2019 Andrzej Semeniuk. All rights reserved.
//

import Foundation


private func log(_ error: Error, file: String = #file, line: Int = #line) {
	print("\(file):\(line):error: \(error)")
}

private func log(_ string: String, file: String = #file, line: Int = #line) {
	print("\(file):\(line): \(string)")
}



open class StorableVariable : Codable {



	public class VariableForUIColor : Codable {

		//		public struct Value : Codable {
		//			var h,s,b,a : Float
		//
		//			public mutating func fromUIColor(_ color: UIColor) {
		//				let hsba = color.HSBA
		//				self.h = Float(hsba.hue)
		//				self.s = Float(hsba.saturation)
		//				self.b = Float(hsba.brightness)
		//				self.a = Float(hsba.alpha)
		//			}
		//
		//			public func toUIColor() -> UIColor {
		//				return UIColor.init(hsba: [CGFloat(h),CGFloat(s),CGFloat(b),CGFloat(a)])
		//			}
		//		}

		public class Value : Codable, CustomDebugStringConvertible {

			public var debugDescription: String {
				return "rgba=(\(r),\(g),\(b),\(a))"
			}

			var r,g,b,a : Float

			public init(r: Float, g: Float, b: Float, a: Float = 1) {
				self.r = r
				self.g = g
				self.b = b
				self.a = a
			}

			public func fromUIColor(_ color: UIColor) {
				let rgba = color.RGBA
				self.r = Float(rgba.red)
				self.g = Float(rgba.green)
				self.b = Float(rgba.blue)
				self.a = Float(rgba.alpha)
			}

			public func toUIColor() -> UIColor {
				return UIColor.init(rgba: [CGFloat(r),CGFloat(g),CGFloat(b),CGFloat(a)])
			}

			public var color : UIColor {
				return toUIColor()
			}
			public var hsba : UIColor.HSBATuple {
				return toUIColor().HSBA
			}
			public var wa : (w: Float, a: Float) {
				return (w: Float((r+b+g)/3.0), a: a)
			}

			public static func from(w: Float, a: Float = 1) -> Value {
				return .init(r: w, g: w, b: w, a: a)
			}
			public static func from(constant c: Float) -> Value {
				return .init(r: c, g: c, b: c, a: c)
			}
			public static func from(rgba: [Float]) -> Value {
				return .init(r: rgba[0], g: rgba[1], b: rgba[2], a: rgba[3])
			}
			public static func from(color: UIColor) -> Value {
				return .from(rgba: color.arrayOfRGBA.map { Float($0) })
			}
			public static var zero : Value = {
				return .from(constant:0)
			}()
			public static var one : Value = {
				return .from(constant:1)
			}()
			public static var white : Value = {
				return .from(constant:1)
			}()
			public static var black : Value = {
				return .from(w:0, a:1)
			}()
		}

		public var value		: Value {
			didSet {
				if  value.r < min.r || value.r > max.r ||
					value.g < min.g || value.g > max.g ||
					value.b < min.b || value.b > max.b ||
					value.a < min.a || value.a > max.a
				{
					value.r = Swift.max(min.r,Swift.min(max.r,Float(value.r)))
					value.g = Swift.max(min.g,Swift.min(max.g,Float(value.g)))
					value.b = Swift.max(min.b,Swift.min(max.b,Float(value.b)))
					value.a = Swift.max(min.a,Swift.min(max.a,Float(value.a)))
					let v = value
					value = v
				} else {
					listener?(value)
				}
			}
		}
		public var `default`	: Value
		public var min			: Value = .init(r: 0, g: 0, b: 0, a: 0)
		public var max			: Value = .init(r: 1, g: 1, b: 1, a: 1)



		public typealias Listener = ((Value)->())

		public var listener		: Listener!

		private enum CodingKeys : String, CodingKey {
			case value, `default`, min, max
		}




		public init(value: Value, default: Value, min: Value, max: Value, listener: Listener? = nil) {
			self.value = value
			self.default = `default`
			self.min = min
			self.max = max
			self.listener = listener
		}

		public func fromUIColor(_ color: UIColor) {
			value.fromUIColor(color)
			value.r = Swift.max(min.r,Swift.min(max.r,Float(value.r)))
			value.g = Swift.max(min.g,Swift.min(max.g,Float(value.g)))
			value.b = Swift.max(min.b,Swift.min(max.b,Float(value.b)))
			value.a = Swift.max(min.a,Swift.min(max.a,Float(value.a)))
			let v = value
			value = v
		}

		public func toUIColor() -> UIColor {
			return value.toUIColor()
		}

		public func valueAssignRGBA(r: Float? = nil, g: Float? = nil, b: Float? = nil, a: Float? = nil) {
			let v0 = value
			v0.r ?= r
			v0.g ?= g
			v0.b ?= b
			v0.a ?= a
			value = v0
		}

		public func valueAssignHSBA(h: Float? = nil, s: Float? = nil, b: Float? = nil, a: Float? = nil) {
			var v0 = value.hsba
			if let h = h { v0.hue = CGFloat(h) }
			if let s = s { v0.saturation = CGFloat(s) }
			if let b = b { v0.brightness = CGFloat(b) }
			if let a = a { v0.alpha = CGFloat(a) }
			self.fromUIColor(UIColor.init(HSBA: v0))
		}

		public static func from(value	: Value,
								default	: Value? = nil,
								min		: Value = .zero,
								max		: Value = .one,
								listener: Listener? = nil) -> VariableForUIColor {
			return .init(value: value, default: `default` ?? value, min: .zero, max: .one, listener: listener)
		}

		public static var white: VariableForUIColor {
			return .init(value: .white, default: .white, min: .zero, max: .one)
		}

		public static var black: VariableForUIColor {
			return .init(value: .black, default: .black, min: .zero, max: .one)
		}

		public static func from(color	: UIColor,
								default	: UIColor? = nil,
								min		: Value = .zero,
								max		: Value = .one,
								listener: Listener? = nil) -> VariableForUIColor {
			return .init(value: .from(color: color), default: .from(color: `default` ?? color), min: min, max: max, listener: listener)
		}

		public static func from(binding	: UnsafeMutablePointer<UIColor>,
								default	: UIColor? = nil,
								min		: Value = .zero,
								max		: Value = .one,
								listener: Listener? = nil) -> VariableForUIColor {

			return .init(value		: .from(color: binding.pointee),
						 default	: .from(color: `default` ?? binding.pointee),
						 min		: min,
						 max		: max,
						 listener	: { v in
							binding.pointee = v.toUIColor()
							listener?(v)
			})
		}

	}




	public class VariableForUIFont : Codable {

		public class Value : Codable, CustomDebugStringConvertible {

			public var debugDescription: String {
				return "font=(\(name),\(size))"
			}

			public var name			: String
			public var size			: Float
			//			public var range		: [CGFloat]?

			public init(name: String, size: Float) {
				self.name = name
				self.size = size
			}

			public func toUIFont() -> UIFont? {
				return UIFont.init(name: name, size: CGFloat(abs(size)))
			}
			public func fromUIFont(_ font: UIFont) {
				self.name = font.fontName
				self.size = Float(font.pointSize)
			}

			static public func from(font: UIFont) -> Value {
				return Value.init(name: font.fontName, size: Float(font.pointSize))
			}
		}

		public var value		: Value {
			didSet {
				if value.size < min {
					value.size = min
				}
				if value.size > max {
					value.size = max
				}
				self.listener?(value)
			}
		}
		public var `default`		: Value
		public var families2names	: [String : [String]]
		public var min				: Float
		public var max 				: Float
		public var step 			: Float



		public typealias Listener = ((Value)->())

		public var listener		: Listener!

		private enum CodingKeys : String, CodingKey {
			case value, `default`, families2names, min, max, step
		}



		public init(value: Value,
					`default`: Value,
					families2names: [String : [String]],
					min: Float,
					max: Float,
					step: Float = 1, listener: Listener? = nil)
		{
			self.value = value
			self.default = `default`
			self.families2names = families2names
			self.min = Swift.min(min, Swift.min(`default`.size, value.size))
			self.max = Swift.max(max, Swift.max(`default`.size, value.size))
			self.step = step
			self.listener = listener
		}

		public func valueAssign(name: String? = nil, size: Float? = nil) {
			let v0 = value
			v0.name ?= name
			v0.size ?= size
			value = v0
		}

		public static func from(value	: Value,
								families2names	: [String : [String]],
								min				: Float,
								max				: Float,
								step			: Float = 1,
								listener		: Listener? = nil) -> VariableForUIFont
		{
			return VariableForUIFont.init(value			: value,
										  default  		: value,
										  families2names	: families2names,
										  min				: min,
										  max				: max,
										  step				: step,
										  listener			: listener)
		}

		public static func from(font			: UIFont,
								families2names	: [String : [String]],
								min				: Float,
								max				: Float,
								step			: Float = 1,
								listener		: Listener? = nil) -> VariableForUIFont
		{
			return VariableForUIFont.init(value			: .from(font: font),
										  default			: .from(font: font),
										  families2names	: families2names,
										  min      		: min,
										  max      		: max,
										  step				: step,
										  listener			: listener)
		}

		public static func from(binding			: UnsafeMutablePointer<UIFont>,
								default			: UIFont? = nil,
								families2names	: [String : [String]] = UIFont.familiesAndNames,
								min				: Float = 1,
								max				: Float = 256,
								step			: Float = 1,
								listener		: Listener? = nil) -> VariableForUIFont
		{
			return VariableForUIFont.init(value	: .from(font: binding.pointee),
										  default	: .from(font: `default` ?? binding.pointee),
										  families2names	: families2names,
										  min		: min,
										  max		: max,
										  step     : step,
										  listener	: { v in
											if let font = v.toUIFont() {
												binding.pointee = font
											}
											listener?(v)
			})
		}


		public func toUIFont() -> UIFont! {
			return value.toUIFont()
		}


	}




	public class VariableForFloat : Codable {

		public var value		: Float {
			didSet {
				listener?(value)
			}
		}
		public var `default`	: Float
		public var min			: Float
		public var max			: Float
		public var step			: Float

		public var isStepped	: Bool { return step != 0 }
		public var isSnappy		: Bool { return step > 0 }



		public typealias Listener = ((Float)->())

		public var listener		: Listener!

		private enum CodingKeys : String, CodingKey {
			case value, `default`, min, max, step
		}




		public init(value: Float, default: Float? = nil, min: Float, max: Float, step: Float, listener: Listener? = nil) {
			self.value = value
			self.default = `default` ?? value
			self.min = min
			self.max = max
			self.step = step
			self.listener = listener
		}

		static public func from(flag: Bool, default: Bool? = nil, listener: Listener? = nil) -> VariableForFloat {
			return .init(value: flag ? 1 : 0, default: (`default` ?? flag) ? 1 : 0, min: 0, max: 1, step: 1, listener: listener)
		}

		static public func from(binding	: UnsafeMutablePointer<Float>,
								default	: Float? = nil,
								min		: Float,
								max		: Float,
								step    : Float,
								listener: Listener? = nil) -> VariableForFloat {

			return .init(value		: binding.pointee,
						 default	: `default` ?? binding.pointee,
						 min		: min,
						 max		: max,
						 step       : step,
						 listener	: { v in
							binding.pointee = v
							listener?(v)
			})
		}


	}


	public class VariableForString : Codable {

		public var value		: String {
			didSet {
				listener?(value)
			}
		}
		public var `default`	: String
		public var allowable	: [String]



		public typealias Listener = ((String)->())

		public var listener		: Listener!

		private enum CodingKeys : String, CodingKey {
			case value, `default`, allowable
		}




		public init(value: String, `default`: String? = nil, allowable: [String], listener: Listener? = nil) {
			self.value = value
			self.default = `default` ?? value
			self.allowable = Set<String>.init(allowable).asArray
			if !self.allowable.contains(value) {
				self.allowable.append(value)
			}
			if !self.allowable.contains(self.default) {
				self.allowable.append(self.default)
			}
			self.allowable.sort()
			self.listener = listener
		}



		public static func from(binding		: UnsafeMutablePointer<String>,
								default		: String? = nil,
								allowable	: [String],
								listener	: Listener? = nil) -> VariableForString {

			return .init(value		: binding.pointee,
						 default	: `default` ?? binding.pointee,
						 allowable  : allowable,
						 listener	: { v in
							binding.pointee = v
							listener?(v)
			})
		}



	}




	public var key						: String

	public var variableForFloat			: VariableForFloat! = nil
	public var variableForString		: VariableForString! = nil
	public var variableForUIColor		: VariableForUIColor! = nil
	public var variableForUIFont		: VariableForUIFont! = nil

	public var valueForFloat			: Float! 	{ return variableForFloat!.value }
	public var valueForString			: String! 	{ return variableForString!.value }
	public var valueForUIColor			: UIColor! 	{ return variableForUIColor!.value.toUIColor() }
	public var valueForUIFont			: UIFont! 	{ return variableForUIFont!.value.toUIFont() }

	public var f						: Float! 	{ return valueForFloat }
	public var i						: Int! 		{ return valueForFloat?.asInt }
	public var d						: Double! 	{ return valueForFloat?.asDouble }
	public var s						: String! 	{ return valueForString }

	public var asFloat					: Float! 	{ return valueForFloat }
	public var asInt					: Int! 		{ return valueForFloat?.asInt }
	public var asDouble					: Double! 	{ return valueForFloat?.asDouble }
	public var asString					: String! 	{ return valueForString }




	//		public init(from decoder: Decoder) throws {
	//			let values = decoder.container(keyedBy: self)
	//			self.key = try values.decode(String.self, forKey: .key)
	//			self.value = try? values.decode(VariableForFloat.self, forKey: .value) ?? try? values.decode(VariableForString.self, forKey: .value)
	//		}

	public init(key: String) {
		self.key = key
	}

	public init(key: String, value: VariableForString) {
		self.key = key
		self.variableForString = value
	}

	public init(key: String, value: VariableForFloat) {
		self.key = key
		self.variableForFloat = value
	}

	public init(key: String, value: VariableForUIColor) {
		self.key = key
		self.variableForUIColor = value
	}

	public init(key: String, value: VariableForUIFont) {
		self.key = key
		self.variableForUIFont = value
	}



	public init(from: StorableVariable) {
		self.key = from.key
		self.assign(from: from)
	}


	public var color			: UIColor! {
		return variableForUIColor.toUIColor()
	}

	public var font				: UIFont! {
		return variableForUIFont.toUIFont()
	}





	
	public func assign(listener: @escaping (Any)->()) {
		if let p = variableForUIColor {
			p.listener = { v in
				listener(v)
			}
		}
		if let p = variableForUIFont {
			p.listener = { v in
				listener(v)
			}
		}
		if let p = variableForFloat {
			p.listener = { v in
				listener(v)
			}
		}
		if let p = variableForString {
			p.listener = { v in
				listener(v)
			}
		}

	}

	public func assign(key: String? = nil, from: StorableVariable) {
		self.key = key ?? from.key
		if true {
			let listener = self.variableForFloat?.listener
			self.variableForFloat			= from.variableForFloat
			self.variableForFloat?.listener = listener
		}
		if true {
			let listener = self.variableForString?.listener
			self.variableForString		= from.variableForString
			self.variableForString?.listener = listener
		}
		if true {
			let listener = self.variableForUIFont?.listener
			self.variableForUIFont		= from.variableForUIFont
			self.variableForUIFont?.listener = listener
		}
		if true {
			let listener = self.variableForUIColor?.listener
			self.variableForUIColor	= from.variableForUIColor
			self.variableForUIColor?.listener = listener
		}
	}
	
	public func copy(key: String? = nil, cloneListener: Bool) -> StorableVariable? {

		let variable0 = self

		var variable1 : StorableVariable!

		if let v = variable0.variableForFloat {
			variable1 = StorableVariable.init(key: key ?? variable0.key, value: StorableVariable.VariableForFloat.init(value: v.value, default: v.default, min: v.min, max: v.max, step: v.step, listener: cloneListener ? v.listener : nil))
		}
		if let v = variable0.variableForString {
			variable1 = StorableVariable.init(key: key ?? variable0.key, value: StorableVariable.VariableForString.init(value: v.value, default: v.default, allowable: v.allowable, listener: cloneListener ? v.listener : nil))
		}
		if let v = variable0.variableForUIFont {
			variable1 = StorableVariable.init(key: key ?? variable0.key, value: StorableVariable.VariableForUIFont.init(value: v.value, default: v.default, families2names: v.families2names, min: v.min, max: v.max, listener: cloneListener ? v.listener : nil))
		}
		if let v = variable0.variableForUIColor {
			variable1 = StorableVariable.init(key: key ?? variable0.key, value: StorableVariable.VariableForUIColor.init(value: v.value, default: v.default, min: v.min, max: v.max, listener: cloneListener ? v.listener : nil))
		}

		return variable1
	}

	public func clone(key: String? = nil) -> StorableVariable {

		let clone = StorableVariable.init(key: key ?? self.key)

		clone.variableForFloat 		= self.variableForFloat
		clone.variableForString 	= self.variableForString
		clone.variableForUIFont 	= self.variableForUIFont
		clone.variableForUIColor 	= self.variableForUIColor

		return clone
	}
}

