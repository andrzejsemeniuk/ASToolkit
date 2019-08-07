//
//  UICalibratorForStorableVariables.swift
//  ASToolkit
//
//  Created by andrej on 6/8/19.
//  Copyright © 2019 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit




class UICalibratorForStorableVariables : UICalibrator {



	var manager 				: StorableVariableManager




	init(manager: StorableVariableManager, listener: @escaping Listener) {

		self.manager = manager

		super.init(heading: manager.key, listener: listener)

		manager.load(overwrite: true)

		buttonExit.addTapIfSelected { [weak self] in
			self?.manager.store()
			//			self?.view.isUserInteractionEnabled = editor?.isHidden ?? true
		}

		define(properties: manager.variables.map { .from(storableVariable: $0) })
	}

	convenience init(key: String, listener: @escaping Listener) {
		self.init(manager: StorableVariableManager.init(key: key), listener: listener)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}







	public func put(variables: [StorableVariable], overwrite: Bool) {
		manager.put(variables: variables, overwrite: overwrite)

		define(properties: manager.variables.map { .from(storableVariable: $0) })
	}


}






extension UICalibratorForStorableVariables {

	static func create(on view: UIView, for key: String, listener: @escaping Listener) -> UICalibratorForStorableVariables {

		let editor = UICalibratorForStorableVariables.init(key: key, listener: listener)

		view.addSubview(editor)

		editor.constrainToSuperview()

		return editor
	}

	static func create(on view: UIView, with variables: [StorableVariable], for key: String, listener: @escaping Listener) -> UICalibratorForStorableVariables {

		let editor = UICalibratorForStorableVariables.init(key: key, listener: listener)

		view.addSubview(editor)

		editor.constrainToSuperview()

		editor.put(variables: variables, overwrite: true)

		return editor
	}


	static func create(on view: UIView, with manager: StorableVariableManager, listener: @escaping Listener) -> UICalibratorForStorableVariables {

		let editor = UICalibratorForStorableVariables.init(manager: manager, listener: listener)

		view.addSubview(editor)

		editor.constrainToSuperview()

		return editor
	}


}
