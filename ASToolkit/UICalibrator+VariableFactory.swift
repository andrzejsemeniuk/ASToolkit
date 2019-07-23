//
//  UICalibrator+VariableFactory.swift
//  ASToolkit
//
//  Created by andrej on 7/19/19.
//  Copyright © 2019 Andrzej Semeniuk. All rights reserved.
//

import Foundation

extension UICalibrator {



	open class VariableFactory {

		public typealias Updater = (_ key: String, _ representation: Any)->()

		static public func create(_ updater: @escaping Updater = { _,_ in }) -> VariableFactory {
			return .init(updater)
		}

		internal init(_ updater: @escaping Updater) {
			self.updater = updater
		}

		public var updater : Updater


		open func variableForColor(_ key: String,
								   binding: UnsafeMutablePointer<UIColor>,
								   min: StorableVariable.VariableForUIColor.Value = .zero,
								   max: StorableVariable.VariableForUIColor.Value = .one) -> StorableVariable {
			return StorableVariable.init(key: key, value: StorableVariable.VariableForUIColor.from(binding: binding, min: min, max: max, listener: { [weak self] v in
				self?.updater(key,v)
			}))
		}

		open func variableForFont(_ key: String,
								  binding: UnsafeMutablePointer<UIFont>,
								  names: [String] = UIFont.fontNames,
								  size: (min: Float, max:Float) = (3,144)) -> StorableVariable {
			return StorableVariable.init(key: key, value: StorableVariable.VariableForUIFont.from(binding: binding, min: size.min, max: size.max, listener: { [weak self] v in
				self?.updater(key,v)
			}))
		}

		open func variableForFloat(_ key: String,
								   binding: UnsafeMutablePointer<Float>,
								   min: Float = 0,
								   max: Float = 1,
								   step: Float = 0.01) -> StorableVariable {
			return StorableVariable.init(key: key, value: StorableVariable.VariableForFloat.from(binding: binding, min: min, max: max, step: step, listener: { [weak self] v in
				self?.updater(key,v)
			}))
		}

		open func variableForCGFloat(_ key: String,
									 binding: UnsafeMutablePointer<CGFloat>,
									 min: Float = 0,
									 max: Float = 1,
									 step: Float = 0.01) -> StorableVariable {
			return StorableVariable.init(key: key, value: StorableVariable.VariableForFloat.init(value: Float(binding.pointee), default: Float(binding.pointee), min: min, max: max, step: step, listener: { [weak self] v in
				binding.pointee = CGFloat(v)
				self?.updater(key,v)
			}))
		}

		public typealias BlockVoidVoid = ()->()

		open func variableForFloat(_ title	: String,
								   binding	: UnsafeMutablePointer<Float>,
								   min		: Float = 0,
								   max		: Float = 1,
								   step		: Float = 0,
								   snap		: Bool = false,
								   circular	: Bool = true,
								   updater	: BlockVoidVoid? = nil) -> UICalibrator.Variable {
			return UICalibrator.Variable.init(title	: title,
											  slider	: .init(initial: binding.pointee, min: min, max: max, step: step, snap: snap, circular: circular /* unit: "m" */),
											  getter	: { binding.pointee },
											  setter	: { v in
												binding.pointee = v
												updater?()
			}
			)
		}

		open func variableForDetailedFloat(_ title	: String,
										   getter	: @escaping ()->Float,
										   setter  	: @escaping (Float)->(),
										   min		: Float = 0,
										   max		: Float = 1,
										   step		: Float = 0,
										   snap		: Bool = false,
										   circular	: Bool = true,
										   updater	: BlockVoidVoid? = nil) -> UICalibrator.Variable {
			return UICalibrator.Variable.init(title	: title,
											  slider	: .init(initial: Float(getter()), min: min, max: max, step: step, snap: snap, circular: circular /* unit: "m" */),
											  getter	: { Float(getter()) },
											  setter	: { v in
												setter(Float(v))
												updater?()
			}
			)
		}

		open func variableForCGFloat(_ title	: String,
									 binding	: UnsafeMutablePointer<CGFloat>,
									 min		: Float = 0,
									 max		: Float = 1,
									 step		: Float = 0,
									 snap		: Bool = false,
									 circular	: Bool = true,
									 updater	: BlockVoidVoid? = nil) -> UICalibrator.Variable {
			return UICalibrator.Variable.init(title	: title,
											  slider	: .init(initial: Float(binding.pointee), min: min, max: max, step: step, snap: snap, circular: circular /* unit: "m" */),
											  getter	: { Float(binding.pointee) },
											  setter	: { v in
												binding.pointee = CGFloat(v)
												updater?()
			}
			)
		}

		open func variableForDetailedCGFloat(_ title	: String,
											 getter	: @escaping ()->CGFloat,
											 setter  : @escaping (CGFloat)->(),
											 min		: Float = 0,
											 max		: Float = 1,
											 step		: Float = 0,
											 snap		: Bool = false,
											 circular	: Bool = true,
											 updater	: BlockVoidVoid? = nil) -> UICalibrator.Variable {
			return UICalibrator.Variable.init(title	: title,
											  slider	: .init(initial: Float(getter()), min: min, max: max, step: step, snap: snap, circular: circular /* unit: "m" */),
											  getter	: { Float(getter()) },
											  setter	: { v in
												setter(CGFloat(v))
												updater?()
			})
		}

