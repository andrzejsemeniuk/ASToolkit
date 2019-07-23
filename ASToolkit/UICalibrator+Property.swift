//
//  UICalibrator+Property.swift
//  ASToolkit
//
//  Created by andrej on 6/8/19.
//  Copyright © 2019 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

// closures:
//  format?  v to string
//  update?
//  allow/decline/validate

extension UICalibrator {


	public class Property {

		public enum Kind : String {
			case float
			case string
			case color
			case font
			case array
		}

		let kind        	: Kind

		let valuator 		: ()->Any?

		var selectedIndex	: Int {
			get {
				return cache[configuration]!.index
			}
			set {
				cache[configuration]!.index = newValue
			}
		}

		let title 						: String

		public typealias Configurator 	= (String)->[Variable]

		private var configurator 		: Configurator = { _ in [] }
		private(set) var configurations : [String]
		var configurationIndex 			: Int = 0

		typealias Configuration 		= (index: Int, variables: [Variable])
		private var cache 				: [String : Configuration] = [:]

		public init(kind: Kind, title: String, valuator: @escaping ()->Any?, configurations: [String], configurator: @escaping Configurator) {
			self.kind = kind
			self.title = title
			self.valuator = valuator
			self.configurations = configurations
			self.configurator = configurator
			for configuration in configurations {
				self.cache[configuration] = (index: 0, variables: configurator(configuration))
			}
		}

		public init(title: String, variables: [Variable]) {
			self.kind = .array
			self.title = title
			self.valuator = { nil }
			self.configurations = ["*"] // [variables.map { $0.title }.joined(separator: "/")]
			//			self.configurator = { _ in return [] }
			self.cache[configuration] = (index: 0, variables: variables)
		}

		var configuration : String {
			return configurations[configurationIndex]
		}

		var variables : [Variable] {
			//			return cache[configuration]!.variables
			return variablesForConfiguration(configuration)
		}

		var valueToString : (_ property: Property)->String = { property in
			let values : [String] = property.variables.map { "(\($0.title)=\($0.value))" }
			return "[\(property.kind.rawValue) : \"\(property.title)\" : \(property.configuration)=\(values)]"
		}

		var valueAsString : String {
			return valueToString(self)
		}

		func variablesForConfiguration(_ configuration: String) -> [Variable] {
			return cache[configuration]!.variables
		}

	}

}

extension UICalibrator.Property {

