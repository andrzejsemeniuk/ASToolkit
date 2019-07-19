//
//  UICalibratorForStorableProperties.swift
//  ASToolkit
//
//  Created by andrej on 6/8/19.
//  Copyright © 2019 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit




class UICalibratorForStorableProperties : UICalibrator {



	var manager 				: StorablePropertyManager




	init(manager: StorablePropertyManager, listener: @escaping Listener) {

		self.manager = manager

		super.init(heading: manager.key, listener: listener)

		manager.load(overwrite: true)

		buttonExit.addTapIfSelected { [weak self] in
			self?.manager.store()
			//			self?.view.isUserInteractionEnabled = editor?.isHidden ?? true
		}

		define(properties: manager.properties.map { .from(storableProperty: $0) })
	}

	convenience init(key: String, listener: @escaping Listener) {
		self.init(manager: StorablePropertyManager.init(key: key), listener: listener)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}







	public func put(properties: [StorableProperty], overwrite: Bool) {
		manager.put(properties: properties, overwrite: overwrite)

		define(properties: manager.properties.map { .from(storableProperty: $0) })
	}


}






extension UICalibratorForStorableProperties {

	static func create(on view: UIView, for key: String, listener: @escaping Listener) -> UICalibratorForStorableProperties {

		let editor = UICalibratorForStorableProperties.init(key: key, listener: listener)

		view.addSubview(editor)

		editor.constrainToSuperview()

		return editor
	}

	static func create(on view: UIView, with properties: [StorableProperty], for key: String, listener: @escaping Listener) -> UICalibratorForStorableProperties {

		let editor = UICalibratorForStorableProperties.init(key: key, listener: listener)

		view.addSubview(editor)

		editor.constrainToSuperview()

		editor.put(properties: properties, overwrite: true)

		return editor
	}


	static func create(on view: UIView, with manager: StorablePropertyManager, listener: @escaping Listener) -> UICalibratorForStorableProperties {

		let editor = UICalibratorForStorableProperties.init(manager: manager, listener: listener)

		view.addSubview(editor)

		editor.constrainToSuperview()

		return editor
	}


}