		open func variableForDouble(_ title		: String,
									binding		: UnsafeMutablePointer<Double>,
									min			: Double = 0,
									max			: Double = 1,
									step		: Double = 0,
									snap		: Bool = false,
									circular	: Bool = true,
									updater		: BlockVoidVoid? = nil) -> UICalibrator.Variable {
			return UICalibrator.Variable.init(title	: title,
											  slider	: .init(initial: Float(binding.pointee), min: Float(min), max: Float(max), step: Float(step), snap: snap, circular: circular /* unit: "m" */),
											  getter	: { Float(binding.pointee) },
											  setter	: { v in
												binding.pointee = Double(v)
												updater?()
			}
			)
		}

		open func variableForDetailedDouble(_ title		: String,
											getter		: @escaping ()->Double,
											setter  	: @escaping (Double)->(),
											min			: Float = 0,
											max			: Float = 1,
											step		: Float = 0,
											snap		: Bool = false,
											circular	: Bool = true,
											updater	: BlockVoidVoid? = nil) -> UICalibrator.Variable {
			return UICalibrator.Variable.init(title	: title,
											  slider	: .init(initial: Float(getter()), min: min, max: max, step: step, snap: snap, circular: circular /* unit: "m" */),
											  getter	: { Float(getter()) },
											  setter	: { v in
												setter(Double(v))
												updater?()
			}
			)
		}


		open func variableForInt	(_ title	: String,
									 binding	: UnsafeMutablePointer<Int>,
									 min		: Int,
									 max		: Int,
									 step		: Int = 1,
									 circular	: Bool = true,
									 updater	: BlockVoidVoid? = nil) -> UICalibrator.Variable {
			return UICalibrator.Variable.init(title	: title,
											  slider	: .init(initial: Float(binding.pointee), min: Float(min), max: Float(max), step: Float(step), snap: true, circular: circular /* unit: "m" */),
											  getter	: { Float(binding.pointee) },
											  setter	: { v in
												binding.pointee = Int(v)
												updater?()
			}
			)
		}

		open func variableForDetailedInt(_ title		: String,
										 getter	: @escaping ()->Int,
										 setter  	: @escaping (Int)->(),
										 min		: Int,
										 max		: Int,
										 step		: Int = 1,
										 snap		: Bool = false,
										 circular	: Bool = true,
										 updater	: BlockVoidVoid? = nil) -> UICalibrator.Variable {
			return UICalibrator.Variable.init(title	: title,
											  slider	: .init(initial: Float(getter()), min: Float(min), max: Float(max), step: Float(step), snap: true, circular: circular /* unit: "m" */),
											  getter	: { Float(getter()) },
											  setter	: { v in
												setter(Int(v))
												updater?()
			}
			)
		}

		open func variableForBool(_ title	: String,
								  binding	: UnsafeMutablePointer<Bool>,
								  updater	: BlockVoidVoid? = nil) -> UICalibrator.Variable {
			return UICalibrator.Variable.init(title	: title,
											  slider	: .init(initial	: Float(binding.pointee ? 1 : 0),
																min	: Float(0),
																max	: Float(1),
																step	: Float(1),
																snap	: true /* unit: "m" */),
											  getter	: { Float(binding.pointee ? 1 : 0) },
											  setter	: { v in
												binding.pointee = v != 0
												updater?()
			}
			) { v in
				v != 0 ? "T" : "F"
			}
		}

		open func variableForDetailedBool(_ title	: String,
										  getter		: @escaping ()->Bool,
										  setter		: @escaping (Bool)->(),
										  updater	: BlockVoidVoid? = nil) -> UICalibrator.Variable {
			return UICalibrator.Variable.init(title	: title,
											  slider	: .init(initial	: Float(getter() ? 1 : 0),
																min	: Float(0),
																max	: Float(1),
																step	: Float(1),
																snap	: true /* unit: "m" */),
											  getter	: { Float(getter() ? 1 : 0) },
											  setter	: { v in
												setter(v != 0)
												updater?()
			}
			) { v in
				v != 0 ? "T" : "F"
			}
		}

		open func variableForCustom(_ title	: String,
									getter	: @escaping UICalibrator.Variable.Getter,
									setter	: @escaping UICalibrator.Variable.Setter,
									min		: Float = 0,
									max		: Float = 1,
									step		: Float = 0,
									snap		: Bool = false,
									circular	: Bool = true,
									updater	: BlockVoidVoid? = nil) -> UICalibrator.Variable {
			return UICalibrator.Variable.init(title	: title,
											  slider	: .init(initial: getter() ?? min, min: min, max: max, step: step, snap: snap, circular: circular /* unit: "m" */),
											  getter	: getter,
											  setter	: { v in
												setter(v)
												updater?()
			}
			)
		}



	}

}