	static func from(storableProperty: StorableVariable) -> UICalibrator.Property {

		if let value = storableProperty.variableForUIColor {

			let step = Float(1.0/255.0)

			let a = UICalibrator.Variable.init(title: "A", slider: .init(initial		: value.value.a,
																		 default	: value.default.a,
																		 min		: value.min.a,
																		 max 		: value.max.a,
																		 step	 	: step,
																		 snap		: true),
											   getter		: { value.value.a },
											   setter		: { value.valueAssignRGBA(a: $0) },
											   listener	: { String($0) }
			)

			let abgr = [
				a,

				UICalibrator.Variable.init(title: "B", slider: .init(	initial		: value.value.b,
																		 default	: value.default.b,
																		 min		: value.min.b,
																		 max 		: value.max.b,
																		 step	 	: step,
																		 snap		: true),
										   getter		: { value.value.b },
										   setter		: { value.valueAssignRGBA(b: $0) },
										   listener	: { String($0) }
				),

				UICalibrator.Variable.init(title: "G", slider: .init(	initial		: value.value.g,
																		 default	: value.default.g,
																		 min		: value.min.g,
																		 max 		: value.max.g,
																		 step	 	: step,
																		 snap		: true),
										   getter		: { value.value.g },
										   setter		: { value.valueAssignRGBA(g: $0) },
										   listener	: { String($0) }
				),

				UICalibrator.Variable.init(title: "R",
										   slider: .init(	initial		: value.value.r,
															 default		: value.default.r,
															 min			: value.min.r,
															 max 		: value.max.r,
															 step	 	: step,
															 snap		: true),
										   getter		: { value.value.r },
										   setter		: { value.valueAssignRGBA(r: $0) },
										   listener	: { String($0) }
				)

			]


			let aw = [a,

					  UICalibrator.Variable.init(title: "W", slider: .init(	initial		: Float(value.value.toUIColor().WA.white),
																			   default	: Float(value.default.toUIColor().WA.white),
																			   min		: 0, //value.min.b,
						max 		: 1, //value.max.b,
						step	 	: step,
						snap		: true),
												 getter	: { value.value.wa.w },
												 setter	: { value.valueAssignRGBA(r: $0, g: $0, b: $0) },
												 listener	: { String($0) }
				)
			]





			let absh = [a,


						UICalibrator.Variable.init(title: "V", slider: .init(	initial		: Float(value.value.toUIColor().HSBA.brightness),
																				 default	: Float(value.default.toUIColor().HSBA.brightness),
																				 min		: 0, //value.min.b,
							max 		: 1, //value.max.b,
							step	 	: step,
							snap		: true),
												   getter	: { Float(value.value.hsba.brightness) },
												   setter	: { value.valueAssignHSBA(b: $0) },
												   listener: { String($0) }
				),

						UICalibrator.Variable.init(title: "S", slider: .init(	initial		: Float(value.value.toUIColor().HSBA.saturation),
																				 default	: Float(value.default.toUIColor().HSBA.saturation),
																				 min		: 0, //value.min.g,
							max 		: 1, //value.max.g,
							step	 	: step,
							snap		: true),
												   getter	: { Float(value.value.hsba.saturation) },
												   setter	: { value.valueAssignHSBA(s: $0) },
												   listener: { String($0) }
				),

						UICalibrator.Variable.init(title: "H", slider: .init(	initial		: Float(value.value.toUIColor().HSBA.hue),
																				 default	: Float(value.default.toUIColor().HSBA.hue),
																				 min		: 0, //value.min.r,
							max 		: 1, //value.max.r,
							step	 	: step,
							snap		: true),
												   getter	: { Float(value.value.hsba.hue) },
												   setter	: { value.valueAssignHSBA(h: $0) },
												   listener: { String($0) }
				)

			]



			let property = UICalibrator.Property.init(kind	: .color,
													  title	: storableProperty.key,
													  valuator: { [weak value] in value?.value.toUIColor() },
													  configurations: ["RGBA","HSVA","WA"])
			{ configuration in

				switch configuration
				{
				case "RGBA":	return abgr
				case "WA":		return aw
				default:		return absh
				}
			}

			//			property.valueAsString = {
			//
			//			}

			return property
		}

		if let value = storableProperty.variableForUIFont {


			let families : [String] = value.families2names.keys.compactMap({ $0 }).sorted()

			let names = value.families2names.values.flatMap({ $0 }).sorted()

			//			let name2family : [String : String] = value.families2names.map { (arg)->(String:String) in
			//				let (family, names) = arg
			//				return names.map { [$0 : family] }
			//				var r : [String : String]
			//				return r
			//			}

			var name2family : [String : String] = [:]
			value.families2names.forEach { (arg) in
				let (family, names) = arg
				names.forEach {
					name2family[$0] = family
				}
			}

			//			print("families=\(families.count)")

			class Holder : NSObject {
				var family 	: String 	= ""
				var name 	: String 	= ""
				var names 	: [String] 	= []
			}

			let holder = Holder()




			return UICalibrator.Property.init(kind: .font,
											  title: storableProperty.key,
											  valuator: { [weak value] in
												return value?.value.toUIFont()
				},
											  configurations: ["Name+Size", "Family+Name+Size"])
			{ configuration in

				// "Name" -> "N" // cut
				// "Name" -> "name" // decapitalize
				// "stripping information"
				//  S0 -> S1, |S1| < |S0|

				// configurations:
				//  families, fonts, sizes
				//  fonts, sizes




				let s = UICalibrator.Variable.init(title	: "Size",
												   slider	: .init(		initial		: Float(value.value.size),
																			 default		: Float(value.default.size),
																			 min			: Float(value.min),
																			 max 		: Float(value.max),
																			 step	 	: Float(1),
																			 snap		: true),
												   getter: { value.value.size },
												   setter: { value.valueAssign(size: $0) }
				)



				let n1 = UICalibrator.Variable.init(title	: "Name",
													slider	: .init(	  initial			: Float(names.index(of:value.value.name) ?? 0),
																			default		: Float(names.index(of:value.default.name) ?? 0),
																			min			: Float(0),
																			max 			: Float(names.count-1),
																			step	 		: Float(1),
																			snap			: true),
													getter		: { Float(names.index(of: value.value.name) ?? 0) },
													setter		: { v in

														let index = Int(round(v))

														let name = names[index]

														holder.family = name2family[name] ?? families[0]
														holder.name = name

														value.valueAssign(name: name)
				},
													listener		: { _ in value.value.name }
				)






				let n2 = UICalibrator.Variable.init(
					title	: "Name",
					slider	: .init(	  initial			: Float(0),
											default		: Float(0),
											min			: Float(0),
											max 			: Float(0),
											step	 		: Float(1),
											snap			: true),
					getter		: { Float(holder.names.index(of: value.value.name) ?? 0) },
					setter		: { v in

						let index = Int(round(v))

						if let name = holder.names[safe: index] {
							holder.name = name
							value.valueAssign(name: name)
						}

				},
					listener		: { _ in value.value.name }
				)





				let f = UICalibrator.Variable.init(
					title	: "Family",
					slider	: .init(	  initial			: Float(families.index(of: value.value.toUIFont()?.familyName ?? "") ?? 0),
											default		: Float(families.index(of: value.default.toUIFont()?.familyName ?? "") ?? 0),
											min			: Float(0),
											max 			: Float(families.count - 1),
											step	 		: Float(1),
											snap			: true),
					getter		: {
						Float(families.index(of: holder.family) ?? 0)
				},
					setter		: { [weak n2] v in
						let index = Int(round(v))
						let family = families[index]

						holder.family = family
						holder.names = value.families2names[family]?.sorted() ?? []

						//						value.value.name = UIFont.familiesAndNames[family]?.first ?? UIFont.defaultFont.fontName

						n2?.slider.max = Float((UIFont.familiesAndNames[family]?.count ?? 1) - 1)
						//						print("slider=\(String(describing: n2?.slider))")
						n2?.value = Float(holder.names.index(of: value.value.name) ?? 0)
						n2?.redefine = true
					},
					listener	: { v in
						holder.family
				}
				)





				switch configuration {

				case "Name+Size":

					return [s,n1]


				default:

					n2.redefine = true

					return [s,n2,f]

				}
			}
		}

		if let value = storableProperty.variableForFloat {

			return UICalibrator.Property.init(kind	: .float,
											  title	: storableProperty.key,
											  valuator: { [weak value] in
												return value?.value
				},
											  configurations	: ["Float"])
			{ configuration in

				let r = UICalibrator.Variable.init(title: "Value", slider: .init(	initial		: value.value,
																					 default	: value.default,
																					 min		: value.min,
																					 max 		: value.max,
																					 step	 	: abs(value.step),
																					 snap		: value.isSnappy))
				{ [weak storableProperty] v in

					guard let storableProperty = storableProperty else { return "" }

					storableProperty.variableForFloat.value = v

					return String(v)
				}

				return [r]
			}
		}

		if let value = storableProperty.variableForString {

			return UICalibrator.Property.init(kind	: .string,
											  title	: storableProperty.key,
											  valuator: { [weak value] in
												return value?.value
				},
											  configurations: ["String"])
			{ configuration in

				let r = UICalibrator.Variable.init(title: "Value", slider: .init(	initial			: Float(value.allowable.index(of:value.value)!),
																					 default		: Float(value.allowable.index(of:value.default)!),
																					 min			: 0,
																					 max 			: Float(value.allowable.count-1),
																					 step	 		: 1,
																					 snap			: true))
				{ [weak storableProperty] v in

					guard let storableProperty = storableProperty else { return "" }

					let index = Int(round(v))

					storableProperty.variableForString.value = value.allowable[index]

					return storableProperty.variableForString.value
				}

				return [r]
			}

		}

		return UICalibrator.Property.init(kind	: .float,
										  title	: storableProperty.key,
										  valuator: { nil },
										  configurations: ["Error"]) { _ in
											return []
		}

	}


}


extension Array {

	public func cross(_ other: Array) -> [String] {
		var r : [String] = []
		for e in self {
			for o in other {
				r.append("\(e)\(o)")
			}
		}
		return r
	}

}


